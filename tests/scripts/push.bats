#!/usr/bin/env bats
# scripts/release.sh, scripts/push.sh and the pre-push hook, in a scratch repo with a stub report.

setup() {
  ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  T="$BATS_TEST_TMPDIR"
  git init -q --bare -b main "$T/origin.git"
  git init -q -b main "$T/repo"
  cd "$T/repo"
  git config user.email t@example.com
  git config user.name t
  mkdir -p scripts/hooks benchmarks docs tests/unit
  cp "$ROOT/scripts/release.sh" "$ROOT/scripts/push.sh" "$ROOT/scripts/report_summary.py" scripts/
  cp "$ROOT/scripts/hooks/pre-push" scripts/hooks/
  # What report.sh does: write the report and the benchmark files, print the directory
  cat >scripts/report.sh <<'STUB'
#!/usr/bin/env bash
[ -z "${REPORT_FAILS:-}" ] || { echo "report: failed" >&2; exit 1; }
d="$PWD/.reports/2026-01-02.03:04"
mkdir -p "$d"
echo "version $1" >"$d/args"
printf 'Success: \t3\t\nTotal number of cases: 2\nRan 1 test in 0s\nok 1 a\nok 2 b\n' >"$d/tests.log"
printf 'Total   10 5  66.67%%\n' >"$d/coverage.txt"
echo '{"Lua":{"code":100,"nFiles":2},"Markdown":{"code":5,"nFiles":1},"SUM":{"code":105,"nFiles":3}}' >"$d/main.json"
echo 'bench table' >"$d/bench.md"
echo "$1" >>benchmarks/history.tsv
echo "$1" >>docs/PERFORMANCE.md
echo "$d"
STUB
  chmod +x scripts/report.sh
  printf '.reports/*\n' >.gitignore
  printf '# Changelog\n\n## [0.1.0] - 2026-01-01\n\n### Added\n\n- First.\n' >CHANGELOG.md
  touch benchmarks/history.tsv docs/PERFORMANCE.md
  git add -A
  git commit -qm "v0.1.0: first"
  git tag -a v0.1.0 -m v0.1.0
  git remote add origin "$T/origin.git"
  git push -q origin main --follow-tags
  git config core.hooksPath scripts/hooks
}

release() {
  echo "$1" >"file$1"
  printf '# Changelog\n\n## [%s] - 2026-01-02\n\n### Added\n\n- Change %s.\n\n%s\n' "$1" "$1" \
    "$(tail -n +3 CHANGELOG.md)" >CHANGELOG.md
  git add "file$1"
  ./scripts/release.sh "$1" "change $1"
}

remote_tip() {
  git --git-dir="$T/origin.git" rev-parse main
}

@test "release.sh commits and tags without pushing" {
  before="$(remote_tip)"
  run release 0.2.0
  [ "$status" -eq 0 ]
  git rev-parse -q --verify refs/tags/v0.2.0
  [ "$(remote_tip)" = "$before" ]
  ! git --git-dir="$T/origin.git" rev-parse -q --verify refs/tags/v0.2.0
}

@test "pre-push refuses a plain push of main and names the script" {
  release 0.2.0
  run git push origin main
  [ "$status" -ne 0 ]
  [[ "$output" == *"scripts/push.sh"* ]]
}

@test "pre-push lets other branches and --no-verify through" {
  release 0.2.0
  git push -q origin HEAD:refs/heads/topic
  git push -q --no-verify origin main
}

@test "push.sh reports the latest version, commits the report and pushes it with the tags" {
  release 0.2.0
  release 0.3.0
  run ./scripts/push.sh
  [ "$status" -eq 0 ]
  [ "$(cat .reports/2026-01-02.03:04/args)" = "version 0.3.0" ]
  [ "$(remote_tip)" = "$(git rev-parse HEAD)" ]
  git log -1 --format=%B | grep -q '^Report: passed$'
  git --git-dir="$T/origin.git" rev-parse -q --verify refs/tags/v0.2.0
  git --git-dir="$T/origin.git" rev-parse -q --verify refs/tags/v0.3.0
  git show --stat --format= HEAD | grep -q summary.md
  git show --stat --format= HEAD | grep -q history.tsv
  [ -z "$(git status --porcelain --untracked-files=no)" ]
}

@test "the summary has every version since the last push, stats and benchmarks" {
  release 0.2.0
  release 0.3.0
  ./scripts/push.sh
  summary=.reports/2026-01-02.03:04/summary.md
  head -1 "$summary" | grep -qF '(v0.3.0)'
  grep -q 'Change 0.2.0' "$summary"
  grep -q 'Change 0.3.0' "$summary"
  ! grep -q 'First\.' "$summary"
  grep -q '8/8 (3 plenary, 2 mini.test, 1 Python, 2 bats)' "$summary"
  grep -q '66.67%' "$summary"
  grep -q 'bench table' "$summary"
}

@test "a failed report commits and pushes nothing" {
  release 0.2.0
  head_before="$(git rev-parse HEAD)"
  remote_before="$(remote_tip)"
  REPORT_FAILS=1 run ./scripts/push.sh
  [ "$status" -ne 0 ]
  [ "$(git rev-parse HEAD)" = "$head_before" ]
  [ "$(remote_tip)" = "$remote_before" ]
}

@test "push.sh refuses uncommitted tracked changes" {
  release 0.2.0
  echo x >>file0.2.0
  run ./scripts/push.sh
  [ "$status" -ne 0 ]
  [[ "$output" == *"uncommitted"* ]]
}

@test "push.sh refuses when origin has commits it lacks" {
  git clone -q "$T/origin.git" "$T/other"
  git -C "$T/other" -c user.email=t@example.com -c user.name=t commit -q --allow-empty -m other
  git -C "$T/other" push -q --no-verify origin main
  release 0.2.0
  run ./scripts/push.sh
  [ "$status" -ne 0 ]
  [[ "$output" == *"pull"* ]]
}

@test "push.sh with nothing new does nothing" {
  run ./scripts/push.sh
  [ "$status" -eq 0 ]
  [[ "$output" == *"nothing to push"* ]]
}

@test "push.sh retries a failed push without rerunning the report" {
  release 0.2.0
  git commit -q --allow-empty -m "v0.2.0: report" -m "Report: passed"
  rm scripts/report.sh
  run ./scripts/push.sh
  [ "$status" -eq 0 ]
  [ "$(remote_tip)" = "$(git rev-parse HEAD)" ]
}
