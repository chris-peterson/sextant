#!/usr/bin/env bash
# PostToolUse(Bash) subscriber: when tack announces that a session's work closed
# out, say whether the source or the spec moved while the coverage ledger didn't,
# and which skill addresses it. It raises the question and writes nothing:
# whether a change is spec-impacting is a judgment for the agent, not the hook.
#
# The announcement format and the subscriber rules are the suite's contract:
# https://github.com/chris-peterson/claude-marketplace/blob/main/authoring/plugin-contract.md
#
# Every path exits 0, because PostToolUse on Bash runs on every Bash call in
# every session where sextant is enabled.

set -uo pipefail
trap 'exit 0' EXIT

KEY=codes.bridgeai.tack/session.ended
OPT_OUT_KEYS="sextant.subscribe.tack sextant.subscribe.tack.session-ended"
plugin_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

opted_out() {
  local key value
  for key in $OPT_OUT_KEYS; do
    value=$(git config --type=bool --get "$key" 2>/dev/null) && [ "$value" = false ] && return 0
  done
  return 1
}

emit() {
  jq -cn --arg context "$1" \
    '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $context}}'
}

main() {
  local input output line route cwd top located spec ledger base_ref base changed path
  local source_moved=0 spec_moved=0 ledger_moved=0

  input=$(cat)
  output=$(printf '%s' "$input" | jq -r '.tool_response.stdout // empty' 2>/dev/null) || return 0
  # A here-string, not a pipe: grep -m1 stops reading at the first match, and
  # under pipefail the writer's SIGPIPE on a large stdout would fail the match.
  line=$(grep -m1 -E '^codes\.bridgeai\.tack/session\.ended[[:space:]]' <<<"$output") || return 0
  route=$(printf '%s' "${line#"$KEY"}" | jq -er \
    'if type == "object" then (.route // "" | tostring | gsub("[[:cntrl:]]"; "")) else error("body is not an object") end' \
    2>/dev/null) || return 0

  cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
  if [ -n "$cwd" ]; then cd "$cwd" 2>/dev/null || return 0; fi
  top=$(git rev-parse --show-toplevel 2>/dev/null) || return 0
  cd "$top" || return 0
  opted_out && return 0

  located=$(bash "$plugin_root/scripts/locate-spec.sh" "$top") || return 0
  spec=$(printf '%s\n' "$located" | sed -n 's/^SPEC=//p')
  ledger=$(printf '%s\n' "$located" | sed -n 's/^STATUS=//p')
  [ -n "$ledger" ] || ledger=STATUS.md

  # The session's changes: everything since the branch left the default branch,
  # committed or not. On the default branch itself that is the working tree.
  base_ref=$(git symbolic-ref -q --short refs/remotes/origin/HEAD) || return 0
  base=$(git merge-base HEAD "$base_ref" 2>/dev/null) || return 0
  changed=$({
    git diff --no-renames --name-only "$base" --
    git ls-files --others --exclude-standard
  } 2>/dev/null | sort -u)

  while IFS= read -r path; do
    case "$path" in
      '') ;;
      "$spec") spec_moved=1 ;;
      "$ledger") ledger_moved=1 ;;
      *) source_moved=1 ;;
    esac
  done <<EOF
$changed
EOF

  [ "$ledger_moved" -eq 1 ] && return 0

  local state reading skill
  if [ "$source_moved" -eq 1 ] && [ "$spec_moved" -eq 0 ]; then
    state="source changed, $spec unchanged, $ledger unchanged"
    reading="The code may have moved past the spec."
    skill="/sextant:spec-sync (its reverse pass finds behavior no requirement captures)"
  elif [ "$source_moved" -eq 0 ] && [ "$spec_moved" -eq 1 ]; then
    state="$spec changed, source unchanged, $ledger unchanged"
    reading="The requirements moved ahead of the code."
    skill="/sextant:spec-status (classifies the new and changed requirements)"
  elif [ "$source_moved" -eq 1 ] && [ "$spec_moved" -eq 1 ]; then
    state="source changed, $spec changed, $ledger unchanged"
    reading="Both moved, so the ledger is stale either way."
    skill="/sextant:spec-status (reclassifies every requirement against the code)"
  else
    return 0
  fi

  local closed="tack closed out this session's work"
  [ -n "$route" ] && closed="tack closed out route \"$route\""

  emit "sextant: $closed. Since $base_ref (${base:0:7}): $state. $reading

Whether the change is spec-impacting is a judgment this hook can't make: a rename or an extracted helper isn't, a new flag or a changed default is. If it is, run $skill. The hook wrote nothing.

To turn this off: git config --global sextant.subscribe.tack.session-ended false"
}

main
exit 0
