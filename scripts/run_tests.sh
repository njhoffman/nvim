#!/usr/bin/env bash
# Test runner script for Neovim configuration
# Usage: ./scripts/run_tests.sh [unit|integration|all]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
TEST_TYPE="${1:-all}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running Neovim Configuration Tests${NC}"
echo "========================================"
echo ""

run_plenary_tests() {
    echo -e "${YELLOW}Running Plenary (Unit) Tests...${NC}"
    # Coverage runs write to one stats file, so run spec files sequentially;
    # the pure-Lua coverage hook is slow, so allow a longer per-file timeout
    local sequential="false" timeout=50000
    if [ -n "${NVIM_COVERAGE:-}" ]; then
        sequential="true"
        timeout=600000
    fi
    nvim --headless --noplugin -u "$NVIM_CONFIG_DIR/tests/minimal_init.lua" \
        -c "PlenaryBustedDirectory $NVIM_CONFIG_DIR/tests/unit/ { minimal_init = '$NVIM_CONFIG_DIR/tests/minimal_init.lua', sequential = $sequential, timeout = $timeout }"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Plenary tests passed${NC}"
        return 0
    else
        echo -e "${RED}✗ Plenary tests failed${NC}"
        return 1
    fi
}

run_minitest_tests() {
    echo -e "${YELLOW}Running Mini.test (Integration) Tests...${NC}"
    nvim --headless --noplugin -u "$NVIM_CONFIG_DIR/tests/minimal_init.lua" \
        -l "$NVIM_CONFIG_DIR/scripts/run_minitest.lua"

    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ Mini.test tests passed${NC}"
        return 0
    else
        echo -e "${RED}✗ Mini.test tests failed${NC}"
        return 1
    fi
}

run_all_tests() {
    local failed=0

    run_plenary_tests || failed=1
    echo ""
    run_minitest_tests || failed=1

    echo ""
    echo "========================================"
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
    else
        echo -e "${RED}Some tests failed!${NC}"
    fi

    return $failed
}

# Main execution
case "$TEST_TYPE" in
    unit)
        run_plenary_tests
        ;;
    integration)
        run_minitest_tests
        ;;
    all)
        run_all_tests
        ;;
    *)
        echo -e "${RED}Invalid test type: $TEST_TYPE${NC}"
        echo "Usage: $0 [unit|integration|all]"
        exit 1
        ;;
esac

exit $?
