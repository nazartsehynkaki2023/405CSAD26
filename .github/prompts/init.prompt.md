---
name: "Initialize Python project"
description: "Orchestrate Git preparation, project scaffold, build/test setup, Actions, and final check."
agent: "Build Engineer"
argument-hint: "Run the complete guarded initialization workflow"
---

Execute these operations in order, stopping on the first failure:

1. Apply [git-init](./git-init.prompt.md).
2. Apply [create-project](./create-project.prompt.md), using
   [project-scaffold](../skills/project-scaffold/SKILL.md).
3. Apply [create-build](./create-build.prompt.md), using
   [build-and-test](../skills/build-and-test/SKILL.md).
4. Apply [create-actions](./create-actions.prompt.md), using
   [github-actions](../skills/github-actions/SKILL.md).
5. Apply [check](./check.prompt.md).

Before step 1, check prerequisites and branch state. On `develop`, use
`feature/develop/python-project`; if it is already active, continue there.
Never overwrite user-modified files, create duplicate configuration, push,
create or merge a PR, assign reviewers, reset, rebase, or delete unrelated
files. Report the failed step and stop on error. Announce success only after
the final check has actually passed.
