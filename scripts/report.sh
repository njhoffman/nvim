#!/usr/bin/env bash
# Pre-release report: runs tests with coverage, collects cloc stats, runs the benchmarks.
# Usage: ./scripts/report.sh [VERSION]
# Writes raw data to .reports/<timestamp>/ and prints the directory.
# With VERSION, the benchmarks are recorded as that release in benchmarks/history.tsv and
# docs/PERFORMANCE.md is updated; without it they are measured but not recorded.
# BENCH=0 skips the benchmarks.
# Progress goes to stderr as it happens: each phase with its duration, one line per spec file
# (and each failure), and the benchmark's load waits and sessions.
# Exits non-zero if any test fails or the benchmarks fail; the report directory is then moved
# to .reports/failed/<timestamp>/ (gitignored) so tests.log and bench.log survive.

set -uo pipefail

VERSION="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
STAMP="$(date '+%Y-%m-%d.%H:%M')"
REPORT_DIR="$NVIM_CONFIG_DIR/.reports/$STAMP"
STATS_FILE="$REPORT_DIR/luacov.stats.out"
CLOC_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/nvim-report"
LAZY_DIR="$HOME/.local/share/nvim/lazy"

mkdir -p "$REPORT_DIR"
cd "$NVIM_CONFIG_DIR" || exit 1

REPORT_START=$SECONDS
PHASE_START=$SECONDS

say() {
  echo "report: [$(date +%H:%M:%S)] $*" >&2
}

phase() {
  PHASE_START=$SECONDS
  say "$*"
}

phase_done() {
  say "$1 done in $((SECONDS - PHASE_START))s"
}

abort() {
  local failed_dir="$NVIM_CONFIG_DIR/.reports/failed/$STAMP"
  mkdir -p "$(dirname "$failed_dir")"
  rm -f "$STATS_FILE"
  mv "$REPORT_DIR" "$failed_dir"
  say "$1; report aborted after $((SECONDS - REPORT_START))s, logs in $failed_dir"
  exit 1
}

# Tests: stdout to tests.log; progress lines (stderr) shown live and kept in progress.log
phase "tests (unit specs in parallel, with coverage), then mini.test and Python"
exec 3>"$REPORT_DIR/tests.log"
NVIM_COVERAGE="$STATS_FILE" "$SCRIPT_DIR/run_tests.sh" all 2>&1 1>&3 |
  tee "$REPORT_DIR/progress.log" | sed -u 's/^progress: /report:   /' >&2
tests_status=${PIPESTATUS[0]}
exec 3>&-
sed -i 's/\x1b\[[0-9;]*m//g' "$REPORT_DIR/tests.log"
if [ "$tests_status" -ne 0 ]; then
  grep -E '^(Fail|Errors?)\s*\|\||^Timeout:' -A6 "$REPORT_DIR/tests.log" >&2
  abort "tests failed"
fi
phase_done "tests"

# Coverage report from collected stats, then drop the raw stats file
phase "coverage report"
cat >"$REPORT_DIR/.luacov" <<LUACOV
return {
  statsfile = "$STATS_FILE",
  reportfile = "$REPORT_DIR/coverage.txt",
  include = { "lua/" },
  exclude = {},
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
say "coverage $(tail -1 "$REPORT_DIR/coverage.txt" | awk '{print $NF}')"
phase_done "coverage report"

# Code stats; the reports and the generated benchmark fixtures are excluded from analysis.
# Relative path on purpose: an absolute path under ~/.config yields {}
phase "cloc"
cloc --json --follow-links --exclude-dir=.reports,.git,node_modules,__pycache__ \
  --fullpath --not-match-d='.*benchmarks/fixtures.*' \
  --report-file="$REPORT_DIR/main.json" . >/dev/null
# The plugin tree only changes with plugin updates: cache its cloc by lazy-lock.json and the
# installed plugin directories. No --follow-links here: plugin test fixtures contain symlink loops
lazy_key="$({ cat lazy-lock.json; ls -1 "$LAZY_DIR"; } 2>/dev/null | sha256sum | cut -c1-16)"
lazy_cached="$CLOC_CACHE/lazy-$lazy_key.json"
if [ -s "$lazy_cached" ]; then
  cp "$lazy_cached" "$REPORT_DIR/lazy.json"
  say "plugin cloc from cache ($lazy_key)"
else
  cloc --json --report-file="$REPORT_DIR/lazy.json" "$LAZY_DIR" >/dev/null
  mkdir -p "$CLOC_CACHE"
  cp "$REPORT_DIR/lazy.json" "$lazy_cached"
  say "plugin cloc cached ($lazy_key)"
fi
phase_done "cloc"

# Startup and rendering benchmarks (benchmarks/README.md). They wait for a low load first;
# their log lines (load waits, sessions, warnings) are shown as they happen.
if [ "${BENCH:-1}" != "0" ]; then
  phase "benchmarks"
  bench_args=(--cloc-dir "$REPORT_DIR" --out "$REPORT_DIR/bench.md")
  [ -n "$VERSION" ] && bench_args+=(--release "$VERSION")
  "$NVIM_CONFIG_DIR/benchmarks/run" "${bench_args[@]}" 2>&1 1>/dev/null |
    tee "$REPORT_DIR/bench.log" | sed -u 's/^bench: /report:   /' >&2
  bench_status=${PIPESTATUS[0]}
  [ "$bench_status" -eq 0 ] || abort "benchmarks failed"
  phase_done "benchmarks"
fi

say "finished in $((SECONDS - REPORT_START))s"
echo "$REPORT_DIR"
