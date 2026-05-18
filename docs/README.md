# <img src="favicon.svg" alt="sextant" width="64" height="64" style="vertical-align: middle"> sextant

AI-assisted SPEC-driven development — write requirements first, audit implementations against them, graduate the winner.

A sextant is the precision nautical instrument used to fix position against external references. Here, the external reference is your `SPEC.md`, and the position is your implementation's coverage of it.

## Interface

| Surface | What it does |
|---|---|
| [`/sextant:spec-req`](/skills/spec-req) | Look up requirements by ID or category, trace them through implementations, or draft new ones in EARS syntax |
| [`/sextant:spec-audit`](/skills/spec-audit) | Audit implementation coverage against `SPEC.md` — forward (spec → code) and reverse (code → spec drift) |
| [`/sextant:impl-new`](/skills/impl-new) | Scaffold a new candidate implementation — gather stack + constraints, read `SPEC.md`, propose a plan, and on sign-off create `implementations/<v>/<slug>/` with a justfile stub and seeded `STATUS.md` |
| [`/sextant:impl-select`](/skills/impl-select) | Select the winning candidate from `implementations/<version>/<n>-<name>/` and flatten it to **the** implementation at the repo root |

## Quickstart

1. **Install the plugin.**

   ```text
   /plugin install sextant
   ```

2. **Write or locate a `SPEC.md`** in your project. Sextant looks in `spec/<version>/`, a justfile `spec` variable, `CURRENT_SPEC_VERSION`, and the repo root.

3. **Audit your implementation.**

   ```text
   /sextant:spec-audit
   ```

   Produces a forward/reverse coverage report against the spec.

4. **Iterate.** As you discover new requirements during implementation, capture them with `/sextant:spec-req new`. When one implementation has clearly won out of the exploration tree, run `/sextant:impl-select` to flatten the repo.

## Why spec-driven

Spec-driven development inverts the usual order: you write requirements in [EARS syntax](https://alistairmavin.com/ears) first, then build candidate implementations against them, then promote the one that wins. The spec is the contract; the implementations are instrumented experiments that surface gaps and ambiguities in the contract.

Sextant gives you the operations that loop benefits from:

- **Trace** — `spec-req` connects requirement IDs to the code that satisfies them.
- **Audit** — `spec-audit` measures coverage and flags spec drift.
- **Scaffold** — `impl-new` frames a candidate against the spec with intentional stack and constraint choices.
- **Select** — `impl-select` ends the exploration phase cleanly by graduating the winner.

## Reference

- **Skills** — see the sidebar for per-skill pages (sourced directly from each skill's `SKILL.md`)
- **EARS syntax** — https://alistairmavin.com/ears
