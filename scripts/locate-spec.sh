#!/usr/bin/env bash
# The locate order from references/locate-spec.md, as the one executable every
# sextant surface runs: the three skills and the ledger-signal hook. The
# reference is the rule; this is its only implementation.
#
# Usage: locate-spec.sh [dir]   (dir defaults to the git toplevel, else cwd)
#
# Stdout, KEY=VALUE lines, paths relative to the repo root:
#   SPEC=<path>          the active spec
#   STATUS=<path>        the root STATUS.md, empty when there is none
#   VIA=<step>           status-pointer | spec-dir | root
#   CANDIDATE=<path>     one per spec, on exit 2 only
#   POINTER=<path>       the missing target, on exit 3 only
#
# Exit: 0 found · 1 no spec · 2 more than one spec under spec/ and no STATUS.md
# pointer naming one · 3 STATUS.md points at a file that does not exist · 64
# usage.

set -uo pipefail

if [ $# -gt 1 ]; then
  echo "usage: locate-spec.sh [dir]" >&2
  exit 64
fi

if [ $# -eq 1 ]; then
  root=$1
elif ! root=$(git rev-parse --show-toplevel 2>/dev/null); then
  root=$PWD
fi
cd "$root" 2>/dev/null || { echo "locate-spec.sh: no such directory: $root" >&2; exit 64; }

status=
[ -f STATUS.md ] && status=STATUS.md

found() {
  printf 'SPEC=%s\nSTATUS=%s\nVIA=%s\n' "$1" "$status" "$2"
  exit 0
}

# 1. The spec-pointer link on STATUS.md's `Tracking ...` header line.
if [ -n "$status" ]; then
  pointer=$(grep -m1 '^Tracking ' STATUS.md | grep -oE '\]\([^)]+\)' | head -n1 | sed -E 's/^\]\(//; s/\)$//; s/#.*//; s|^\./||')
  if [ -n "$pointer" ]; then
    [ -f "$pointer" ] || { printf 'POINTER=%s\n' "$pointer"; exit 3; }
    found "$pointer" status-pointer
  fi
fi

# 2. A spec/ directory holding exactly one spec.
candidates=
for f in spec/SPEC.md spec/*/SPEC.md; do
  [ -f "$f" ] && candidates="$candidates$f"$'\n'
done

if [ -n "$candidates" ]; then
  if [ "$(printf '%s' "$candidates" | grep -c .)" -eq 1 ]; then
    found "${candidates%$'\n'}" spec-dir
  fi
  printf '%s' "$candidates" | sed 's/^/CANDIDATE=/'
  exit 2
fi

# 3. The repo root.
[ -f SPEC.md ] && found SPEC.md root
[ -f docs/spec.md ] && found docs/spec.md root

exit 1
