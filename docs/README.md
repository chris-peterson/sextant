<div class="ph-hero" style="--accent: color-mix(in srgb, var(--color-green) 54%, light-dark(black, white))">

<h1 class="ph-lede"><span class="ph-name">sextant:</span> manages drift between spec and code.</h1>

<div class="ph-badge"><img class="ph-mark" src="favicon.svg" alt="sextant" width="26" height="26">

[](_tags.md ':include')

</div>

</div>

A sextant is the precision nautical instrument for fixing your position against fixed references. It doesn't plot the voyage in advance, it tells you where you are right now. Here the reference is your `SPEC.md` and the position is your code's coverage of it: take a fix whenever you need to know how far you've drifted from course.

## In action

You shipped a change and want to know whether the code still matches the contract. `/sextant:spec-sync` takes the fix: coverage in both directions, and any drift between what the spec says and what the code does:

<div class="cw-session" data-cw-session="session"></div>

## Interface

| Surface | What it does |
|---|---|
| [`/sextant:spec-req`](/skills/spec-req) | Look up requirements by ID or category, trace them through the code, draft new ones in EARS syntax, or bootstrap a fresh `SPEC.md` (`spec-req init`) |
| [`/sextant:spec-status`](/skills/spec-status) | Refresh `STATUS.md` to match current coverage; the lightweight, automatable ledger writer (`/ship-it`- and hook-friendly) |
| [`/sextant:spec-sync`](/skills/spec-sync) | Full-domain analysis of `SPEC.md` against the code (coverage, bidirectional drift, requirement quality) and one-way reconciliation (`--to-spec` / `--to-source`) |

The skills you reach for most, reconciling code against the spec and giving a new requirement a stable identity, in motion:

<div class="cw-session" data-cw-session="examples"></div>

## Quickstart

1. **Install the plugin.**

   ```bash
   claude plugin marketplace add chris-peterson/claude-marketplace
   claude plugin install sextant@chris-peterson
   ```

2. **Write or locate a `SPEC.md`** in your project, or scaffold one from scratch with `/sextant:spec-req init`. Sextant looks for a `STATUS.md` pointer first, then `spec/<version>/`, a justfile `spec` variable, and the repo root.

3. **Analyze your implementation against the spec.**

   ```text
   /sextant:spec-sync
   ```

   Produces a full-domain coverage and drift report, and refreshes `STATUS.md`.

4. **Iterate.** As you discover new requirements during implementation, capture them with `/sextant:spec-req new`, and keep the ledger current with `/sextant:spec-status`.

## Why "best-effort"

Heavyweight, dogmatic spec-first tools age like milk: great at the demo, stale soon after. The spec is treated as a gate (complete and correct before any code, generated once, then frozen) and nothing in the workflow keeps it true once the code moves on, so it decays into documentation that no longer matches the code.

Sextant treats the spec as a living reference rather than a gate:

- **Partial coverage is a state, not a failure.** `spec-status` and `spec-sync` measure the gap between spec and code instead of demanding you close it before proceeding.
- **Drift is surfaced, not forbidden.** `spec-sync` flags divergence in both directions (requirements with no code, code with no requirement) so the spec earns its keep by staying honest.
- **Requirements have identity.** Requirements are written in [EARS syntax](https://alistairmavin.com/ears) with stable IDs you can trace to the code that satisfies them.

If you want to go from an idea to a first implementation, a forward, spec-first tool like [spec-kit](https://github.com/github/spec-kit) is built for that. Sextant is for the other side of the loop: keeping a spec and a codebase reconciled over time. See [Why Sextant?](/comparison) for where sextant sits among SDD tools.

## Reference

- **Skills**: see the sidebar for per-skill pages (sourced directly from each skill's `SKILL.md`)
- **EARS syntax**: https://alistairmavin.com/ears
- **[Sextant²](/meta)**: sextant's own spec, rendered live (dogfooding)
