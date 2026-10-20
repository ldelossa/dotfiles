import { spawn } from "node:child_process";
import { mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI, ExtensionCommandContext } from "@earendil-works/pi-coding-agent";
import { buildFollowUp } from "./annotations.js";

type ContentBlock = {
  type?: string;
  text?: string;
};

type AssistantMessage = {
  role?: string;
  content?: unknown;
};

type MessageEntry = {
  type?: string;
  message?: AssistantMessage;
};

const extractText = (content: unknown): string => {
  if (typeof content === "string") {
    return content;
  }

  if (!Array.isArray(content)) {
    return "";
  }

  return content
    .map((block) => {
      if (!block || typeof block !== "object") {
        return "";
      }
      const contentBlock = block as ContentBlock;
      return contentBlock.type === "text" && typeof contentBlock.text === "string"
        ? contentBlock.text
        : "";
    })
    .filter((text) => text.trim().length > 0)
    .join("\n\n");
};

const findLatestResponse = (ctx: ExtensionCommandContext): string | undefined => {
  const branch = ctx.sessionManager.getBranch() as MessageEntry[];

  for (let index = branch.length - 1; index >= 0; index -= 1) {
    const entry = branch[index];
    if (entry?.type !== "message" || entry.message?.role !== "assistant") {
      continue;
    }

    const text = extractText(entry.message.content).trim();
    if (text.length > 0) {
      return text;
    }
  }

  return undefined;
};

const resolveExternalEditor = (): string | undefined => {
  const visual = process.env.VISUAL?.trim();
  if (visual) {
    return visual;
  }

  const editor = process.env.EDITOR?.trim();
  return editor || undefined;
};

const runExternalEditor = async (
  command: string,
  content: string,
  cwd: string,
): Promise<string | undefined> => {
  const directory = await mkdtemp(join(tmpdir(), "pi-edit-last-"));
  const filePath = join(directory, "response.md");
  await writeFile(filePath, content, "utf-8");

  try {
    const [editor, ...editorArgs] = command.split(/\s+/).filter(Boolean);
    const exitCode = await new Promise<number | null>((resolve) => {
      const child = spawn(editor, [...editorArgs, filePath], {
        cwd,
        stdio: "inherit",
        shell: process.platform === "win32",
      });
      child.on("error", () => resolve(null));
      child.on("close", (code) => resolve(code));
    });

    if (exitCode !== 0) {
      return undefined;
    }

    return (await readFile(filePath, "utf-8")).replace(/^\uFEFF/, "").replace(/\n$/, "");
  } finally {
    await rm(directory, { recursive: true, force: true });
  }
};

const openExternalEditor = (
  ctx: ExtensionCommandContext,
  command: string,
  content: string,
): Promise<string | undefined> => {
  return ctx.ui.custom<string | undefined>(async (tui, _theme, _keybindings, done) => {
    tui.stop();
    let result: string | undefined;
    try {
      process.stdout.write(
        `Launching external editor: ${command}\nPi will resume when the editor exits.\n`,
      );
      result = await runExternalEditor(command, content, ctx.cwd);
    } finally {
      tui.start();
      tui.requestRender(true);
    }
    done(result);
    return { render: () => [], invalidate: () => {} };
  });
};

export default function (pi: ExtensionAPI) {
  pi.registerCommand("edit-last", {
    description: "Annotate the latest assistant response, then load only your additions with source anchors",
    handler: async (_args, ctx) => {
      await ctx.waitForIdle();

      const text = findLatestResponse(ctx);
      if (!text) {
        ctx.ui.notify(
          "No assistant response with text found on the current branch.",
          "warning",
        );
        return;
      }

      const external = ctx.mode === "tui" ? resolveExternalEditor() : undefined;
      const edited = external
        ? await openExternalEditor(ctx, external, text)
        : await ctx.ui.editor("Edit latest response", text);

      if (edited === undefined) {
        ctx.ui.notify("Cancelled. Input unchanged.", "info");
        return;
      }

      let followUp: string | undefined;
      try {
        followUp = buildFollowUp(text, edited);
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        ctx.ui.notify(`${message} Input unchanged.`, "error");
        return;
      }

      if (!followUp) {
        ctx.ui.notify("No added questions or comments. Input unchanged.", "info");
        return;
      }

      ctx.ui.setEditorText(followUp);
      ctx.ui.notify("Loaded follow-up annotations into the input. Review and press Enter to send.", "info");
    },
  });
}
