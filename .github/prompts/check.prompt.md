---
name: check
description: "Validate structure, scripts, tests, and workflow without editing generated source files."
agent: "Build Engineer"
argument-hint: "Run the complete non-destructive project check"
---

Run the Build Engineer final check. Verify expected files, frontmatter,
references, and workflow structure; run the existing platform script and
tests; and inspect `git diff --check`. Do not edit source files, install
global packages, create commits, push, change PRs, or claim that a prompt file
was executed merely because it was read.
