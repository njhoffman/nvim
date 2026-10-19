#!/usr/bin/env bash
# Commit staged changes, create an annotated semver tag, and push.
# Usage: ./scripts/release.sh <X.Y.Z> "<summary>"
# Requires: a passing ./scripts/report.sh run and a "## [X.Y.Z]" CHANGELOG.md section.
# RELEASE_TRAILER (optional) is appended to the commit message, e.g. a Co-Authored-By line.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(dirname "$SCRIPT_DIR")"

die() {
  echo "release: $*" >&2
  exit 1
}

version="${1:-}"
summary="${2:-}"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "version must be X.Y.Z, got '$version'"
[ -n "$summary" ] || die "summary is required"

tag="v$version"
git rev-parse -q --verify "refs/tags/$tag" >/dev/null && die "tag $tag already exists"

latest="$(git tag --list 'v[0-9]*.[0-9]*.[0-9]*' --sort=-v:refname | head -1)"
if [ -n "$latest" ]; then
  highest="$(printf '%s\n%s\n' "${latest#v}" "$version" | sort -V | tail -1)"
  [ "$highest" = "$version" ] || die "$tag is not newer than $latest"
fi

grep -q "^## \[$version\]" CHANGELOG.md || die "CHANGELOG.md has no '## [$version]' section"
git diff --cached --quiet -- CHANGELOG.md && git diff --quiet HEAD -- CHANGELOG.md &&
  die "CHANGELOG.md is not part of this release"

git add CHANGELOG.md
git diff --cached --quiet && die "nothing staged to commit"

commit_args=(-m "$tag: $summary")
[ -n "${RELEASE_TRAILER:-}" ] && commit_args+=(-m "$RELEASE_TRAILER")
git commit "${commit_args[@]}"
git tag -a "$tag" -m "$tag: $summary"
git push origin HEAD --follow-tags
echo "released $tag"
