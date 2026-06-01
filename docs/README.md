# <img src="favicon.svg" alt="sextant" width="64" height="64" style="vertical-align: middle"> sextant

AI-assisted SPEC-driven development — write requirements first, audit implementations against them, graduate the winner.

A sextant is the precision nautical instrument used to fix position against external references. Here, the external reference is your `SPEC.md`, and the position is your implementation's coverage of it.

## Interface

| Surface | What it does |
|---|---|
| [`/sextant:spec-req`](/skills/spec-req) | Look up requirements by ID or category, trace them through implementations, draft new ones in EARS syntax, or bootstrap a fresh `SPEC.md` (`spec-req init`) |
| [`/sextant:spec-status`](/skills/spec-status) | Refresh `STATUS.md` to match current coverage — the lightweight, automatable ledger writer (`/ship-it`- and hook-friendly) |
| [`/sextant:spec-sync`](/skills/spec-sync) | Full-domain analysis of `SPEC.md` against the code — coverage, bidirectional drift, requirement quality — and one-way reconciliation (`--to-spec` / `--to-source`) |
| [`/sextant:impl-new`](/skills/impl-new) | Scaffold a new candidate implementation — gather stack + constraints, read `SPEC.md`, propose a plan, and on sign-off create `implementations/<v>/<slug>/` with a justfile stub and seeded `STATUS.md` |
| [`/sextant:impl-select`](/skills/impl-select) | Select the winning candidate from `implementations/<version>/<n>-<name>/` and flatten it to **the** implementation at the repo root |

## Quickstart

1. **Install the plugin.**

   ```text
   /plugin install sextant
   ```

2. **Write or locate a `SPEC.md`** in your project — or scaffold one from scratch with `/sextant:spec-req init`. Sextant looks in `spec/<version>/`, a justfile `spec` variable, `CURRENT_SPEC_VERSION`, and the repo root.

3. **Analyze your implementation against the spec.**

   ```text
   /sextant:spec-sync
   ```

   Produces a full-domain coverage and drift report, and refreshes `STATUS.md`.

4. **Iterate.** As you discover new requirements during implementation, capture them with `/sextant:spec-req new`. When one implementation has clearly won out of the exploration tree, run `/sextant:impl-select` to flatten the repo.

## Why spec-driven

Spec-driven development inverts the usual order: you write requirements in [EARS syntax](https://alistairmavin.com/ears) first, then build candidate implementations against them, then promote the one that wins. The spec is the contract; the implementations are instrumented experiments that surface gaps and ambiguities in the contract.

Sextant gives you the operations that loop benefits from:

- **Author** — `spec-req` bootstraps a new spec (`init`), then connects requirement IDs to the code that satisfies them as you trace and add more.
- **Reconcile** — `spec-sync` measures coverage and flags drift in both directions, then applies one-way syncs on request.
- **Track** — `spec-status` keeps `STATUS.md` current; small enough to wire into `/ship-it` and hooks.
- **Scaffold** — `impl-new` frames a candidate against the spec with intentional stack and constraint choices.
- **Select** — `impl-select` ends the exploration phase cleanly by graduating the winner.

## Reference

- **Skills** — see the sidebar for per-skill pages (sourced directly from each skill's `SKILL.md`)
- **EARS syntax** — https://alistairmavin.com/ears
