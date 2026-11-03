#!/usr/bin/env bats
# scripts/run_tests.sh: parallel unit specs, progress lines, failures and timeouts

setup() {
  ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  UNIT="$BATS_TEST_TMPDIR/unit"
  mkdir -p "$UNIT"
  cat >"$UNIT/pass_spec.lua" <<'LUA'
describe("pass", function()
  it("works", function()
    assert.are.equal(2, 1 + 1)
  end)
end)
LUA
}

add_failing_spec() {
  cat >"$UNIT/fail_spec.lua" <<'LUA'
describe("fail", function()
  it("breaks on purpose", function()
    assert.are.equal(1, 2)
  end)
end)
LUA
}

run_unit() {
  run env -u NVIM_COVERAGE UNIT_DIR="$UNIT" TEST_JOBS=2 "$@" "$ROOT/scripts/run_tests.sh" unit
}

@test "passes and prints one progress line per spec file" {
  cp "$UNIT/pass_spec.lua" "$UNIT/pass2_spec.lua"
  run_unit
  [ "$status" -eq 0 ]
  [[ "$output" == *"progress: unit: 2 spec files, 2 at a time"* ]]
  [[ "$output" == *"pass_spec ok"* ]]
  [[ "$output" == *"pass2_spec ok"* ]]
  [[ "$output" =~ progress:\ unit\ 2/2 ]]
}

@test "keeps the per-spec summary lines without carriage returns" {
  run_unit
  [ "$status" -eq 0 ]
  [[ "$output" == *"Testing: $UNIT/pass_spec.lua"* ]]
  ! grep -q $'\r' <<<"$output"
}

@test "fails when a spec fails and names the failing test" {
  add_failing_spec
  run_unit
  [ "$status" -eq 1 ]
  [[ "$output" == *"fail_spec FAIL (exit 1)"* ]]
  [[ "$output" == *"progress:   Fail || fail breaks on purpose"* ]]
  [[ "$output" == *"pass_spec ok"* ]]
}

@test "reports a spec that exceeds TEST_TIMEOUT" {
  cat >"$UNIT/slow_spec.lua" <<'LUA'
describe("slow", function()
  it("sleeps", function()
    vim.uv.sleep(5000)
  end)
end)
LUA
  run_unit TEST_TIMEOUT=1
  [ "$status" -eq 1 ]
  [[ "$output" == *"slow_spec TIMEOUT after 1s"* ]]
  [[ "$output" == *"Timeout: $UNIT/slow_spec.lua did not finish within 1s"* ]]
}

@test "merges per-spec coverage stats into NVIM_COVERAGE" {
  cat >"$UNIT/cover_spec.lua" <<'LUA'
describe("cover", function()
  it("loads a config module", function()
    assert.is_table(require("modules.tmux.layout.parse"))
  end)
end)
LUA
  rm "$UNIT/pass_spec.lua"
  run_unit NVIM_COVERAGE="$BATS_TEST_TMPDIR/cov.stats"
  [ "$status" -eq 0 ]
  [ -s "$BATS_TEST_TMPDIR/cov.stats" ]
  grep -q "lua/modules/tmux/layout/parse.lua" "$BATS_TEST_TMPDIR/cov.stats"
}

@test "adds to stats already in NVIM_COVERAGE instead of replacing them" {
  printf '2:lua/keep.lua\n3 0 \n' >"$BATS_TEST_TMPDIR/cov.stats"
  run_unit NVIM_COVERAGE="$BATS_TEST_TMPDIR/cov.stats"
  [ "$status" -eq 0 ]
  grep -q "lua/keep.lua" "$BATS_TEST_TMPDIR/cov.stats"
}

@test "rejects an unknown test type" {
  run "$ROOT/scripts/run_tests.sh" nope
  [ "$status" -eq 1 ]
  [[ "$output" == *"Invalid test type: nope"* ]]
}
