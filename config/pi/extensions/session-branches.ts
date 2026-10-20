import { existsSync, statSync } from "node:fs";
import {
	SessionManager,
	type ExtensionAPI,
	type ExtensionCommandContext,
} from "@earendil-works/pi-coding-agent";

/** Named session copies with durable parent navigation, without model calls. */
export default function sessionBranches(pi: ExtensionAPI) {
	let navigating = false;

	function ready(ctx: ExtensionCommandContext): boolean {
		if (!ctx.isIdle() || ctx.hasPendingMessages()) {
			ctx.ui.notify("Wait for the current response and queued messages before switching sessions.", "warning");
			return false;
		}
		return true;
	}

	async function navigate(ctx: ExtensionCommandContext, action: () => Promise<void>) {
		if (navigating) {
			ctx.ui.notify("A session navigation is already in progress.", "warning");
			return;
		}
		if (!ready(ctx)) return;
		navigating = true;
		try {
			await action();
		} finally {
			navigating = false;
		}
	}

	pi.registerCommand("branch", {
		description: "Clone the current conversation into a named session: /branch [name]",
		handler: async (args, ctx) => navigate(ctx, async () => {
			const parentFile = ctx.sessionManager.getSessionFile();
			if (!parentFile || !existsSync(parentFile) || !ctx.sessionManager.getLeafId()) {
				ctx.ui.notify("Send a message in a saved session before branching.", "warning");
				return;
			}

			let name = args.trim();
			if (!name) {
				if (!ctx.hasUI) {
					ctx.ui.notify("Usage: /branch <session name>", "warning");
					return;
				}
				const input = await ctx.ui.input("Branch session", "Session name");
				if (input === undefined) return;
				name = input.trim();
			}
			if (!name || /[\u0000-\u001f\u007f]/u.test(name)) {
				ctx.ui.notify("Enter a nonempty, single-line session name.", "warning");
				return;
			}
			if (!ready(ctx)) return;

			// Use the same storage primitive as native /clone, on a separate manager.
			// Name the child before loading it, without mutating the live parent or
			// reusing an ExtensionAPI that becomes stale after session replacement.
			const child = SessionManager.open(parentFile, ctx.sessionManager.getSessionDir());
			const childFile = child.createBranchedSession(ctx.sessionManager.getLeafId()!);
			if (!childFile) throw new Error("Could not create a saved child session.");
			child.appendSessionInfo(name);

			const result = await ctx.switchSession(childFile, {
				withSession: async (next) => {
					next.ui.notify(`Branched to "${name}". Use /return to go back.`, "info");
				},
			});
			if (result.cancelled) {
				ctx.ui.notify(`Created "${name}", but switching was cancelled. It is available in /resume.`, "warning");
			}
		}),
	});

	pi.registerCommand("return", {
		description: "Return to this session's immediate parent, keeping the child saved",
		handler: async (args, ctx) => navigate(ctx, async () => {
			if (args.trim()) {
				ctx.ui.notify("Usage: /return", "warning");
				return;
			}
			const parentFile = ctx.sessionManager.getHeader()?.parentSession;
			if (!parentFile) {
				ctx.ui.notify("This session has no parent.", "warning");
				return;
			}
			if (!existsSync(parentFile) || !statSync(parentFile).isFile()) {
				ctx.ui.notify(`Parent session is missing: ${parentFile}`, "error");
				return;
			}
			await ctx.switchSession(parentFile, {
				withSession: async (next) => {
					next.ui.notify("Returned to parent. The child is still available in /resume.", "info");
				},
			});
		}),
	});

	pi.registerShortcut("ctrl+shift+b", {
		description: "Prompt for a name and branch the current session",
		handler: (ctx) => {
			if (!ctx.hasUI || !ctx.isIdle() || ctx.hasPendingMessages()) {
				ctx.ui.notify("Wait until Pi is idle before branching.", "warning");
				return;
			}
			// Shortcuts lack command-only session APIs. Dispatch our command instead;
			// explicit expansion handles it locally rather than sending it to a model.
			pi.sendUserMessage("/branch", { expandPromptTemplates: true });
		},
	});
}
