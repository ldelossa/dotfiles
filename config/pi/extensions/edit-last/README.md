# Edit last response

A local Pi extension for reading the latest assistant response and adding inline follow-up questions or comments.
Only the additions and one nearby original line per group are loaded into Pi's input.

## Installation

Run `make link-pi` from the dotfiles repository, then `/reload` in Pi.
The target installs runtime dependencies and links this directory into `~/.pi/agent/extensions/edit-last`.
Pi loads it in every project; no Git-package installation, publishing, or separate repository update is required.

## Workflow

1. Run `/edit-last`.
2. Read the response and insert questions or comments below the relevant passages.
3. Save and exit the editor.
4. Review the extracted follow-up in Pi's input, then press Enter to send it.

No annotation markers are required.
For example, edit this response:

```text
Use a bounded retry loop.

Cache successful responses.
```

Into:

```text
Use a bounded retry loop.
Why retry instead of failing immediately?
Would three attempts be enough?

Cache successful responses.
What invalidates this cache?
```

The resulting input contains:

```text
Follow-up questions and comments about your previous response.
Quoted source lines are context; please address my annotations rather than rewrite the response.

> Use a bounded retry loop.

Why retry instead of failing immediately?
Would three attempts be enough?

> Cache successful responses.

What invalidates this cache?
```

A question about a multi-line passage still gets only one original source line.
The full response is already in the conversation history.
Source lines longer than 240 Unicode code points are shortened.
Blank lines and code-fence delimiters are skipped when choosing an anchor.

## Editing behavior

- In interactive TUI mode, `$VISUAL` takes precedence over `$EDITOR`.
- Without an external editor, Pi's built-in multiline editor is used.
- The external editor receives a temporary Markdown file while Pi's TUI is suspended.
- After editing, the TUI is restored and the temporary file is removed.
- Cancellation or a nonzero external-editor exit leaves the existing input unchanged.
- Unchanged, whitespace-only, and deletion-only edits also leave the existing input unchanged.
- Nothing is sent automatically and no extra model request is used for extraction.

Keep the original response intact and add annotations on their own lines for the cleanest result.
Replacing an original line counts as new content, anchored to the replaced line.
An addition on the same line as existing prose includes that whole changed line.
Rewrapping or broadly rewriting the response may therefore extract more than intended.
A costly comparison stops with an error instead of freezing Pi or replacing the input with the entire response.

The command searches only the active session branch and ignores thinking and tool-only messages.
The existing limitation that external-editor commands are split on whitespace is unchanged.

## Development

```sh
cd config/pi/extensions/edit-last
npm ci --ignore-scripts
npm run typecheck
npm test
```

Tests cover extraction and the real Pi extension loader, plus simulated built-in and external editors.
They do not call a model or modify existing sessions.

## License

MIT; adapted from `ldelossa/pi-edit-last` and maintained directly in these dotfiles.
