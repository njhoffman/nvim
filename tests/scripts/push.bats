#!/usr/bin/env bats
# scripts/release.sh, scripts/push.sh and the pre-push hook, in a scratch repo with a stub benchmarks/run.

setup() {
  ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  T="$BATS_TEST_TMPDIR"
  git init -q --bare -b main "$T/origin.git"
  git init -q -b main "$T/repo"
  cd "$T/repo"
  git config user.email t@example.com
  git config user.name t
  mkdir -p scripts/hooks benchmarks docs tests/unit
  cp "$ROOT/scripts/release.sh" "$ROOT/scripts/push.sh" scripts/
  cp "$ROOT/scripts/hooks/pre-push" scripts/hooks/
  # What benchmarks/run --release does: write the two recorded files
  cat >benchmarks/run <<'STUB'
#!/usr/bin/env bash
[ -z "${RECORD_FAILS:-}" ] || { echo "bench: failed" >&2; exit 1; }
echo "$*" >"$T_ARGS"
echo "$2" >>benchmarks/history.tsv
echo "$2" >>docs/PERFORMANCE.md
STUB
  chmod +x benchmarks/run
  export T_ARGS="$T/args"
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

@test "push.sh records the latest version, commits the metrics and pushes them with the tags" {
  release 0.2.0
  release 0.3.0
  run ./scripts/push.sh
  [ "$status" -eq 0 ]
  [ "$(cat "$T_ARGS")" = "--release 0.3.0" ]
  [ "$(remote_tip)" = "$(git rev-parse HEAD)" ]
  git log -1 --format=%B | grep -q '^Metrics: recorded$'
  git log -1 --format=%s | grep -qF 'v0.3.0: metrics'
  git --git-dir="$T/origin.git" rev-parse -q --verify refs/tags/v0.2.0
  git --git-dir="$T/origin.git" rev-parse -q --verify refs/tags/v0.3.0
  [ "$(git show --name-only --format= HEAD | sort | tr '\n' ' ')" = "benchmarks/history.tsv docs/PERFORMANCE.md " ]
  [ -z "$(git status --porcelain --untracked-files=no)" ]
}

@test "push.sh appends the trailer to the metrics commit" {
  release 0.2.0
  RELEASE_TRAILER="Co-Authored-By: X <x@example.com>" ./scripts/push.sh
  git log -1 --format=%B | grep -q '^Co-Authored-By: X'
}

@test "a failed recording commits and pushes nothing" {
  release 0.2.0
  head_before="$(git rev-parse HEAD)"
  remote_before="$(remote_tip)"
  RECORD_FAILS=1 run ./scripts/push.sh
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

@test "push.sh retries a failed push without recording again" {
  release 0.2.0
  git commit -q --allow-empty -m "v0.2.0: metrics" -m "Metrics: recorded"
  RECORD_FAILS=1 run ./scripts/push.sh
  [ "$status" -eq 0 ]
  [ "$(remote_tip)" = "$(git rev-parse HEAD)" ]
}
