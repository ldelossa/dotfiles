# Session branches

`session-branches.ts` is a local Pi extension, loaded in every project through a symlink in `~/.pi/agent/extensions/`.
Run `make link-pi` to install the symlink, then `/reload` in Pi.

## Commands

- `/branch <name>` copies the active conversation branch into a new named session and enters it.
- `/branch` opens Pi's standard name input instead.
- `Ctrl+Shift+B` runs the same name-prompt flow.
- `/return` switches to the immediate parent without deleting or merging the child.

Names can contain spaces and Unicode; no quotes are needed.
Escape cancels the name prompt without creating a session.
Pi must be idle with no queued messages before navigation.

The extension uses the same session-storage branching primitive as native `/clone`, followed by the normal session-switch API.
The child is named before it is loaded, and the live parent is not modified.
Navigation emits session-switch events, not native fork events.
Native `/clone` is unchanged.

The parent path is stored in the child's standard session header, so `/return` also works after a restart, with nested branches, and with native clones or forks.
Children remain available through `/resume`.
A missing parent produces an error instead of starting a different session.
Unsaved and ephemeral sessions cannot be branched because they have no durable parent to return to.

If another extension cancels switching, the newly created child remains saved for `/resume`.
If switching fails after creating the child, the child likewise remains on disk.
Only conversation history is copied; this does not create a Git branch, worktree, or filesystem snapshot.

## Tests

With Pi installed locally or globally:

```sh
node --test config/pi/tests/session-branches.test.mjs
```

The tests use Pi's actual TypeScript loader and session-storage implementation with temporary sessions and a simulated UI.
They do not call a model or modify existing sessions.
