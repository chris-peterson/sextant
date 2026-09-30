#!/usr/bin/env bash
# The synthetic half of the subscriber's test: the announcement matches, the
# near-misses stay silent, each mechanical state names its skill, and no path
# writes a file or exits non-zero. The live half (a real `tack session end`
# with sextant mounted) is a manual check.

. "$(dirname "$0")/lib.sh"

HOOK="$REPO_ROOT/hooks/ledger-signal.sh"
BODY='{"session":"s1","route":"demo-route","tacks":["t1"],"deliverables":[]}'
ANNOUNCEMENT="codes.bridgeai.tack/session.ended $BODY"

# Runs the hook on a Bash tool response whose stdout is $2, from repo $1, and
# sets $context (the additionalContext it emitted), $code, and $dirty (whether
# the hook changed the working tree).
run_hook() {
  local repo=$1 stdout=$2 before raw out_file
  before=$(git -C "$repo" status --porcelain)
  # --rawfile, not --arg: Linux caps a single argument at 128 KB.
  out_file=$(mktemp "$SCRATCH/stdout.XXXXXX")
  printf '%s' "$stdout" >"$out_file"
  raw=$(jq -cn --arg cwd "$repo" --rawfile out "$out_file" \
    '{hook_event_name: "PostToolUse", tool_name: "Bash", cwd: $cwd, tool_response: {stdout: $out}}' |
    bash "$HOOK")
  code=$?
  context=$(printf '%s' "$raw" | jq -r '.hookSpecificOutput.additionalContext // empty' 2>/dev/null)
  [ -z "$raw" ] || [ -n "$context" ] || context="UNPARSED: $raw"
  dirty=no
  [ "$(git -C "$repo" status --porcelain)" = "$before" ] || dirty=yes
}

spec_repo() {
  local repo
  repo=$(new_repo)
  printf '# Spec\n' >"$repo/SPEC.md"
  printf 'Tracking the requirements declared in [`SPEC.md`](SPEC.md).\n' >"$repo/STATUS.md"
  commit_all "$repo" spec
  publish "$repo"
  git -C "$repo" checkout -q -b feature
  printf '%s' "$repo"
}

# --- the mechanical states ---

repo=$(spec_repo)
printf 'code\n' >"$repo/app.sh"
commit_all "$repo"
run_hook "$repo" "$ANNOUNCEMENT"
assert_contains "source only: names the state" "$context" "source changed, SPEC.md unchanged, STATUS.md unchanged"
assert_contains "source only: names spec-sync" "$context" "/sextant:spec-sync"
assert_contains "source only: names the route" "$context" 'route "demo-route"'
assert_eq "source only: exits 0" "$code" 0
assert_eq "source only: writes nothing" "$dirty" no

repo=$(spec_repo)
printf '# Spec\n\nmore\n' >"$repo/SPEC.md"
commit_all "$repo"
run_hook "$repo" "$ANNOUNCEMENT"
assert_contains "spec only: names the state" "$context" "SPEC.md changed, source unchanged, STATUS.md unchanged"
assert_contains "spec only: names spec-status" "$context" "/sextant:spec-status"

repo=$(spec_repo)
printf 'code\n' >"$repo/app.sh"
printf '# Spec\n\nmore\n' >"$repo/SPEC.md"
commit_all "$repo"
run_hook "$repo" "$ANNOUNCEMENT"
assert_contains "both: names the state" "$context" "source changed, SPEC.md changed, STATUS.md unchanged"
assert_contains "both: names spec-status" "$context" "/sextant:spec-status"

repo=$(spec_repo)
printf 'code\n' >"$repo/app.sh"
printf 'Tracking the requirements declared in [`SPEC.md`](SPEC.md).\n\nrefreshed\n' >"$repo/STATUS.md"
commit_all "$repo"
run_hook "$repo" "$ANNOUNCEMENT"
assert_empty "ledger changed: silent" "$context"

repo=$(spec_repo)
run_hook "$repo" "$ANNOUNCEMENT"
assert_empty "nothing changed: silent" "$context"

repo=$(spec_repo)
printf 'code\n' >"$repo/app.sh"
run_hook "$repo" "$ANNOUNCEMENT"
assert_contains "an untracked file counts as a source change" "$context" "source changed"
assert_eq "an untracked file: writes nothing" "$dirty" no

repo=$(spec_repo)
printf 'code\n' >"$repo/app.sh"
commit_all "$repo"
printf 'refreshed\n' >>"$repo/STATUS.md"
run_hook "$repo" "$ANNOUNCEMENT"
assert_empty "an uncommitted ledger refresh counts as reconciled" "$context"

repo=$(spec_repo)
git -C "$repo" checkout -q main
printf 'code\n' >"$repo/app.sh"
commit_all "$repo"
publish "$repo"
run_hook "$repo" "$ANNOUNCEMENT"
assert_empty "on the default branch, pushed commits are not the session's" "$context"

repo=$(spec_repo)
printf 'code\n' >"$repo/app.sh"
commit_all "$repo"
git -C "$repo" symbolic-ref --delete refs/remotes/origin/HEAD
run_hook "$repo" "$ANNOUNCEMENT"
assert_empty "no origin/HEAD: silent" "$context"
assert_eq "no origin/HEAD: exits 0" "$code" 0

# --- the matcher ---

repo=$(spec_repo)
printf 'code\n' >"$repo/app.sh"
commit_all "$repo"

run_hook "$repo" $'Closed.\n'"$ANNOUNCEMENT"$'\nroute saved'
assert_contains "the announcement on a later line matches" "$context" "source changed"

run_hook "$repo" "codes.bridgeai.tack/session.endedagain $BODY"
assert_empty "a longer key sharing the prefix: silent" "$context"

run_hook "$repo" "xcodes.bridgeai.tack/session.ended $BODY"
assert_empty "the key inside a larger word: silent" "$context"

run_hook "$repo" "echo codes.bridgeai.tack/session.ended $BODY"
assert_empty "the key mid-line: silent" "$context"

filler=$(head -c 400000 /dev/zero | tr '\0' 'y' | fold -w 100)
run_hook "$repo" "$ANNOUNCEMENT"$'\n'"$filler"
assert_contains "an announcement ahead of a large output still matches" "$context" "source changed"

run_hook "$repo" "echo codes.bridgeai.tack/session.ended $BODY"$'\n'"$ANNOUNCEMENT"
assert_contains "a mid-line near-miss doesn't mask a later announcement" "$context" "source changed"

run_hook "$repo" "codes.bridgeai.tack/session.endedagain $BODY"$'\n'"$ANNOUNCEMENT"
assert_contains "a longer-key near-miss doesn't mask a later announcement" "$context" "source changed"

run_hook "$repo" "codes.bridgeai.tack/session.started $BODY"
assert_empty "a sibling key: silent" "$context"

run_hook "$repo" 'codes.bridgeai.tack/session.ended {"route":'
assert_empty "a body that won't parse: silent" "$context"
assert_eq "a body that won't parse: exits 0" "$code" 0

run_hook "$repo" 'codes.bridgeai.tack/session.ended ["not","an","object"]'
assert_empty "a body that isn't an object: silent" "$context"

run_hook "$repo" "codes.bridgeai.tack/session.ended"
assert_empty "a key with no body: silent" "$context"

run_hook "$repo" $'total 8\n-rw-r--r-- 1 u g 0 app.sh'
assert_empty "unrelated output: silent" "$context"

out=$(printf 'not json' | bash "$HOOK")
assert_eq "stdin that isn't JSON: exits 0" "$?" 0
assert_empty "stdin that isn't JSON: silent" "$out"

out=$(bash "$HOOK" </dev/null)
assert_eq "empty stdin: exits 0" "$?" 0

# --- sanitizing ---

run_hook "$repo" 'codes.bridgeai.tack/session.ended {"route":"a\u001b]8;;x\u0007b\nc\u0085d"}'
assert_contains "control characters are stripped from the route" "$context" 'route "a]8;;xbcd"'

# --- the opt-out ---

git -C "$repo" config sextant.subscribe.tack.session-ended false
run_hook "$repo" "$ANNOUNCEMENT"
assert_empty "sextant.subscribe.tack.session-ended false: silent" "$context"
git -C "$repo" config --unset sextant.subscribe.tack.session-ended

git -C "$repo" config sextant.subscribe.tack false
run_hook "$repo" "$ANNOUNCEMENT"
assert_empty "sextant.subscribe.tack false: silent" "$context"

git -C "$repo" config sextant.subscribe.tack true
run_hook "$repo" "$ANNOUNCEMENT"
assert_contains "sextant.subscribe.tack true: still reports" "$context" "source changed"
git -C "$repo" config --unset sextant.subscribe.tack

# --- no spec ---

repo=$(new_repo)
git -C "$repo" checkout -q -b feature
printf 'code\n' >"$repo/app.sh"
commit_all "$repo"
run_hook "$repo" "$ANNOUNCEMENT"
assert_empty "a repo with no spec: silent" "$context"
assert_eq "a repo with no spec: exits 0" "$code" 0
assert_eq "a repo with no spec: writes nothing" "$dirty" no

outside=$(mktemp -d "$SCRATCH/plain.XXXXXX")
out=$(jq -cn --arg cwd "$outside" --arg out "$ANNOUNCEMENT" '{cwd: $cwd, tool_response: {stdout: $out}}' | bash "$HOOK")
assert_eq "outside a git repo: exits 0" "$?" 0
assert_empty "outside a git repo: silent" "$out"

finish
