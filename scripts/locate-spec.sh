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
#   POINTER=<path>       the broken target, control characters stripped, on
#                        exit 3 only
#
# Exit: 0 found · 1 no spec · 2 more than one spec under spec/ and no STATUS.md
# pointer naming one · 3 STATUS.md points at a file that does not exist, or at
# a path containing control characters · 64 usage.

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

# `[ -f ]` on a case-insensitive filesystem (the macOS default) also matches
# `spec.md` for `SPEC.md`, and the path printed would then differ from the one
# git reports. Each component has to match a directory entry exactly.
is_file() {
  local dir=. part parts
  case $1 in /*) dir= ;; esac
  IFS=/ read -ra parts <<<"$1"
  for part in "${parts[@]}"; do
    [ -n "$part" ] || continue
    grep -qxF -- "$part" <<<"$(ls -1a "${dir:-/}" 2>/dev/null)" || return 1
    dir=$dir/$part
  done
  [ -f "$1" ]
}

status=
is_file STATUS.md && status=STATUS.md

found() {
  printf 'SPEC=%s\nSTATUS=%s\nVIA=%s\n' "$1" "$status" "$2"
  exit 0
}

# 1. The spec-pointer: the first link on STATUS.md's `Tracking ...` header line
# that names a file rather than a URL. A link title is dropped, and a leading
# `/` means the repo root, as it does on GitHub.
if [ -n "$status" ]; then
  pointer=$(grep -m1 '^Tracking ' STATUS.md | grep -oE '\]\([^)]+\)' |
    sed -E 's/^\]\(//; s/\)$//; s/[[:space:]]+"[^"]*"$//; s/#.*//; s|^\./||; s|^/||' |
    grep -vE '^[A-Za-z][A-Za-z0-9+.-]*:' | head -n1)
  if [ -n "$pointer" ]; then
    case $pointer in
      *[[:cntrl:]]*) printf 'POINTER=%s\n' "$(printf '%s' "$pointer" | tr -d '[:cntrl:]')"; exit 3 ;;
    esac
    is_file "$pointer" || { printf 'POINTER=%s\n' "$pointer"; exit 3; }
    found "$pointer" status-pointer
  fi
fi

# 2. A spec/ directory holding exactly one spec.
candidates=
for f in spec/SPEC.md spec/*/SPEC.md; do
  is_file "$f" && candidates="$candidates$f"$'\n'
done

if [ -n "$candidates" ]; then
  if [ "$(printf '%s' "$candidates" | grep -c .)" -eq 1 ]; then
    found "${candidates%$'\n'}" spec-dir
  fi
  printf '%s' "$candidates" | sed 's/^/CANDIDATE=/'
  exit 2
fi

# 3. The repo root.
is_file SPEC.md && found SPEC.md root
is_file docs/spec.md && found docs/spec.md root

exit 1
