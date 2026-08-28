# sextant

A Claude Code plugin for AI-assisted, best-effort spec-driven development: it
keeps a plain-language spec under source control, tracks how the code covers it,
and reconciles the two in either direction. What each skill does for a *user*
lives on the docs site (https://chris-peterson.github.io/sextant); this file is
for working on the plugin itself.

**The implementation is the skill prompts.** There is no runtime code here —
`skills/*/SKILL.md` and the shared procedures under `references/` are what
executes. A behavior change is a prompt edit, and it is reviewed as prose: the
question is whether an agent reading it does the right thing, not whether it
parses.

sextant dogfoods itself. Its own `SPEC.md` is the requirement source of record
and `STATUS.md` its coverage ledger, both maintained by its own skills. A change
to behavior updates the requirement and the ledger in the same commit, not as a
follow-up.

## Scope

**Pragmatic, not dogmatic.** Requirements lead the code sometimes and lag it
often, and a spec is a living document: entries are added, reworded, and dropped
in place. sextant is built for that, which means it reads a spec it did not
author and reconciles one it did not keep current. A requirement backfilled
after the behavior shipped is a first-class entry, not a repair.

What it deliberately does **not** do, so no skill implies otherwise:

- **Version a spec.** Git already holds every prior state, which is the archive a
  second spec directory would duplicate. `spec/<version>/` is honored as a layout
  a project may already use, not a workflow to advance; the locate order reads it
  and stops there.
- **Rename a category.** Renaming a prefix renumbers every requirement under it,
  across SPEC.md, STATUS.md, and inbound references. That is a manual sweep today,
  tracked in [#12](https://github.com/chris-peterson/sextant/issues/12).
- **Carry a deferred tier.** There is no `FUT-NN`, no Future Requirements
  section. A spec holds what the code is measured against, so an entry nobody is
  building against reads as a coverage gap forever. Ideas that may or may not
  happen go in the issue tracker.

## Commands

```bash
just generate         # regenerate plugin.json and docs/ from plugin.yml and the skills
just peek-projection  # generate, then show what it wrote
just describe         # resync plugin.yml's suite.describe from the skills
just docs             # render the docsify site and serve it locally
```

The recipes run shipyard straight from its git ref via `uvx`, so there is
nothing to install. They are for seeing the projection before you push; CI is
the writer for what lands.

## Layout

```text
plugin.yml               canonical descriptor — manifest, marketplace entry, docs previews
skills/spec-req/         look up, trace, author requirements; bootstrap a spec (init)
skills/spec-status/      refresh STATUS.md — the lightweight, hook-safe ledger writer
skills/spec-sync/        full-domain coverage + drift analysis; one-way reconciliation
references/              shared procedures the skills read at runtime
SPEC.md / STATUS.md      sextant's own requirements and their coverage
docs/                    docsify site — the tracked pages, sidebar, hero, and favicon are source
```

`.claude-plugin/plugin.json`, `plugin.yml`'s `suite.describe` block, and most of
`docs/` are **generated** by `shipyard` from the sources above. Never hand-edit a
generated file; edit its source and run `just generate`.

## Conventions

- **A shared procedure lives in `references/` once.** `locate-spec.md`,
  `counting-rule.md`, `ears-patterns.md`, `evidence-pointer.md`,
  `category-prefix.md`, and `spec-layout.md` are each the single source of truth
  for their rule. A skill quotes a one-line summary for
  the reader and defers to the reference for the authoritative version — so
  changing a rule is one edit, not five. Adding the rule inline to a skill
  instead is the drift this prevents.
- **Requirements are EARS, and IDs are stable.** `XX-NN`, with lettered
  decompositions (`XX-NNa`) counting as one apiece. A retired ID is never reused
  and never counted; it survives as numbering-gap prose. Stable means an ID is
  not recycled onto different behavior — renaming a whole category is a separate
  operation, and a manual one (see Scope).
- **A requirement is a heading; nothing else is.** The backticked ID heads its own
  section one level below its category's backticked-prefix heading, so
  `SPEC.md#locate-01` links to it and the normative inventory is mechanical to read
  off. The read side accepts a bare-ID heading too, so a spec written before the
  backticks still parses. `references/spec-layout.md` is the authoritative form.
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
- **Category** — a prefix grouping related requirements (`LOCATE`, `LOOKUP`,
  `AUTHORING`, …): more than one character, all caps, one word — the name people
  say for the thing, whether that's the word or an established initialism (`UX`,
  `CLI`). The authoritative form is `references/category-prefix.md`.
- **Coverage classification** — Covered, Partial, Missing, or Contradicts.
- **Evidence pointer** — where the code satisfies a requirement, recorded in the
  ledger's `Location`.
- **Locate order** — the shared discovery procedure for finding the active
  SPEC.md; the authoritative version is `references/locate-spec.md`.
- **Drift** — behavior the code exhibits that no requirement captures, or a
  requirement the code no longer satisfies.
