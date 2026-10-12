---
name: build-and-test
description: "Prepare a local Python 3.13 venv, pinned pytest development dependency, tests, and cross-platform ci.bat/ci.sh. Use for /create-build or /check."
argument-hint: "Prepare the venv, scripts, and pytest checks"
user-invocable: true
---

# Build and test

## Purpose

Provide repeatable local verification for Windows, Linux, and macOS without
manual activation or global package installation.

## Apply when

- `/create-build` is requested;
- `/check` validates an existing Python project;
- `/init` reaches the build-and-test step.

## Inputs

- repository root;
- `src/` and `tests/` from `project-scaffold`;
- Python 3.13 through `python` or `py`;
- existing `.venv`, `requirements-dev.txt`, `ci.bat`, and `ci.sh`.

## Outputs

- reusable root `.venv`;
- `requirements-dev.txt` with an explicit pytest version;
- `ci.bat` and `ci.sh`, each resolving the root from its own location;
- test and Hello World execution evidence.

## Procedure

1. Resolve the repository root from the script location, including spaces and
   non-ASCII characters.
2. Create `.venv` only when it is absent or unusable; reuse a valid one.
3. Install only `requirements-dev.txt` into that environment.
4. Invoke the environment's interpreter and pytest directly, without
   requiring activation.
5. Run pytest and then Hello World; propagate every failure as non-zero.
6. Explicitly fail when no tests are collected.

## Checks

- scripts accept no parameters;
- `.venv` is under the repository root;
- `python -m pip` and `python -m pytest` use the venv interpreter;
- pytest is pinned;
- scripts work from any current directory and with Unicode paths;
- `.venv`, caches, build products, and test results are ignored by Git.

## Example

The Windows script should conceptually invoke:

```text
.venv\Scripts\python.exe -m pytest
```

The POSIX script should conceptually invoke:

```text
.venv/bin/python -m pytest
```

These are implementation examples for the agent, not standalone prompt
commands.

## Error handling

Stop at the failed operation and return its exit code. Do not silently create
a second environment, fall back to global pytest, hide missing tests, or
continue after dependency or test failure.
