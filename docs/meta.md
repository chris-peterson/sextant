# Sextant²

Sextant is built spec-first — and that includes sextant itself. The plugin's own behavior is written down as a [`SPEC.md`](/SPEC) and tracked against the five skills that implement it in a [`STATUS.md`](/STATUS) coverage ledger, using the same `/sextant:` commands you'd run on your own project. Both files are rendered live on this site.

## Why this page exists

It's a worked example on a real codebase, not a toy. When you're deciding how granular a requirement should be, reaching for the right EARS pattern, or wondering what a healthy `STATUS.md` looks like, read these two pages end to end — they're the contract this plugin is actually held to.

It also keeps sextant honest. If the skills change but the spec doesn't, the next `/sextant:spec-sync` surfaces the drift here, in public, the same way it would on any project that adopts the plugin.

## How it was built — the same loop you get

1. **[`/sextant:spec-req init`](/skills/spec-req)** scaffolded an empty `SPEC.md` and `STATUS.md` — an EARS preamble, a Concepts section, and empty category sections.
2. **[`/sextant:spec-sync --to-spec`](/skills/spec-sync)** read the five skills as the source and drafted an EARS requirement for each documented behavior, presenting them for confirmation before writing — capturing existing behavior into the contract rather than inventing it.
3. **[`/sextant:spec-status`](/skills/spec-status)** keeps the ledger honest as the skills evolve, classifying each requirement against the current skill prompts.

The implementation here is unusual — it's the five skill prompts under `skills/`, not application code — but the loop is identical: write requirements, measure coverage, reconcile drift.

## The artifacts

- **[SPEC.md](/SPEC)** — the contract: sextant's behavior as EARS requirements, grouped into behavior-oriented categories (discovery, lookup, authoring, ledger, reconciliation, implementation lifecycle).
- **[STATUS.md](/STATUS)** — the coverage ledger: how each requirement classifies against the skills that implement it.
