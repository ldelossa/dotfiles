import { diffArrays } from "diff";

type AnnotationGroup = {
  anchorIndex: number | undefined;
  lines: string[];
};

const splitLines = (text: string): string[] => {
  const normalized = text.replace(/^\uFEFF/, "").replace(/\r\n?/g, "\n").replace(/\n+$/, "");
  return normalized ? normalized.split("\n") : [];
};

const trimBlankLines = (lines: string[]): string[] => {
  let start = 0;
  let end = lines.length;
  while (start < end && !lines[start].trim()) start += 1;
  while (end > start && !lines[end - 1].trim()) end -= 1;
  return lines.slice(start, end);
};

const usefulAnchor = (line: string): boolean =>
  line.trim().length > 0 && !/^\s*(?:`{3,}|~{3,})/.test(line);

/** Keep one original line, preferring replaced text or the preceding passage. */
const findAnchor = (original: string[], start: number, end: number): number | undefined => {
  for (let index = start; index < end; index += 1) {
    if (usefulAnchor(original[index])) return index;
  }
  for (let index = start - 1; index >= 0; index -= 1) {
    if (usefulAnchor(original[index])) return index;
  }
  // An annotation inserted before the response uses the next original line.
  for (let index = end; index < original.length; index += 1) {
    if (usefulAnchor(original[index])) return index;
  }
  return undefined;
};

/** Extract new/changed lines without asking a model to interpret the edit. */
export const buildFollowUp = (originalText: string, editedText: string): string | undefined => {
  const original = splitLines(originalText);
  const edited = splitLines(editedText);
  const changes = diffArrays(original, edited, {
    comparator: (left, right) => left.trim() === right.trim(),
    timeout: 250,
  });
  if (!changes) {
    throw new Error("The edit is too large to compare quickly. Add annotations without reformatting the response.");
  }

  const groups: AnnotationGroup[] = [];
  let originalIndex = 0;
  let pending: { start: number; end: number; added: string[] } | undefined;

  const flush = () => {
    if (!pending) return;
    const lines = trimBlankLines(pending.added);
    if (lines.length > 0) {
      const anchorIndex = findAnchor(original, pending.start, pending.end);
      const previous = groups[groups.length - 1];
      if (previous && previous.anchorIndex === anchorIndex) {
        previous.lines.push("", ...lines);
      } else {
        groups.push({ anchorIndex, lines });
      }
    }
    pending = undefined;
  };

  for (const change of changes) {
    if (!change.added && !change.removed) {
      flush();
      originalIndex += change.count;
      continue;
    }
    pending ??= { start: originalIndex, end: originalIndex, added: [] };
    if (change.added) {
      pending.added.push(...change.value);
    } else {
      originalIndex += change.count;
      pending.end = originalIndex;
    }
  }
  flush();

  if (groups.length === 0) return undefined;

  const sections = groups.map(({ anchorIndex, lines }) => {
    const annotation = lines.join("\n");
    if (anchorIndex === undefined) return annotation;
    // A long prose line still only needs a short locator, not a full paragraph.
    const characters = Array.from(original[anchorIndex].trim());
    const anchor = characters.length > 240 ? `${characters.slice(0, 240).join("")}…` : characters.join("");
    return `> ${anchor}\n\n${annotation}`;
  });
  return [
    "Follow-up questions and comments about your previous response.",
    "Quoted source lines are context; please address my annotations rather than rewrite the response.",
    "",
    sections.join("\n\n"),
  ].join("\n");
};
