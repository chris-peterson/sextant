# Why Sextant?

In [_Spec-driven development: 3 tools_](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html) on martinfowler.com, Birgitta Böckeler surveys the spec-driven development (SDD) landscape and frames it along three levels:

- **Spec-first** — a well-designed spec is written before AI-assisted development, then often discarded once the task is done.
- **Spec-anchored** — the spec persists and is maintained as the code evolves.
- **Spec-as-source** — the spec is the only artifact humans edit; code is generated from it and never touched directly.

The three tools it examines — **Kiro**, GitHub's **Spec-kit**, and **Tessl** — all run the spec *forward*, from requirements toward an implementation. They differ in how far that goes: Kiro and Spec-kit generate planning artifacts (requirements, design, tasks) that a developer or coding agent then implements, while Tessl generates the application code itself from the spec. The article's stated concerns are the review burden of verbose markdown, the "control illusion" of elaborate spec structures, and spec-as-source repeating Model-Driven Development's overhead.

## Sextant runs the loop in the other direction

All three run forward — from spec toward implementation. Sextant answers the opposite question: *"how well does the code I already have cover the spec, and where have the two drifted?"* It's an audit and reconciliation instrument, not a generator — the name is literal: take a position fix against a fixed reference, rather than plot the voyage in advance.

That places sextant at **spec-anchored**, and deliberately not spec-as-source. It never generates code from the spec or marks code as off-limits; the implementation is the thing being *measured*. Reconciling toward the code (`spec-sync --to-source`) hands a gap list to a development session rather than writing code itself.

## Comparison matrix

Dimensions follow the article's own comparison axes. Rows for Kiro, Spec-kit, and Tessl describe them as characterized in that article.

| | Kiro | Spec-kit | Tessl | **sextant** |
|---|---|---|---|---|
| SDD level | spec-first | spec-first → anchored | spec-anchored → spec-as-source | **spec-anchored** |
| Direction | spec → plan → code | spec → plan → code | spec → code (generated) | **code → spec audit** |
| Primary question | scaffold the work | scaffold the work | the code *is* the spec | **how far has code drifted?** |
| Spec format | user stories + GIVEN/WHEN/THEN | constitution + file fan-out | tagged 1:1 spec files | **EARS, stable `[XX-NN]` IDs** |
| Partial coverage | gate to pass | gate to pass | regenerate to close | **first-class state** |
| Drift handling | — | — | regenerate code | **surfaced both directions** |
| Generates code? | no — generates plans | no — generates plans | yes (owns it) | **no — measures it** |
| Multiple implementations | single tree | single tree | single tree | **candidate bake-off** |
| Distribution | VS Code fork | CLI + slash commands | CLI + MCP server | **Claude Code plugin** |

## What sextant does that the forward tools don't

- **Partial coverage is a state, not a failed gate.** This is a direct answer to the article's *Verschlimmbesserung* concern. A spec generated once and frozen decays as the code moves on; sextant assumes that and measures the gap — Covered, Partial, Missing, or Contradicts — instead of demanding you close it before proceeding.
- **Bidirectional drift.** Code with no requirement *and* requirements with no code are both surfaced. The forward tools are one-way by construction; reconstructing the spec from code is at most a bootstrap step.
- **Implementation bake-off.** `impl-new` scaffolds several candidates against one spec; `impl-select` graduates the winner and flattens the tree. The surveyed tools assume a single implementation.

## When to reach for which

Reach for a forward, spec-first tool like [Spec-kit](https://github.com/github/spec-kit) to get from an idea to a first implementation. Reach for sextant once code exists and you need to keep it and the spec reconciled over time — and to bake off candidate implementations against one spec.
