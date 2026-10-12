---
name: github-actions
description: "Create and validate the Python 3.13 GitHub Actions matrix workflow for Ubuntu, Windows, and macOS. Use for /create-actions or /check."
argument-hint: "Create or verify the cross-platform CI workflow"
user-invocable: true
---

# GitHub Actions

## Purpose

Create one understandable matrix job that uses the same repository scripts as
local development.

## Apply when

- `/create-actions` is requested;
- `/init` reaches the workflow step;
- `/check` validates CI configuration.

## Inputs

- repository root;
- `ci.sh` and `ci.bat`;
- supported Python version 3.13;
- existing `.github/workflows` files and user changes.

## Outputs

- one workflow with a single matrix job for `ubuntu-latest`,
  `windows-latest`, and `macos-latest`;
- `actions/checkout` and `actions/setup-python` configuration;
- triggers for push and pull request on `develop` and `master`, plus
  `workflow_dispatch`;
- per-OS downloadable artifacts containing clear run results.

## Procedure

1. Inspect existing workflows and preserve unrelated user changes.
2. Configure the required triggers and Python 3.13 using setup-python.
3. Use `bash ./ci.sh` on Ubuntu/macOS and `cmd /c ci.bat` on Windows.
4. Upload a named artifact for each matrix OS after the check.
5. Keep the workflow to one matrix job; do not duplicate build logic in YAML.
6. Validate YAML structure, paths, action versions, and artifact names.

## Checks

- exactly one matrix job covers all three operating systems;
- the job actually calls the platform script;
- failures stop the job;
- generated artifacts are downloadable and uniquely named;
- no `.venv`, cache, build directory, or test result is committed.

## Example

The workflow can select its script with an OS expression and then invoke the
same `ci.bat` or `ci.sh` used locally. The agent should implement this in YAML,
not replace it with a native executable claim for a `.py` file.

## Error handling

Stop and report invalid YAML, conflicting workflow configuration, missing
scripts, unsupported action syntax, or an artifact upload failure. Never hide a
failed matrix leg or rewrite an existing workflow without detecting conflicts.
