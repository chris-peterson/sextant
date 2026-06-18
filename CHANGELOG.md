# Changelog

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
