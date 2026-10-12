---
name: "Create build and test"
description: "Prepare venv, pinned pytest dependencies, tests, and platform scripts."
agent: "Build Engineer"
argument-hint: "Prepare local repeatable build and test commands"
---

Load [build-and-test](../skills/build-and-test/SKILL.md). Prepare or reuse the
root `.venv`, pin pytest in `requirements-dev.txt`, and create or verify
`ci.bat` and `ci.sh`. Ensure both scripts run tests and Hello World without
manual activation, support Unicode paths, and return failures. Do not install
packages globally.
