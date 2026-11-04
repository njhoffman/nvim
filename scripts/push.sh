#!/usr/bin/env bash
# Record this push in benchmarks/history.tsv and docs/PERFORMANCE.md (plugins, files, lines, sizes,
# memory and benchmark times), commit that and push. Takes 2-3 minutes, or seconds when the machine
# is too busy to measure times. No tests run here: run them with each change. scripts/hooks/pre-push
# refuses a plain `git push` of main whose tip did not come from here (`--no-verify` skips that).
# Usage: ./scripts/push.sh
# RELEASE_TRAILER (optional) is appended to the metrics commit, e.g. a Co-Authored-By line.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(dirname "$SCRIPT_DIR")"

die() {
  echo "push: $*" >&2
  exit 1
}

# A fresh clone has no hook until this runs
git config core.hooksPath scripts/hooks

branch="$(git symbolic-ref --short HEAD)"
[ "$branch" = "main" ] || die "on '$branch': only main is recorded; push other branches with git push"

git fetch --quiet origin main
[ "$(git rev-list --count HEAD..origin/main)" -eq 0 ] || die "origin/main has commits you don't: pull first"
if [ "$(git rev-list --count origin/main..HEAD)" -eq 0 ]; then
  echo "push: nothing to push"
  exit 0
fi

# A metrics commit at the tip is already recorded; only the push failed last time
if git log -1 --format=%B | grep -q '^Metrics: recorded$'; then
  git push origin HEAD --follow-tags
  exit 0
fi

[ -z "$(git status --porcelain --untracked-files=no)" ] ||
  die "tracked files have uncommitted changes; the metrics must measure what gets pushed"

version="$(git describe --tags --abbrev=0 --match 'v[0-9]*' HEAD)" || die "no version tag: release first"
version="${version#v}"

benchmarks/run --release "$version" >/dev/null || die "recording failed; nothing pushed"

git add benchmarks/history.tsv docs/PERFORMANCE.md
commit_args=(-m "v$version: metrics" -m "Metrics: recorded")
[ -n "${RELEASE_TRAILER:-}" ] && commit_args+=(-m "$RELEASE_TRAILER")
git commit --quiet --allow-empty "${commit_args[@]}"
git push origin HEAD --follow-tags
echo "pushed v$version"
