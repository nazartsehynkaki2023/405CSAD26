# Copilot instructions

## Repository purpose

This repository is the lab workspace for the custom Build Engineer agent for GitHub Copilot in VS Code. The source of truth is the project metadata and automation files in this repo, not a production application implementation.

The repo is organized around:

- custom agent definition: [.github/agents/build-engineer.agent.md](agents/build-engineer.agent.md)
- reusable skills: [.github/skills](../.github/skills)
- prompt commands: [.github/prompts](prompts)
- repo docs: [README.md](../README.md), [docs/architecture.md](../docs/architecture.md), [docs/usage.md](../docs/usage.md)

Do not assume this is a C++/CMake project. The actual lab instructions in this repo target Python 3.13, `venv`, `pytest`, and GitHub Actions.

## Build and validation flow

The intended project lifecycle is driven by the Build Engineer agent:

1. Run `/init` to scaffold the Python project.
2. Use the generated `.venv` in the repo root for Python and pytest.
3. Validate with the repo-local scripts:
   - Windows: `ci.bat`
   - Linux/macOS: `bash ./ci.sh`
4. Keep validations focused on the generated project structure and its pytest checks.

The expected generated project shape is:

- `src/hello.py`
- `src/math_operations.py`
- `tests/`
- `requirements-dev.txt`
- `ci.bat`
- `ci.sh`
- `.github/workflows/python-ci.yml`

The generated `hello.py` should expose `main()` that prints `Hello World!`, and `math_operations.py` should expose `add(a, b)`.

## Repo-specific conventions

- Work from the actual repo evidence in [README.md](../README.md) and the agent docs; do not invent generic build steps.
- Keep the scope narrow and repo-specific. This repo is about preparing a Python lab project and validating it with CI, not adding unrelated tooling.
- Use the branch flow defined by the lab:
  - `develop` holds the agent, skills, prompts, and docs
  - `feature/develop/python-project` is the feature branch for the generated Python project
- Do not run or claim a PR/merge flow unless it is explicitly part of the task.
- Do not install packages globally; keep all Python dependencies inside `.venv`.

## AI-agent instructions

- Prefer the project’s custom agent, skill files, and prompt commands over generic advice.
- When checking or fixing repo state, validate the local scripts and pytest behavior before reporting success.
- If a task relies on a generated project, verify the actual contents of the repo before writing instructions or assumptions.
- There is no project-specific MCP server requirement in this repo, so there is no need to add generic MCP guidance.
