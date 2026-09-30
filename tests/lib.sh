# Shared by the tests/*.test.sh files: a scratch-repo builder and assertions.
# Source it; each test file runs its cases, then calls `finish`.

set -uo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SCRATCH=$(mktemp -d "${TMPDIR:-/tmp}/sextant-test.XXXXXX")
trap 'rm -rf "$SCRATCH"' EXIT

passed=0
failed=0

# A fresh git repo with one commit, and origin/HEAD pointing at it so a
# merge-base against the default branch resolves without a network remote.
new_repo() {
  local dir
  dir=$(mktemp -d "$SCRATCH/repo.XXXXXX")
  git -C "$dir" init -q -b main
  git -C "$dir" config user.email test@example.com
  git -C "$dir" config user.name test
  git -C "$dir" commit -q --allow-empty -m init
  git -C "$dir" update-ref refs/remotes/origin/main HEAD
  git -C "$dir" symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
  printf '%s' "$dir"
}

commit_all() {
  git -C "$1" add -A
  git -C "$1" commit -q -m "${2:-change}"
}

# Moves origin/main to HEAD, as if the branch so far had already landed.
publish() {
  git -C "$1" update-ref refs/remotes/origin/main HEAD
}

pass() {
  passed=$((passed + 1))
  printf 'ok    %s\n' "$1"
}

fail() {
  failed=$((failed + 1))
  printf 'FAIL  %s\n' "$1"
  [ $# -gt 1 ] && printf '      %s\n' "$2"
}

assert_eq() {
  if [ "$2" = "$3" ]; then pass "$1"; else fail "$1" "expected [$3], got [$2]"; fi
}

assert_contains() {
  case "$2" in
    *"$3"*) pass "$1" ;;
    *) fail "$1" "expected to find [$3] in [$2]" ;;
  esac
}

assert_empty() {
  if [ -z "$2" ]; then pass "$1"; else fail "$1" "expected no output, got [$2]"; fi
}

finish() {
  printf '\n%d passed, %d failed\n' "$passed" "$failed"
  [ "$failed" -eq 0 ]
}
