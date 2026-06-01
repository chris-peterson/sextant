# Changelog

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

### Other

- `impl-new`, `impl-select`, and the docs/indexes repointed from `spec-audit`
  to `spec-sync` / `spec-status`.
