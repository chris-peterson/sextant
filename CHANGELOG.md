# Changelog

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
