#!/usr/bin/env bash
# Pre-release report: runs tests with coverage, collects cloc stats, runs the benchmarks.
# Usage: ./scripts/report.sh [VERSION]
# Writes raw data to .reports/<timestamp>/ and prints the directory.
# With VERSION, the benchmarks are recorded as that release in benchmarks/history.tsv and
# docs/PERFORMANCE.md is updated; without it they are measured but not recorded.
# BENCH=0 skips the benchmarks.
# Exits non-zero (and removes the directory) if any test fails or the benchmarks fail.

set -uo pipefail

VERSION="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
REPORT_DIR="$NVIM_CONFIG_DIR/.reports/$(date '+%Y-%m-%d.%H:%M')"
STATS_FILE="$REPORT_DIR/luacov.stats.out"

mkdir -p "$REPORT_DIR"
cd "$NVIM_CONFIG_DIR" || exit 1

if ! NVIM_COVERAGE="$STATS_FILE" "$SCRIPT_DIR/run_tests.sh" all >"$REPORT_DIR/tests.log" 2>&1; then
  sed 's/\x1b\[[0-9;]*m//g' "$REPORT_DIR/tests.log" | grep -E '^(Fail|Errors?)\s*\|\|' -A6 >&2
  echo "Tests failed; report aborted" >&2
  rm -rf "$REPORT_DIR"
  exit 1
fi

# Coverage report from collected stats, then drop the raw stats file
cat >"$REPORT_DIR/.luacov" <<LUACOV
return {
  statsfile = "$STATS_FILE",
  reportfile = "$REPORT_DIR/coverage.txt",
  include = { "lua/" },
  exclude = { "lua/plenary/" },
}
LUACOV
# Run the reporter under nvim's LuaJIT; PUC Lua 5.1 cannot parse goto/labels
cat >"$REPORT_DIR/.luacov.lua" <<'LUA'
package.path = package.path
  .. ";/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua"
-- cluacov is built against PUC Lua; loading it into LuaJIT segfaults
package.preload["cluacov.version"] = function()
  error("cluacov disabled under LuaJIT")
end
require("luacov.runner").load_config(arg[1])
require("luacov.reporter").report()
LUA
nvim --headless --clean -l "$REPORT_DIR/.luacov.lua" "$REPORT_DIR/.luacov"
rm -f "$STATS_FILE" "$REPORT_DIR/.luacov" "$REPORT_DIR/.luacov.lua"

# Code stats; the reports and the generated benchmark fixtures are excluded from analysis.
# Relative path on purpose: an absolute path under ~/.config yields {}
cloc --json --follow-links --exclude-dir=.reports,.git,node_modules,__pycache__ \
  --fullpath --not-match-d='.*benchmarks/fixtures.*' \
  --report-file="$REPORT_DIR/main.json" . >/dev/null
# No --follow-links here: plugin test fixtures contain symlink loops
cloc --json \
  --report-file="$REPORT_DIR/lazy.json" "$HOME/.local/share/nvim/lazy" >/dev/null

sed -i 's/\x1b\[[0-9;]*m//g' "$REPORT_DIR/tests.log"

# Startup and rendering benchmarks (benchmarks/README.md); about two minutes
if [ "${BENCH:-1}" != "0" ]; then
  bench_args=(--cloc-dir "$REPORT_DIR" --out "$REPORT_DIR/bench.md")
  [ -n "$VERSION" ] && bench_args+=(--release "$VERSION")
  if ! "$NVIM_CONFIG_DIR/benchmarks/run" "${bench_args[@]}" >/dev/null 2>"$REPORT_DIR/bench.log"; then
    cat "$REPORT_DIR/bench.log" >&2
    echo "Benchmarks failed; report aborted" >&2
    rm -rf "$REPORT_DIR"
    exit 1
  fi
  grep 'warning:' "$REPORT_DIR/bench.log" >&2 || true
fi

echo "$REPORT_DIR"
