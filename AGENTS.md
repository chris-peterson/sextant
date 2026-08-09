# sextant

A Claude Code plugin for AI-assisted, best-effort spec-driven development: it
writes requirements first, reconciles them with the code in either direction, and
graduates the winning candidate from an exploration tree to the sole
implementation at the repo root. What each skill does for a *user* lives on the
docs site (https://chris-peterson.github.io/sextant); this file is for working on
the plugin itself.

**The implementation is the skill prompts.** There is no runtime code here —
`skills/*/SKILL.md` and the shared procedures under `references/` are what
executes. A behavior change is a prompt edit, and it is reviewed as prose: the
question is whether an agent reading it does the right thing, not whether it
parses.

sextant dogfoods itself. Its own `SPEC.md` is the requirement source of record
and `STATUS.md` its coverage ledger, both maintained by its own skills. A change
to behavior updates the requirement and the ledger in the same commit, not as a
follow-up.

## Commands

```bash
just check       # validate source and preview the pending projection (no write)
just generate    # regenerate plugin.json and docs/ from plugin.yml and the skills
just describe    # resync plugin.yml's suite.describe from the skills
just docs        # serve the docsify site locally
```

## Layout

```text
plugin.yml               canonical descriptor — manifest, marketplace entry, docs previews
skills/spec-req/         look up, trace, author requirements; bootstrap a spec (init)
skills/spec-status/      refresh STATUS.md — the lightweight, hook-safe ledger writer
skills/spec-sync/        full-domain coverage + drift analysis; one-way reconciliation
skills/impl-new/         scaffold a candidate under implementations/<version>/<n>-<name>/
skills/impl-select/      graduate the winner to the repo root (one-way)
references/              shared procedures the skills read at runtime
SPEC.md / STATUS.md      sextant's own requirements and their coverage
docs/                    docsify site (index.html, _sidebar.md, hero, favicon are source)
```

`.claude-plugin/plugin.json`, `plugin.yml`'s `suite.describe` block, and most of
`docs/` are **generated** by `shipyard` from the sources above. Never hand-edit a
generated file; edit its source and run `just generate`.

## Conventions

- **A shared procedure lives in `references/` once.** `locate-spec.md`,
  `counting-rule.md`, `ears-patterns.md`, and `evidence-pointer.md` are each the
  single source of truth for their rule. A skill quotes a one-line summary for
  the reader and defers to the reference for the authoritative version — so
  changing a rule is one edit, not five. Adding the rule inline to a skill
  instead is the drift this prevents.
- **Requirements are EARS, and IDs are stable.** `[XX-NN]`, with lettered
  decompositions (`XX-NNa`) counting as one apiece. A retired ID is never reused
  and never counted; it survives as numbering-gap prose.
- **The counting invariant holds or the ledger is wrong.** Header count == sum of
  per-category counts == the spec's normative inventory. Every real STATUS.md
  drift found so far was one of those three disagreeing.
- **`spec-status` writes only `STATUS.md`.** It never edits code and never edits
  `SPEC.md` — that is what makes it safe to run from a hook. `spec-sync` is the
  skill that may touch either, and only as an explicit one-way `--to-spec` /
  `--to-source` pass.
- **Reconciliation never runs both directions at once.** Two-way sync has no
  authority to appeal to when the two disagree; a contradiction is recorded as a
  needs-decision row for the user instead of being resolved.
- **Classify by reading the code, not the prior ledger.** A refresh that trusts
  the last audit records what was true then.
- **Evidence pointers default to file plus enclosing symbol**, so they survive
  edits they aren't about. A ledger may declare a different granularity; it
  declares it in its header rather than varying row by row.

## Glossary

- **SPEC.md** — the contract: the authoritative, ordered list of requirements the
  implementation is measured against.
- **STATUS.md** — the coverage ledger: a machine-refreshable record of how each
  requirement classifies against the current code, carrying human-authored
  rationale and audit history that the writer preserves.
- **Category** — a 2–4 character mnemonic prefix grouping related requirements
  (`LOC`, `REQ`, `AUTH`, …), at its natural length rather than padded.
- **Coverage classification** — Covered, Partial, Missing, or Contradicts.
- **Evidence pointer** — where the code satisfies a requirement, recorded in the
  ledger's `Location`.
- **Locate order** — the shared discovery procedure for finding the active
  SPEC.md; the authoritative version is `references/locate-spec.md`.
- **Drift** — behavior the code exhibits that no requirement captures, or a
  requirement the code no longer satisfies.
- **Candidate** — an exploratory implementation built against the spec to
  stress-test it. An instrumented experiment, not a competitor.
- **Graduation** — the one-way move that selects a winning candidate, retires the
  others, and flattens the winner to the repo root.
