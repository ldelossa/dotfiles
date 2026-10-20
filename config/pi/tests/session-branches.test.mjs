import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { existsSync, mkdtempSync, readFileSync, readdirSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import test from "node:test";
import { fileURLToPath, pathToFileURL } from "node:url";

// Reuse the installed Pi and its real TypeScript loader, with no test dependencies.
const packageName = "@earendil-works/pi-coding-agent";
let piEntry;
try {
	piEntry = fileURLToPath(import.meta.resolve(packageName));
} catch {
	const globalRoot = execFileSync("npm", ["root", "-g"], { encoding: "utf8" }).trim();
	const packageRoot = join(globalRoot, packageName);
	const manifest = JSON.parse(readFileSync(join(packageRoot, "package.json"), "utf8"));
	piEntry = join(packageRoot, manifest.exports["."].import);
}
const {
	SessionManager, SettingsManager, createAgentSessionRuntime,
	createAgentSessionServices, createAgentSessionFromServices,
} = await import(pathToFileURL(piEntry).href);
const { loadExtensions } = await import(pathToFileURL(join(dirname(piEntry), "core/extensions/loader.js")).href);
const extensionPath = fileURLToPath(new URL("../extensions/session-branches.ts", import.meta.url));

async function fixture(t, { saved = true } = {}) {
	const root = mkdtempSync(join(tmpdir(), "pi-session-branches-"));
	t.after(() => rmSync(root, { recursive: true, force: true }));
	const parent = SessionManager.create(root, join(root, "sessions"));
	if (saved) parent.appendMessage({ role: "user", content: "Original conversation", timestamp: Date.now() });
	const loaded = await loadExtensions([extensionPath], root);
	assert.deepEqual(loaded.errors, []);
	assert.equal(loaded.extensions.length, 1);
	const extension = loaded.extensions[0];
	const state = {
		current: parent, notifications: [], inputs: [], prompts: [], switches: [],
		idle: true, pending: false, hasUI: true, cancelSwitch: false,
	};

	function context() {
		const manager = state.current;
		let stale = false;
		function active() { assert.equal(stale, false, "Reused a stale session context"); }
		return {
			cwd: root,
			get hasUI() { active(); return state.hasUI; },
			get sessionManager() { active(); return manager; },
			get ui() {
				active();
				return {
					notify: (message, level) => { active(); state.notifications.push({ message, level }); },
					input: async (...args) => {
						active(); state.prompts.push(args);
						const value = state.inputs.shift();
						return typeof value === "function" ? value() : value;
					},
				};
			},
			isIdle: () => { active(); return state.idle; },
			hasPendingMessages: () => { active(); return state.pending; },
			switchSession: async (path, options) => {
				active(); state.switches.push(path);
				if (state.cancelSwitch) return { cancelled: true };
				state.current = SessionManager.open(path);
				stale = true;
				await options?.withSession?.(context());
				return { cancelled: false };
			},
		};
	}
	const run = (name, args = "") => extension.commands.get(name).handler(args, context());
	loaded.runtime.sendUserMessage = (text, options) => {
		assert.equal(text, "/branch");
		assert.equal(options.expandPromptTemplates, true);
		state.dispatch = run("branch");
	};
	const files = () => existsSync(join(root, "sessions")) ? readdirSync(join(root, "sessions")) : [];
	return { root, parent, extension, state, context, run, files };
}

test("registers /branch, /return, and Ctrl+Shift+B without shadowing /clone", async (t) => {
	const f = await fixture(t);
	assert.deepEqual([...f.extension.commands.keys()], ["branch", "return"]);
	assert.deepEqual([...f.extension.shortcuts.keys()], ["ctrl+shift+b"]);
});

test("creates and names a child without changing the parent", async (t) => {
	const f = await fixture(t);
	f.parent.appendSessionInfo("Parent name");
	const parentFile = f.parent.getSessionFile();
	const original = readFileSync(parentFile, "utf8");
	await f.run("branch", "  Investigate parser  ");
	assert.notEqual(f.state.current.getSessionFile(), parentFile);
	assert.equal(f.state.current.getSessionName(), "Investigate parser");
	assert.equal(f.state.current.getHeader().parentSession, parentFile);
	assert.equal(readFileSync(parentFile, "utf8"), original);
	assert.equal(f.parent.getSessionName(), "Parent name");
	assert.equal(f.state.current.getBranch().filter((e) => e.type === "message").length, 1);
});

test("copies the active branch, not abandoned tree branches", async (t) => {
	const f = await fixture(t);
	const rootId = f.parent.getLeafId();
	f.parent.appendMessage({ role: "user", content: "Abandoned", timestamp: Date.now() });
	f.parent.branch(rootId);
	f.parent.appendMessage({ role: "user", content: "Selected", timestamp: Date.now() });
	await f.run("branch", "Selected branch");
	const messages = f.state.current.getEntries().filter((e) => e.type === "message").map((e) => e.message.content);
	assert.deepEqual(messages, ["Original conversation", "Selected"]);
});

test("preserves labels, model selection, and extension metadata", async (t) => {
	const f = await fixture(t);
	const messageId = f.parent.getLeafId();
	f.parent.appendModelChange("test-provider", "test-model");
	f.parent.appendCustomEntry("example", { answer: 42 });
	f.parent.appendLabelChange(messageId, "checkpoint");
	await f.run("branch", "Metadata copy");
	assert.equal(f.state.current.getLabel(messageId), "checkpoint");
	assert.equal(f.state.current.buildSessionContext().model.modelId, "test-model");
	assert.deepEqual(f.state.current.getEntries().find((e) => e.type === "custom").data, { answer: 42 });
});

test("nested /return goes to the immediate parent and keeps both children", async (t) => {
	const f = await fixture(t);
	const parentFile = f.parent.getSessionFile();
	await f.run("branch", "Child");
	const childFile = f.state.current.getSessionFile();
	await f.run("branch", "Grandchild");
	const grandchildFile = f.state.current.getSessionFile();
	await f.run("return");
	assert.equal(f.state.current.getSessionFile(), childFile);
	await f.run("return");
	assert.equal(f.state.current.getSessionFile(), parentFile);
	assert.ok(existsSync(childFile));
	assert.ok(existsSync(grandchildFile));
});

test("return works after reopening a child and does not merge its messages", async (t) => {
	const f = await fixture(t);
	const parentFile = f.parent.getSessionFile();
	await f.run("branch", "Resumable child");
	const childFile = f.state.current.getSessionFile();
	f.state.current.appendMessage({ role: "user", content: "Child-only work", timestamp: Date.now() });
	f.state.current = SessionManager.open(childFile);
	await f.run("return");
	assert.equal(f.state.current.getSessionFile(), parentFile);
	assert.equal(f.state.current.getEntries().filter((e) => e.type === "message").length, 1);
	assert.ok(readFileSync(childFile, "utf8").includes("Child-only work"));
});

test("/return also works with children created by native clone/fork storage", async (t) => {
	const f = await fixture(t);
	const parentFile = f.parent.getSessionFile();
	const nativeCopy = SessionManager.open(parentFile);
	const childFile = nativeCopy.createBranchedSession(nativeCopy.getLeafId());
	f.state.current = SessionManager.open(childFile);
	await f.run("return");
	assert.equal(f.state.current.getSessionFile(), parentFile);
});

test("/branch without a name prompts, and the shortcut dispatches it locally", async (t) => {
	const f = await fixture(t);
	f.state.inputs.push("Prompted name");
	await f.extension.shortcuts.get("ctrl+shift+b").handler(f.context());
	await f.state.dispatch;
	assert.equal(f.state.current.getSessionName(), "Prompted name");
	assert.equal(f.state.prompts.length, 1);
});

test("Escape and invalid names create no child", async (t) => {
	const f = await fixture(t);
	const before = f.files();
	for (const input of [undefined, "   ", "two\nlines"]) {
		f.state.inputs.push(input);
		await f.run("branch");
	}
	await f.run("branch", "contains\u001bescape");
	assert.deepEqual(f.files(), before);
	assert.equal(f.state.switches.length, 0);
});

test("does not branch an unsaved session", async (t) => {
	const f = await fixture(t, { saved: false });
	await f.run("branch", "Unsaved");
	assert.equal(f.state.switches.length, 0);
	assert.equal(f.files().length, 0);
	assert.match(f.state.notifications.at(-1).message, /saved session/);
});

test("does not branch an ephemeral session", async (t) => {
	const f = await fixture(t);
	f.state.current = SessionManager.inMemory(f.root);
	f.state.current.appendMessage({ role: "user", content: "Ephemeral", timestamp: Date.now() });
	await f.run("branch", "No parent file");
	assert.equal(f.state.switches.length, 0);
});

test("missing parent and root sessions do not switch", async (t) => {
	const f = await fixture(t);
	await f.run("return");
	assert.match(f.state.notifications.at(-1).message, /no parent/);
	await f.run("branch", "Orphan test");
	rmSync(f.parent.getSessionFile());
	const switches = f.state.switches.length;
	await f.run("return");
	assert.equal(f.state.switches.length, switches);
	assert.match(f.state.notifications.at(-1).message, /Parent session is missing/);
});

test("busy or queued sessions do not navigate or dispatch a shortcut", async (t) => {
	const f = await fixture(t);
	for (const [idle, pending] of [[false, false], [true, true]]) {
		f.state.idle = idle; f.state.pending = pending;
		await f.run("branch", "Busy");
		await f.run("return");
		await f.extension.shortcuts.get("ctrl+shift+b").handler(f.context());
	}
	assert.equal(f.state.switches.length, 0);
	assert.equal(f.state.dispatch, undefined);
});

test("rechecks idle state after the name dialog", async (t) => {
	const f = await fixture(t);
	f.state.inputs.push(() => { f.state.pending = true; return "Queued during prompt"; });
	await f.run("branch");
	assert.equal(f.state.switches.length, 0);
	assert.equal(f.files().length, 1);
});

test("rejects overlapping navigation while a name dialog is open", async (t) => {
	const f = await fixture(t);
	let complete;
	f.state.inputs.push(() => new Promise((resolve) => { complete = resolve; }));
	const first = f.run("branch");
	await f.run("branch", "Concurrent branch");
	await f.run("return");
	assert.equal(f.files().length, 1);
	assert.match(f.state.notifications.at(-1).message, /already in progress/);
	complete(undefined);
	await first;
});

test("no-UI mode requires a name but accepts an explicit one", async (t) => {
	const f = await fixture(t);
	f.state.hasUI = false;
	await f.run("branch");
	assert.match(f.state.notifications.at(-1).message, /Usage:/);
	await f.run("branch", "Explicit name");
	assert.equal(f.state.current.getSessionName(), "Explicit name");
});

test("a cancelled switch keeps the new child resumable and the parent active", async (t) => {
	const f = await fixture(t);
	f.state.cancelSwitch = true;
	await f.run("branch", "Saved but not entered");
	assert.equal(f.state.current, f.parent);
	assert.equal(f.files().length, 2);
	assert.match(f.state.notifications.at(-1).message, /switching was cancelled/);
});

test("/return rejects arguments", async (t) => {
	const f = await fixture(t);
	await f.run("return", "unexpected");
	assert.match(f.state.notifications.at(-1).message, /Usage: \/return/);
	assert.equal(f.state.switches.length, 0);
});

test("real Pi runtime reloads the extension across branch and return without model calls", async (t) => {
	const f = await fixture(t);
	const errors = [];
	const agentDir = join(f.root, "isolated-agent");
	const createRuntime = async ({ cwd, sessionManager, sessionStartEvent }) => {
		const services = await createAgentSessionServices({
			cwd, agentDir,
			settingsManager: SettingsManager.inMemory({ packages: [] }),
			resourceLoaderOptions: {
				noExtensions: true, additionalExtensionPaths: [extensionPath],
				noSkills: true, noPromptTemplates: true, noThemes: true, noContextFiles: true,
			},
		});
		return {
			...await createAgentSessionFromServices({ services, sessionManager, sessionStartEvent, noTools: true }),
			services, diagnostics: services.diagnostics,
		};
	};
	const runtime = await createAgentSessionRuntime(createRuntime, {
		cwd: f.root, agentDir, sessionManager: f.parent,
	});
	try {
		const bind = async (session) => {
			await session.bindExtensions({
				commandContextActions: { switchSession: (path, options) => runtime.switchSession(path, options) },
				onError: (error) => errors.push(error),
			});
		};
		runtime.setRebindSession(bind);
		await bind(runtime.session);
		const parentFile = runtime.session.sessionFile;
		const parentBytes = readFileSync(parentFile, "utf8");
		await runtime.session.prompt("/branch Runtime integration");
		const childFile = runtime.session.sessionFile;
		assert.notEqual(childFile, parentFile);
		assert.equal(runtime.session.sessionManager.getSessionName(), "Runtime integration");
		assert.equal(runtime.session.sessionManager.getHeader().parentSession, parentFile);
		await runtime.session.prompt("/return");
		assert.equal(runtime.session.sessionFile, parentFile);
		assert.equal(readFileSync(parentFile, "utf8"), parentBytes);
		assert.ok(existsSync(childFile));
		assert.deepEqual(errors, []);
	} finally {
		await runtime.dispose();
	}
});
