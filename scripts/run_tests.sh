#!/usr/bin/env bash
# Test runner script for Neovim configuration
# Usage: ./scripts/run_tests.sh [unit|integration|python|scripts|all]
#
# scripts runs the bats tests in tests/scripts/ (skipped when bats isn't installed).
# Unit specs run one Neovim per spec file, TEST_JOBS at a time (default: CPU count).
# Environment:
#   NVIM_COVERAGE=<statsfile>  collect luacov stats; each spec file writes its own stats file
#                              and they are merged into <statsfile> at the end
#   TEST_JOBS=<n>              spec files run in parallel
#   TEST_TIMEOUT=<seconds>     limit per spec file (default 120, 900 with coverage)
#   UNIT_DIR=<dir>             directory holding *_spec.lua (default tests/unit)
# Test output goes to stdout; one "progress:" line per finished spec file (and each failure)
# goes to stderr as it happens.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
TEST_TYPE="${1:-all}"
UNIT_DIR="${UNIT_DIR:-$NVIM_CONFIG_DIR/tests/unit}"
# Specs and tests/minimal_init.lua resolve paths from the repo root
cd "$NVIM_CONFIG_DIR" || exit 1
TEST_JOBS="${TEST_JOBS:-$(nproc 2>/dev/null || echo 4)}"
if [ -n "${NVIM_COVERAGE:-}" ]; then
    TEST_TIMEOUT="${TEST_TIMEOUT:-900}"
else
    TEST_TIMEOUT="${TEST_TIMEOUT:-120}"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

progress() {
    echo "progress: $*" >&2
}

echo -e "${YELLOW}Running Neovim Configuration Tests${NC}"
echo "========================================"
echo ""

# Run one spec file in its own Neovim; called by xargs with the spec path.
run_one_spec() {
    local spec="$1"
    local name start status result elapsed done_count first_fail
    name="$(basename "$spec" .lua)"
    start="$(date +%s.%N)"
    # plenary.busted.run exits Neovim with the result (0 passed, 1 failed, 2 errored)
    local run_cmd="lua require('plenary.busted').run('$spec')"
    if [ -n "$COVERAGE_OUT" ]; then
        NVIM_COVERAGE="$WORK_DIR/$name.stats" timeout "$TEST_TIMEOUT" nvim --headless --noplugin \
            -i NONE -u "$NVIM_CONFIG_DIR/tests/minimal_init.lua" -c "$run_cmd" \
            >"$WORK_DIR/$name.log" 2>&1
    else
        env -u NVIM_COVERAGE timeout "$TEST_TIMEOUT" nvim --headless --noplugin \
            -i NONE -u "$NVIM_CONFIG_DIR/tests/minimal_init.lua" -c "$run_cmd" \
            >"$WORK_DIR/$name.log" 2>&1
    fi
    status=$?
    echo "$status" >"$WORK_DIR/$name.status"
    case "$status" in
        0) result="ok" ;;
        124) result="TIMEOUT after ${TEST_TIMEOUT}s" ;;
        *) result="FAIL (exit $status)" ;;
    esac
    elapsed="$(awk -v s="$start" -v e="$(date +%s.%N)" 'BEGIN { printf "%.1f", e - s }')"
    done_count="$(flock "$WORK_DIR/count.lock" bash -c \
        'c=$(( $(cat "$1" 2>/dev/null || echo 0) + 1 )); echo "$c" >"$1"; echo "$c"' _ "$WORK_DIR/count")"
    echo "progress: unit $done_count/$TOTAL_SPECS $name $result (${elapsed}s)" >&2
    if [ "$status" -ne 0 ]; then
        first_fail="$(sed 's/\x1b\[[0-9;]*m//g' "$WORK_DIR/$name.log" |
            grep -m1 -E '^(Fail|Errors?)\s*\|\|' | tr -s '\t' ' ')"
        [ -n "$first_fail" ] && echo "progress:   $first_fail" >&2
    fi
    return 0
}
export -f run_one_spec

run_plenary_tests() {
    echo -e "${YELLOW}Running Plenary (Unit) Tests...${NC}"
    local specs=() spec name failed=0 status
    mapfile -t specs < <(find "$UNIT_DIR" -maxdepth 1 -name '*_spec.lua' | sort)
    if [ "${#specs[@]}" -eq 0 ]; then
        echo -e "${RED}✗ No spec files in $UNIT_DIR${NC}"
        return 1
    fi

    WORK_DIR="$(mktemp -d)"
    COVERAGE_OUT="${NVIM_COVERAGE:-}"
    TOTAL_SPECS="${#specs[@]}"
    export WORK_DIR COVERAGE_OUT TOTAL_SPECS TEST_TIMEOUT NVIM_CONFIG_DIR
    progress "unit: $TOTAL_SPECS spec files, $TEST_JOBS at a time"

    printf '%s\0' "${specs[@]}" | xargs -0 -n1 -P "$TEST_JOBS" bash -c 'run_one_spec "$1"' _

    # Output in spec order, as the directory runner printed it
    for spec in "${specs[@]}"; do
        name="$(basename "$spec" .lua)"
        echo "Testing: $spec"
        tr -d '\r' <"$WORK_DIR/$name.log" 2>/dev/null
        status="$(cat "$WORK_DIR/$name.status" 2>/dev/null || echo 1)"
        if [ "$status" -ne 0 ]; then
            failed=1
            [ "$status" -eq 124 ] && echo "Timeout: $spec did not finish within ${TEST_TIMEOUT}s"
        fi
    done

    if [ -n "$COVERAGE_OUT" ]; then
        local stats=("$WORK_DIR"/*.stats)
        if [ -e "${stats[0]}" ]; then
            nvim --headless --clean -l "$SCRIPT_DIR/luacov_merge.lua" "$COVERAGE_OUT" "${stats[@]}" ||
                failed=1
        fi
    fi
    rm -rf "$WORK_DIR"

    if [ "$failed" -eq 0 ]; then
        echo -e "${GREEN}✓ Plenary tests passed${NC}"
    else
        echo -e "${RED}✗ Plenary tests failed${NC}"
    fi
    return "$failed"
}

run_minitest_tests() {
    echo -e "${YELLOW}Running Mini.test (Integration) Tests...${NC}"
    progress "integration: mini.test"
    if nvim --headless --noplugin -u "$NVIM_CONFIG_DIR/tests/minimal_init.lua" \
        -l "$NVIM_CONFIG_DIR/scripts/run_minitest.lua" 2>&1; then
        echo -e "${GREEN}✓ Mini.test tests passed${NC}"
        progress "integration: ok"
        return 0
    fi
    echo -e "${RED}✗ Mini.test tests failed${NC}"
    progress "integration: FAIL"
    return 1
}

run_python_tests() {
    echo -e "${YELLOW}Running Python (benchmark harness) Tests...${NC}"
    progress "python: benchmark harness"
    if PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s "$NVIM_CONFIG_DIR/tests/bench" -p 'test_*.py'; then
        echo -e "${GREEN}✓ Python tests passed${NC}"
        progress "python: ok"
        return 0
    fi
    echo -e "${RED}✗ Python tests failed${NC}"
    progress "python: FAIL"
    return 1
}

run_script_tests() {
    echo -e "${YELLOW}Running bats (script) Tests...${NC}"
    if ! command -v bats >/dev/null; then
        echo -e "${YELLOW}- bats not installed; skipped${NC}"
        progress "scripts: skipped (no bats)"
        return 0
    fi
    progress "scripts: bats"
    # The bats tests run run_tests.sh on throwaway specs; keep them out of a coverage run
    if env -u NVIM_COVERAGE bats "$NVIM_CONFIG_DIR/tests/scripts"; then
        echo -e "${GREEN}✓ bats tests passed${NC}"
        progress "scripts: ok"
        return 0
    fi
    echo -e "${RED}✗ bats tests failed${NC}"
    progress "scripts: FAIL"
    return 1
}

run_all_tests() {
    local failed=0

    run_plenary_tests || failed=1
    echo ""
    run_minitest_tests || failed=1
    echo ""
    run_python_tests || failed=1
    echo ""
    run_script_tests || failed=1

    echo ""
    echo "========================================"
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
    else
        echo -e "${RED}Some tests failed!${NC}"
    fi

    return $failed
}

case "$TEST_TYPE" in
    unit) run_plenary_tests ;;
    integration) run_minitest_tests ;;
    python) run_python_tests ;;
    scripts) run_script_tests ;;
    all) run_all_tests ;;
    *)
        echo -e "${RED}Invalid test type: $TEST_TYPE${NC}"
        echo "Usage: $0 [unit|integration|python|scripts|all]"
        exit 1
        ;;
esac
