# Changelog

## 0.6.0

Coverage evidence stops rotting on unrelated commits, and the two lightweight skills become model-invocable.

### Changed

- **`STATUS.md` records evidence as a pointer that survives unrelated edits.** A Covered requirement's `Location` held `file:line`, and a line number changes when anything above it changes — so following a stale `src/git.ts:62-73` lands you in unrelated code. It also eroded the idempotency `/sextant:spec-status` claims: a refresh after any commit found every shifted row wrong and rewrote it, reporting churn no coverage change caused. The refresh now records the file plus its enclosing symbol, or a requirement-ID anchor where the code names one at the site.

  Granularity is your project's call. `references/evidence-pointer.md` documents the spectrum (line range → symbol → anchor → file → directory) and what each trades; declare your choice with an `**Evidence pointers:**` line in `STATUS.md` and the refresh preserves it instead of converting it back. **The first refresh of an existing ledger rewrites every `Location` at once** — that is reported as a format change, not as drift.

- **`/sextant:spec-req` and `/sextant:spec-status` can be invoked by Claude again.** 0.3.2 marked both `disable-model-invocation` to cut always-resident context; they are lightweight enough to be worth the cost, so Claude can reach for them without you typing the command. `spec-sync`, `impl-new`, and `impl-select` stay slash-only.

### Spec

- **`COV-09`** — evidence is recorded at the granularity the ledger declares, defaulting to file plus enclosing symbol.
- **`COV-05`** reworded: idempotency covers commits that change no coverage, not only consecutive runs. That is the boundary it was always meant to claim.

### Other

- The docs site's `index.html` is projected from `plugin.yml` via shipyard rather than committed, so the shared docsify template applies without a hand-copied file drifting from it.
- CI runs shipyard's preview gate, which validates that the source projects cleanly and previews the pending projection. The old check gate failed on any drift between committed artifacts and their source — but that projection happens at release, so between releases the lag is expected. The pre-commit hook that papered over it, and its `just install-hooks` recipe, are gone. `just build` is now `just generate`; `just check` runs `generate --dry-run`.
- shipyard's reusable workflows and the `scripts/shipyard` wrapper are pinned to its `v1` branch.
- `SECURITY.md` added, and every workflow declares its `permissions`.

## 0.5.0

Build-tooling and docs consolidation, plus a requirement-ID convention refinement.

### Changed

- **Build tooling moved to shipyard.** Generators, the CI check gate, and the release workflow now delegate to shipyard's reusable tooling — `plugin.json`, the suite `describe`, and the docs site are projected from canonical sources and verified in CI.
- **Requirement-ID convention.** Category prefixes are documented as a natural length (2–4 chars) — the full word when the category name is short, a short abbreviation otherwise — rather than a fixed width, since these codes are read far more often than they're typed.

### Docs

- SPEC surfaced at a stable `/spec` route on the docs site.
- Docs render data renamed `suite.json` → `plugin-docs.json`.
- The `impl-select` smoke-test example uses a generic CLI name.

## 0.4.0

A best-practices pass over the plugin — correctness fixes to the skill
workflow, anti-drift refactors, and packaging.

### Fixed

- **impl-new ⇄ spec-status handoff.** `impl-new` seeded a per-candidate `STATUS.md` whose shape `spec-status` couldn't refresh in place (it would no-op the fields it couldn't find or clobber the candidate metadata). `spec-status` now recognizes the per-implementation shape as a first-class variant, and `impl-new` seeds machine-derived anchors so a later ledger refresh reads it cleanly.
- **impl-new spec-locate order.** It had drifted from the other three skills, dropping the `STATUS.md` spec-pointer step and the `docs/spec.md` fallback — so it could fail to find specs the others locate. Reconciled.
- **Dogfooding drift.** The plugin's own `STATUS.md` had fallen a version behind because `release.yml` never refreshed it. The release workflow now bumps its version line.

### Changed

- **Single-sourced shared procedures.** The locate order, counting rule, and EARS patterns — previously copy-pasted across skills — now live under `references/` and are linked from each skill, so they can't drift again. The docs build copies them and rewrites the links to resolve on the site.
- **Unified coverage vocabulary** on Covered/Partial/Missing/Contradicts across all skills (SPEC `IMPL-03`/`IMPL-04` reworded to match; behavior unchanged).
- **Manifest attribution.** `author` and `repository` now reach `plugin.json`.

### Other

- Polish: added/relaxed `argument-hint`s, fixed `impl-select`'s diagram/prose mismatches, softened dangling `/recipe` and `/ship-it` references for standalone installs, and corrected a stale CI step name.

## 0.3.2

### Other
- The spec-workflow skills (`impl-new`, `impl-select`, `spec-req`, `spec-status`, `spec-sync`) are now marked `disable-model-invocation`, dropping their descriptions from every session's always-resident context. Still available via `/`; Claude no longer auto-loads them.

## 0.3.1

### Other
- spec-sync's description now frames the skill around reconciliation — full-domain coverage plus drift analysis applied as one-way syncs — with suite metadata aligned to match.
- Trimmed the `description` frontmatter across the spec-workflow skills (`impl-new`, `impl-select`, `spec-req`, `spec-status`, `spec-sync`) to cut the always-resident context cost. These are `/`-invoked, so the trigger-phrase enumerations are dropped in favor of one what/when sentence each.

## 0.3.0

First official release of sextant on the chris-peterson marketplace. This release packages the plugin for distribution and documents it — including against its own spec.

### Packaging

- `plugin.yml` is now the canonical descriptor. It projects into `.claude-plugin/plugin.json` and the marketplace SPA, and presents sextant as a spoke whose marketplace drill-in hands off to the live docs site.

### Docs

- **Sextant²** — sextant's own behavior is written as a `SPEC.md` and tracked in a `STATUS.md` coverage ledger, both rendered live on the docs site. The plugin dogfoods its own `/sextant:` commands.
- **Why Sextant?** — a new page placing sextant among spec-driven-development tools (Kiro, Spec-kit, Tessl) on Böckeler's spec-first / spec-anchored / spec-as-source spectrum. Sextant runs the loop backward: it audits how far code has drifted from the spec rather than generating code from it.
- Docs reframed around "best-effort" spec-driven development, with hero art.

## 0.2.0

### Breaking Changes

- `/sextant:spec-audit` is retired. Its read-only coverage + drift analysis is
  now the default mode of the new `/sextant:spec-sync` — switch any
  `spec-audit` invocation to `spec-sync`. (Pre-1.0, shipped as a minor.)

### Features

- `/sextant:spec-status` — refreshes `STATUS.md` to match current coverage.
  Lightweight, idempotent, and no-op-gated (silently skips non-spec repos), so
  it's safe to wire into hooks and `/ship-it`.
- `/sextant:spec-sync` — full-domain analysis of `SPEC.md` against the code
  (coverage, bidirectional drift, requirement quality), plus one-way
  reconciliation: `--to-spec` drafts requirements from undocumented behavior,
  `--to-source` surfaces the implementation gap list for a dev session.
- `/sextant:spec-req init` — bootstrap a fresh `SPEC.md` + `STATUS.md` stub
  conversationally, replacing the need for a separate bootstrap skill.
  `init from <doc>` takes a PRD, design doc, or README (path or URL) as a
  requirements source and extracts its requirements into `SPEC.md` as EARS
  statements, rather than scaffolding an empty skeleton.

### Other

- `impl-new`, `impl-select`, and the docs/indexes repointed from `spec-audit`
  to `spec-sync` / `spec-status`.
