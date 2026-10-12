---
name: project-scaffold
description: "Create the initial Python 3.13 Hello World project structure and arithmetic module. Use when /create-project or /init needs a new project scaffold."
argument-hint: "Create or verify the Python source and test layout"
user-invocable: true
---

# Project scaffold

## Purpose

Create a clear Python package layout without pretending that a Python file is
a native executable.

## Apply when

- `/create-project` is requested;
- `/init` reaches the project-scaffold step;
- the expected `src/` or `tests/` layout is missing.

## Inputs

- repository root;
- active Git branch;
- existing files and user modifications;
- the required variant-26 behavior.

## Outputs

- `src/hello.py` with `main()` printing exactly `Hello World!`;
- `src/math_operations.py` with `add(a, b)`;
- `tests/` with pytest tests for `BasicAddition`, zero, negative numbers,
  and Hello World output through `capsys`.

## Procedure

1. Verify the repository root and active branch.
2. Inspect every target path before writing.
3. Preserve changed user files; report conflicts instead of overwriting them.
4. Create the `src` package and tests with imports independent of the current
   shell `PATH` (pytest configuration or package metadata may be used).
5. Keep the implementation minimal and deterministic.
6. Hand the result to `build-and-test`; do not install packages globally.

## Checks

- `src/hello.py` can be run with the project interpreter.
- `add(2, 3) == 5`, zero, and negative cases are represented.
- `capsys` asserts the exact Hello World output.
- test discovery does not depend on a globally installed executable.

## Example

An acceptable source call is:

```python
from math_operations import add

assert add(2, 3) == 5
```

The agent must create and run the tests later; this example is not a command
to paste into a shell.

## Error handling

Stop and report the first error if a target file is user-modified, the active
branch is incompatible, imports cannot be made package-safe, or the source
layout conflicts with existing configuration.
