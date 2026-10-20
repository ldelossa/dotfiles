import assert from "node:assert/strict";
import { existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";
import { discoverAndLoadExtensions } from "@earendil-works/pi-coding-agent";

const extensionPath = fileURLToPath(new URL("../index.ts", import.meta.url));

async function fixture(t, options = {}) {
  const root = mkdtempSync(join(tmpdir(), "edit-last-test-"));
  t.after(() => rmSync(root, { recursive: true, force: true }));
  const loaded = await discoverAndLoadExtensions([extensionPath], root, join(root, "agent"));
  assert.deepEqual(loaded.errors, []);
  const command = loaded.extensions.flatMap((extension) => [...extension.commands.values()])
    .find((registered) => registered.name === "edit-last");
  assert.ok(command);
  loaded.runtime.sendUserMessage = () => assert.fail("Must not send automatically");
  loaded.runtime.sendMessage = () => assert.fail("Must not call a model");

  const reply = options.reply ?? "Use a bounded retry loop.";
  const state = {
    input: "Existing draft", notifications: [], editors: [], lifecycle: [], waits: 0,
  };
  const ctx = {
    cwd: root,
    mode: options.mode ?? "rpc",
    hasUI: true,
    waitForIdle: async () => { state.waits += 1; },
    sessionManager: {
      getBranch: () => options.entries ?? [{ type: "message", message: { role: "assistant", content: reply } }],
    },
    ui: {
      notify: (message, level) => state.notifications.push({ message, level }),
      editor: async (title, initial) => {
        state.editors.push({ title, initial });
        return Object.hasOwn(options, "edited") ? options.edited : `${reply}\nWhy retry?`;
      },
      setEditorText: (text) => { state.input = text; },
      custom: async (factory) => {
        let result;
        let completed = false;
        const tui = {
          stop: () => state.lifecycle.push("stop"),
          start: () => state.lifecycle.push("start"),
          requestRender: (force) => { assert.equal(force, true); state.lifecycle.push("render"); },
        };
        await factory(tui, {}, {}, (value) => { result = value; completed = true; });
        assert.equal(completed, true);
        return result;
      },
    },
  };
  return { root, state, ctx, run: () => command.handler("", ctx) };
}

function externalEditor(t, directory, behavior) {
  const previousVisual = process.env.VISUAL;
  const previousEditor = process.env.EDITOR;
  t.after(() => {
    if (previousVisual === undefined) delete process.env.VISUAL;
    else process.env.VISUAL = previousVisual;
    if (previousEditor === undefined) delete process.env.EDITOR;
    else process.env.EDITOR = previousEditor;
  });
  const script = join(directory, "fake-editor.mjs");
  const marker = join(directory, "edited-file-path");
  writeFileSync(script, [
    'import { readFileSync, writeFileSync } from "node:fs";',
    "const file = process.argv[2];",
    `writeFileSync(${JSON.stringify(marker)}, file);`,
    behavior,
  ].join("\n"));
  process.env.VISUAL = `${process.execPath} ${script}`;
  process.env.EDITOR = "must-not-run-this-editor";
  return marker;
}

test("loads extracted annotations, not the original response", async (t) => {
  const f = await fixture(t, {
    reply: "First unrelated line.\nUse retries.\nLast unrelated line.",
    edited: "First unrelated line.\nUse retries.\nWhy retry?\nLast unrelated line.",
  });
  await f.run();
  assert.equal(f.state.waits, 1);
  assert.equal(f.state.editors[0].initial, "First unrelated line.\nUse retries.\nLast unrelated line.");
  assert.ok(f.state.input.includes("> Use retries."));
  assert.ok(f.state.input.includes("Why retry?"));
  assert.ok(!f.state.input.includes("First unrelated line."));
  assert.ok(!f.state.input.includes("Last unrelated line."));
  assert.match(f.state.notifications.at(-1).message, /Review and press Enter/);
});

test("cancelling the editor leaves the draft untouched", async (t) => {
  const f = await fixture(t, { edited: undefined });
  await f.run();
  assert.equal(f.state.input, "Existing draft");
  assert.match(f.state.notifications.at(-1).message, /Cancelled/);
});

test("unchanged edits leave the draft untouched", async (t) => {
  const f = await fixture(t, { edited: "Use a bounded retry loop.\n" });
  await f.run();
  assert.equal(f.state.input, "Existing draft");
  assert.match(f.state.notifications.at(-1).message, /No added questions or comments/);
});

test("deletion-only edits leave the draft untouched", async (t) => {
  const f = await fixture(t, { reply: "A\nB", edited: "A" });
  await f.run();
  assert.equal(f.state.input, "Existing draft");
});

test("finds the latest assistant text on the active branch only", async (t) => {
  const f = await fixture(t, {
    entries: [
      { type: "message", message: { role: "assistant", content: "Old response." } },
      { type: "message", message: { role: "user", content: "User message." } },
      { type: "message", message: { role: "assistant", content: [
        { type: "thinking", thinking: "Do not expose this." },
        { type: "text", text: "Current response." },
        { type: "text", text: "Second paragraph." },
      ] } },
      { type: "message", message: { role: "assistant", content: [{ type: "toolCall", name: "read" }] } },
      { type: "message", message: { role: "toolResult", content: "Tool output." } },
    ],
    edited: "Current response.\n\nSecond paragraph.\nWhy this recommendation?",
  });
  await f.run();
  assert.equal(f.state.editors[0].initial, "Current response.\n\nSecond paragraph.");
  assert.ok(f.state.input.includes("> Second paragraph."));
  assert.ok(!f.state.input.includes("Do not expose this."));
  assert.ok(!f.state.input.includes("Tool output."));
});

test("missing assistant text does not open an editor or replace the draft", async (t) => {
  const f = await fixture(t, { entries: [] });
  await f.run();
  assert.equal(f.state.editors.length, 0);
  assert.equal(f.state.input, "Existing draft");
  assert.match(f.state.notifications.at(-1).message, /No assistant response/);
});

test("TUI mode without an external editor still uses the built-in editor", async (t) => {
  const f = await fixture(t, { mode: "tui" });
  const previousVisual = process.env.VISUAL;
  const previousEditor = process.env.EDITOR;
  t.after(() => {
    if (previousVisual === undefined) delete process.env.VISUAL;
    else process.env.VISUAL = previousVisual;
    if (previousEditor === undefined) delete process.env.EDITOR;
    else process.env.EDITOR = previousEditor;
  });
  delete process.env.VISUAL;
  delete process.env.EDITOR;
  await f.run();
  assert.equal(f.state.editors.length, 1);
  assert.ok(f.state.input.includes("Why retry?"));
});

test("external editing extracts notes, restores the TUI, and removes its temp file", async (t) => {
  const f = await fixture(t, { mode: "tui" });
  const marker = externalEditor(t, f.root,
    'writeFileSync(file, readFileSync(file, "utf8") + "\\nWhy retry?");');
  await f.run();
  assert.deepEqual(f.state.lifecycle, ["stop", "start", "render"]);
  assert.equal(f.state.editors.length, 0);
  assert.ok(f.state.input.includes("> Use a bounded retry loop."));
  assert.ok(f.state.input.includes("Why retry?"));
  assert.ok(!existsSync(dirname(readFileSync(marker, "utf8"))));
});

test("a nonzero external-editor exit preserves the draft and restores the TUI", async (t) => {
  const f = await fixture(t, { mode: "tui" });
  const marker = externalEditor(t, f.root, "process.exit(1);");
  await f.run();
  assert.equal(f.state.input, "Existing draft");
  assert.deepEqual(f.state.lifecycle, ["stop", "start", "render"]);
  assert.ok(!existsSync(dirname(readFileSync(marker, "utf8"))));
});
