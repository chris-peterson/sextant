<style>
.hero{position:relative;aspect-ratio:1200/520;border-radius:14px;overflow:hidden;margin:0 0 2rem;background:#15161e url(hero.svg) center/cover no-repeat}
.hero__scrim{position:absolute;inset:0;background:linear-gradient(90deg,rgba(13,14,19,.97) 0%,rgba(13,14,19,.9) 30%,rgba(13,14,19,.4) 52%,rgba(13,14,19,0) 70%),linear-gradient(0deg,rgba(13,14,19,.7),rgba(13,14,19,0) 38%)}
.hero__body{position:absolute;left:0;bottom:0;padding:clamp(1.1rem,3.5vw,2.6rem);max-width:min(560px,74%)}
.hero__title{font-family:Georgia,'Iowan Old Style','Times New Roman',serif;font-weight:600;font-size:clamp(2.2rem,6vw,3.8rem);line-height:.95;margin:0;color:#f8f8f2;text-shadow:0 2px 16px rgba(13,14,19,.95),0 1px 2px rgba(13,14,19,.9)}
.hero__tag{font-size:clamp(1rem,2.4vw,1.4rem);color:#8be9fd;font-weight:600;margin:.55rem 0 .35rem;text-shadow:0 1px 10px rgba(13,14,19,.85)}
.hero__sub{color:#c9ccd8;font-size:clamp(.82rem,1.5vw,1rem);line-height:1.5;margin:0 0 1.05rem}
.hero__cta a{display:inline-block;margin:0 .55rem .4rem 0;padding:.5rem .95rem;border-radius:8px;font-size:.92rem;text-decoration:none;transition:transform .12s ease}
.hero__cta a:hover{transform:translateY(-1px)}
.hero__cta .primary{background:#8be9fd;color:#15161e;font-weight:700}
.hero__cta .ghost{border:1px solid #6272a4;color:#f8f8f2}
</style>

<div class="hero">
  <div class="hero__scrim"></div>
  <div class="hero__body">
    <h1 class="hero__title">sextant</h1>
    <p class="hero__tag">"Best-effort" SPEC-driven development</p>
    <p class="hero__sub">Write requirements first, measure how well the code covers them, and keep the spec honest as both change.</p>
    <p class="hero__cta"><a class="primary" href="#/?id=quickstart">Quickstart</a><a class="ghost" href="https://github.com/chris-peterson/sextant">GitHub</a></p>
  </div>
</div>

A sextant is the precision nautical instrument for fixing your position against fixed references — it doesn't plot the voyage in advance, it tells you where you are right now. Here the reference is your `SPEC.md` and the position is your code's coverage of it: take a fix whenever you need to know how far you've drifted from course.

## In action

You shipped a change and want to know whether the code still matches the contract. `/sextant:spec-sync` takes the fix — coverage in both directions, and any drift between what the spec says and what the code does:

<div class="cw-session" data-cw-session="session"></div>

## Interface

| Surface | What it does |
|---|---|
| [`/sextant:spec-req`](/skills/spec-req) | Look up requirements by ID or category, trace them through implementations, draft new ones in EARS syntax, or bootstrap a fresh `SPEC.md` (`spec-req init`) |
| [`/sextant:spec-status`](/skills/spec-status) | Refresh `STATUS.md` to match current coverage — the lightweight, automatable ledger writer (`/ship-it`- and hook-friendly) |
| [`/sextant:spec-sync`](/skills/spec-sync) | Full-domain analysis of `SPEC.md` against the code — coverage, bidirectional drift, requirement quality — and one-way reconciliation (`--to-spec` / `--to-source`) |
| [`/sextant:impl-new`](/skills/impl-new) | Scaffold a new candidate implementation — gather stack + constraints, read `SPEC.md`, propose a plan, and on sign-off create `implementations/<v>/<slug>/` with a justfile stub and seeded `STATUS.md` |
| [`/sextant:impl-select`](/skills/impl-select) | Select the winning candidate from `implementations/<version>/<n>-<name>/` and flatten it to **the** implementation at the repo root |

The two skills you reach for most — reconciling code against the spec, and giving a new requirement a stable identity — in motion:

<div class="cw-session" data-cw-session="examples"></div>

## Quickstart

1. **Install the plugin.**

   ```bash
   claude plugin marketplace add chris-peterson/claude-marketplace
   claude plugin install sextant@chris-peterson
   ```

2. **Write or locate a `SPEC.md`** in your project — or scaffold one from scratch with `/sextant:spec-req init`. Sextant looks in `spec/<version>/`, a justfile `spec` variable, `CURRENT_SPEC_VERSION`, and the repo root.

3. **Analyze your implementation against the spec.**

   ```text
   /sextant:spec-sync
   ```

   Produces a full-domain coverage and drift report, and refreshes `STATUS.md`.

4. **Iterate.** As you discover new requirements during implementation, capture them with `/sextant:spec-req new`. When one implementation has clearly won out of the exploration tree, run `/sextant:impl-select` to flatten the repo.

## Why "best-effort"

Heavyweight, dogmatic spec-first tools age like milk: great at the demo, stale soon after. The spec is treated as a gate — complete and correct before any code, generated once, then frozen — and nothing in the workflow keeps it true once the code moves on, so it decays into documentation that no longer matches the code.

Sextant treats the spec as a living reference rather than a gate:

- **Partial coverage is a state, not a failure.** `spec-status` and `spec-sync` measure the gap between spec and code instead of demanding you close it before proceeding.
- **Drift is surfaced, not forbidden.** `spec-sync` flags divergence in both directions — requirements with no code, code with no requirement — so the spec earns its keep by staying honest.
- **Requirements have identity.** Requirements are written in [EARS syntax](https://alistairmavin.com/ears) with stable IDs you can trace to the code that satisfies them.
- **Implementations compete.** `impl-new` scaffolds candidates against one spec; `impl-select` graduates the winner.

If you want to go from an idea to a first implementation, a forward, spec-first tool like [spec-kit](https://github.com/github/spec-kit) is built for that. Sextant is for the other side of the loop: keeping a spec and a codebase reconciled over time, and baking off candidate implementations against the spec. See [Why Sextant?](/comparison) for where sextant sits among SDD tools.

## Reference

- **Skills** — see the sidebar for per-skill pages (sourced directly from each skill's `SKILL.md`)
- **EARS syntax** — https://alistairmavin.com/ears
- **[Sextant²](/meta)** — sextant's own spec, rendered live (dogfooding)
