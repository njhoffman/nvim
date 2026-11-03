#!/usr/bin/env bash
# Run the release report for what is about to go out, commit its files and push. The report takes
# 10-20 minutes; if it fails nothing is committed or pushed. scripts/hooks/pre-push refuses a plain
# `git push` of main whose tip did not come from here (`git push --no-verify` skips that).
# Usage: ./scripts/push.sh
# RELEASE_TRAILER (optional) is appended to the report commit, e.g. a Co-Authored-By line.

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
[ "$branch" = "main" ] || die "on '$branch': only main is reported; push other branches with git push"

git fetch --quiet origin main
[ "$(git rev-list --count HEAD..origin/main)" -eq 0 ] || die "origin/main has commits you don't: pull first"
if [ "$(git rev-list --count origin/main..HEAD)" -eq 0 ]; then
  echo "push: nothing to push"
  exit 0
fi

# A report commit at the tip already passed; only the push failed last time
if git log -1 --format=%B | grep -q '^Report: passed$'; then
  git push origin HEAD --follow-tags
  exit 0
fi

[ -z "$(git status --porcelain --untracked-files=no)" ] ||
  die "tracked files have uncommitted changes; the report must test what gets pushed"

version="$(git describe --tags --abbrev=0 --match 'v[0-9]*' HEAD)" || die "no version tag: release first"
version="${version#v}"
previous="$(git describe --tags --abbrev=0 --match 'v[0-9]*' origin/main 2>/dev/null || true)"

report_dir="$(./scripts/report.sh "$version")" || die "report failed; nothing pushed (see .reports/failed/)"
report_dir="$(realpath --relative-to=. "$report_dir")"

python3 scripts/report_summary.py "$report_dir" "$version" "${previous#v}" >"$report_dir/summary.md"

git add -f "$report_dir/summary.md"
git add benchmarks/history.tsv docs/PERFORMANCE.md
commit_args=(-m "v$version: report" -m "Report: passed")
[ -n "${RELEASE_TRAILER:-}" ] && commit_args+=(-m "$RELEASE_TRAILER")
git commit --quiet "${commit_args[@]}"
git push origin HEAD --follow-tags
echo "pushed v$version; report in $report_dir"
