#!/usr/bin/env bash
# All tests with luacov coverage of lua/. Not part of a push; run it when you want the number.
# Usage: ./scripts/coverage.sh     Writes .reports/coverage/coverage.txt and prints the total.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/.reports/coverage"
STATS="$OUT/luacov.stats.out"
mkdir -p "$OUT"
cd "$ROOT" || exit 1

NVIM_COVERAGE="$STATS" ./scripts/run_tests.sh all || exit 1

cat >"$OUT/.luacov" <<LUACOV
return {
  statsfile = "$STATS",
  reportfile = "$OUT/coverage.txt",
  include = { "lua/" },
  exclude = {},
}
LUACOV
# Run the reporter under nvim's LuaJIT; PUC Lua 5.1 cannot parse goto/labels
cat >"$OUT/.luacov.lua" <<'LUA'
package.path = package.path
  .. ";/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua"
-- cluacov is built against PUC Lua; loading it into LuaJIT segfaults
package.preload["cluacov.version"] = function()
  error("cluacov disabled under LuaJIT")
end
require("luacov.runner").load_config(arg[1])
require("luacov.reporter").report()
LUA
nvim --headless --clean -l "$OUT/.luacov.lua" "$OUT/.luacov"
rm -f "$STATS" "$OUT/.luacov" "$OUT/.luacov.lua"
echo "coverage $(tail -1 "$OUT/coverage.txt" | awk '{print $NF}'), details in $OUT/coverage.txt"
