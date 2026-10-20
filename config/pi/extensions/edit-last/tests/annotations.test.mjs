import assert from "node:assert/strict";
import test from "node:test";
import { buildFollowUp } from "../annotations.ts";

const anchors = (text) => text.split("\n").filter((line) => line.startsWith("> "));

test("extracts inline questions with one source line per group", () => {
  const original = "Use a bounded retry loop.\n\nCache successful responses.";
  const edited = "Use a bounded retry loop.\nWhy retry instead of failing?\nWould three attempts be enough?\n\nCache successful responses.\nWhat invalidates this cache?";
  assert.equal(buildFollowUp(original, edited), [
    "Follow-up questions and comments about your previous response.",
    "Quoted source lines are context; please address my annotations rather than rewrite the response.",
    "",
    "> Use a bounded retry loop.",
    "",
    "Why retry instead of failing?",
    "Would three attempts be enough?",
    "",
    "> Cache successful responses.",
    "",
    "What invalidates this cache?",
  ].join("\n"));
});

test("a multi-line passage gets only its nearest original line", () => {
  const original = "Start the worker.\nIt handles queued jobs.\nFailed jobs are retried.\n\nUnrelated section.";
  const result = buildFollowUp(original, original.replace("\n\n", "\nWhy use this approach for the worker?\n\n"));
  assert.deepEqual(anchors(result), ["> Failed jobs are retried."]);
  assert.ok(!result.includes("Start the worker."));
  assert.ok(!result.includes("It handles queued jobs."));
  assert.ok(!result.includes("Unrelated section."));
});

test("groups adjacent questions and preserves their paragraph breaks", () => {
  const result = buildFollowUp("Original passage.", "Original passage.\nFirst question?\n\nSecond question?");
  assert.deepEqual(anchors(result), ["> Original passage."]);
  assert.ok(result.includes("First question?\n\nSecond question?"));
});

test("annotations separated only by original blank lines share an anchor", () => {
  const result = buildFollowUp("A\n\nB", "A\nQuestion one?\n\nQuestion two?\n\nB");
  assert.deepEqual(anchors(result), ["> A"]);
  assert.ok(result.includes("Question one?"));
  assert.ok(result.includes("Question two?"));
});

test("an annotation before the first line uses the following original line", () => {
  const result = buildFollowUp("Original opening.\nMore detail.", "Is this assumption correct?\nOriginal opening.\nMore detail.");
  assert.deepEqual(anchors(result), ["> Original opening."]);
  assert.ok(result.includes("Is this assumption correct?"));
});

test("an annotation after the last line uses that original line", () => {
  const result = buildFollowUp("First line.\nFinal line.", "First line.\nFinal line.\nWhat about the opposite case?");
  assert.deepEqual(anchors(result), ["> Final line."]);
});

test("replacement lines use replaced source text as their anchor", () => {
  const result = buildFollowUp("Before.\nRetry forever.\nAfter.", "Before.\nShould retries have a limit?\nAfter.");
  assert.deepEqual(anchors(result), ["> Retry forever."]);
  assert.ok(result.includes("Should retries have a limit?"));
  assert.ok(!result.includes("Before."));
  assert.ok(!result.includes("After."));
});

test("replacing multiple lines still keeps just one source anchor", () => {
  const result = buildFollowUp("First premise.\nSecond premise.\nConclusion.", "Are these premises valid?\nConclusion.");
  assert.deepEqual(anchors(result), ["> First premise."]);
  assert.ok(!result.includes("Second premise."));
});

test("unchanged, deleted-only, and empty edits produce no follow-up", () => {
  assert.equal(buildFollowUp("A\nB", "A\nB"), undefined);
  assert.equal(buildFollowUp("A\nB\nC", "A\nC"), undefined);
  assert.equal(buildFollowUp("A\nB", ""), undefined);
});

test("ignores whitespace-only edits and editor line-ending changes", () => {
  assert.equal(buildFollowUp("A\n  B\n", "\uFEFF A \r\nB\r\n\r\n"), undefined);
  assert.equal(buildFollowUp("A\nB", "A\n\n\nB\n\n"), undefined);
});

test("CRLF edits still extract genuine additions", () => {
  const result = buildFollowUp("A\nB", "\uFEFFA\r\nWhy A?\r\nB\r\n");
  assert.deepEqual(anchors(result), ["> A"]);
  assert.ok(result.endsWith("Why A?"));
  assert.ok(!result.includes("\r"));
});

test("does not use Markdown fence delimiters as source anchors", () => {
  const original = "Example:\n```c\nreturn result;\n```";
  const result = buildFollowUp(original, `${original}\nWhy return this value?`);
  assert.deepEqual(anchors(result), ["> return result;"]);
});

test("preserves inserted code and multi-line annotations", () => {
  const annotation = "Would this be safer?\n```c\nif (count == 0) {\n    return;\n}\n```";
  const result = buildFollowUp("Check the count.", `Check the count.\n${annotation}`);
  assert.ok(result.endsWith(annotation));
  assert.deepEqual(anchors(result), ["> Check the count."]);
});

test("identical source lines at different positions are not merged", () => {
  const original = "Same line.\nSection separator.\nSame line.";
  const edited = "Same line.\nQuestion about the first?\nSection separator.\nSame line.\nQuestion about the second?";
  const result = buildFollowUp(original, edited);
  assert.deepEqual(anchors(result), ["> Same line.", "> Same line."]);
  assert.ok(result.indexOf("first?") < result.indexOf("second?"));
});

test("long Unicode anchors are bounded without splitting code points", () => {
  const original = "😀".repeat(300);
  const result = buildFollowUp(original, `${original}\nWhy?`);
  assert.deepEqual(anchors(result), [`> ${"😀".repeat(240)}…`]);
});

test("an empty original can produce unanchored notes", () => {
  const result = buildFollowUp("", "New question?");
  assert.deepEqual(anchors(result), []);
  assert.ok(result.endsWith("New question?"));
});

test("large unchanged responses are not replayed", () => {
  const lines = Array.from({ length: 10000 }, (_, index) => `Original line ${index}.`);
  const edited = [...lines.slice(0, 5000), "Why this step?", ...lines.slice(5000)];
  const result = buildFollowUp(lines.join("\n"), edited.join("\n"));
  assert.deepEqual(anchors(result), ["> Original line 4999."]);
  assert.ok(result.length < 300);
});
