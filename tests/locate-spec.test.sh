#!/usr/bin/env bash
# Each step and exit code references/locate-spec.md documents, run against
# scripts/locate-spec.sh.

. "$(dirname "$0")/lib.sh"

LOCATE="$REPO_ROOT/scripts/locate-spec.sh"

locate() {
  out=$(bash "$LOCATE" "$@")
  code=$?
}

repo=$(new_repo)
touch "$repo/SPEC.md"
locate "$repo"
assert_eq "root SPEC.md is found" "$out" $'SPEC=SPEC.md\nSTATUS=\nVIA=root'

repo=$(new_repo)
mkdir "$repo/docs"
touch "$repo/docs/spec.md"
locate "$repo"
assert_eq "root docs/spec.md is found" "$out" $'SPEC=docs/spec.md\nSTATUS=\nVIA=root'

repo=$(new_repo)
touch "$repo/SPEC.md"
printf '# x\n\nNo pointer on this ledger.\n' >"$repo/STATUS.md"
locate "$repo"
assert_eq "a STATUS.md with no pointer falls through to the root" "$out" $'SPEC=SPEC.md\nSTATUS=STATUS.md\nVIA=root'

repo=$(new_repo)
mkdir "$repo/docs" "$repo/spec"
touch "$repo/SPEC.md" "$repo/docs/spec.md" "$repo/spec/SPEC.md"
printf '# x\n\nTracking the requirements declared in [`docs/spec.md`](docs/spec.md#top).\n' >"$repo/STATUS.md"
locate "$repo"
assert_eq "the STATUS.md pointer wins over every other step" "$out" $'SPEC=docs/spec.md\nSTATUS=STATUS.md\nVIA=status-pointer'

repo=$(new_repo)
printf 'Tracking the requirements declared in [`gone.md`](./gone.md).\n' >"$repo/STATUS.md"
touch "$repo/SPEC.md"
locate "$repo"
assert_eq "a pointer to a missing file exits 3" "$code" 3
assert_eq "a pointer to a missing file names it" "$out" "POINTER=gone.md"

repo=$(new_repo)
mkdir -p "$repo/spec/v1"
touch "$repo/spec/v1/SPEC.md" "$repo/SPEC.md"
locate "$repo"
assert_eq "one spec under spec/ wins over the root" "$out" $'SPEC=spec/v1/SPEC.md\nSTATUS=\nVIA=spec-dir'

repo=$(new_repo)
mkdir -p "$repo/spec/v1" "$repo/spec/v2"
touch "$repo/spec/v1/SPEC.md" "$repo/spec/v2/SPEC.md"
printf 'Tracking the requirements declared in [`spec/v2/SPEC.md`](spec/v2/SPEC.md).\n' >"$repo/STATUS.md"
locate "$repo"
assert_eq "a STATUS.md pointer picks among several under spec/" "$out" $'SPEC=spec/v2/SPEC.md\nSTATUS=STATUS.md\nVIA=status-pointer'

repo=$(new_repo)
mkdir -p "$repo/spec/v1" "$repo/spec/v2"
touch "$repo/spec/v1/SPEC.md" "$repo/spec/v2/SPEC.md"
printf 'spec := "v2"\n' >"$repo/justfile"
locate "$repo"
assert_eq "several specs and no pointer exits 2, whatever the justfile says" "$code" 2
assert_eq "several specs and no pointer lists each" "$out" $'CANDIDATE=spec/v1/SPEC.md\nCANDIDATE=spec/v2/SPEC.md'

repo=$(new_repo)
locate "$repo"
assert_eq "no spec exits 1" "$code" 1
assert_empty "no spec prints nothing" "$out"

repo=$(new_repo)
touch "$repo/SPEC.md"
mkdir "$repo/src"
out=$(cd "$repo/src" && bash "$LOCATE")
assert_eq "with no argument it resolves from the git toplevel" "$out" $'SPEC=SPEC.md\nSTATUS=\nVIA=root'

locate a b
assert_eq "two arguments is a usage error" "$code" 64

finish
