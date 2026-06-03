# Rules

- Never make changes without first asking for confirmation. It is fine to group a set of changes
  into a plan, but always ask the user to execute the plan prior to implementing the changes.

- Do not use `sed` or shell-based automated text replacements without explicit
  consent. This applies to scripted/batch rewrites across files. Instead, 
  prefer to make edits file-by-file.

- When fixing bugs, take an architectural view of the code before attempting
  a fix. If the user rejects your fix more than once, stop patching: re-read
  the relevant code and trace the code paths end-to-end relative to the
  problem before proposing another change.

- When a design or planning task involves choosing between technologies,
  frameworks, or libraries — or pinning versions for something new — perform
  a web search for the latest documentation first. Do not rely on training
  data for version numbers, API surface, or recency-sensitive facts. This
  does not apply to routine work inside an existing codebase with
  already-chosen libraries.

# Extensions

## pi-web-access
- When calling web_search or fetch_content, always use workflow: "none" — do not open the curator browser.
