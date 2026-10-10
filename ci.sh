#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build/ci"

command -v cmake >/dev/null 2>&1 || {
    echo "Error: cmake was not found in PATH." >&2
    exit 1
}
command -v ctest >/dev/null 2>&1 || {
    echo "Error: ctest was not found in PATH." >&2
    exit 1
}

cmake --version
ctest --version

cmake -S "$SCRIPT_DIR" -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release
cmake --build "$BUILD_DIR" --config Release

TEST_LIST="$BUILD_DIR/ctest-list.txt"
ctest --test-dir "$BUILD_DIR" -N -C Release | tee "$TEST_LIST"
test_count="$(awk '/Total Tests:/ { print $3 }' "$TEST_LIST")"
if [[ ! "$test_count" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: no tests were discovered." >&2
    exit 1
fi

ctest --test-dir "$BUILD_DIR" -C Release --output-on-failure

hello="$BUILD_DIR/hello"
if [[ ! -x "$hello" ]]; then
    hello="$BUILD_DIR/Release/hello"
fi
if [[ ! -x "$hello" ]]; then
    echo "Error: hello executable was not found." >&2
    exit 1
fi

"$hello"
