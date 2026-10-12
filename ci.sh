#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PYTHON="$ROOT/.venv/bin/python"

if [[ ! -x "$PYTHON" ]]; then
    python3.13 -m venv "$ROOT/.venv"
fi

if [[ ! -d "$ROOT/tests" ]]; then
    echo "ERROR: tests directory is missing." >&2
    exit 1
fi

"$PYTHON" -m pip install -r "$ROOT/requirements-dev.txt"
"$PYTHON" -m pytest "$ROOT/tests"
"$PYTHON" "$ROOT/src/hello.py"
