---
name: "Git initialization"
description: "Check Git state and prepare repository ignore rules for the Build Engineer workflow."
agent: "Build Engineer"
argument-hint: "Prepare Git safely without committing or pushing"
---

Check the repository root, current branch, working tree, remotes, and tracked
files. Prepare or verify `.gitignore` for Python 3.13, `.venv`, pytest caches,
build output, and test results. Preserve user changes and stop on conflicts.
Do not create a commit, push, PR, merge, reviewer assignment, or unrelated
branch. Report the checks and any required follow-up.
