# Skills

A skill is a Claude Code surface that gathers context conversationally. Invoke one by typing its slash command — `/sextant:<name>` — with or without arguments.

| Skill | Use when… |
|---|---|
| [`/sextant:spec-req`](/skills/spec-req) | You need to look up a requirement by ID or category, trace it through implementations, or draft a new one. |
| [`/sextant:spec-audit`](/skills/spec-audit) | You want a coverage report of your implementation against `SPEC.md`. Catches gaps in both directions: spec → code (missing implementation) and code → spec (undocumented drift). |
| [`/sextant:impl-new`](/skills/impl-new) | You're starting a new candidate implementation against the spec and want stack + constraints made explicit before scaffolding, so the candidate is an instrumented experiment rather than a convention-default skeleton. |
| [`/sextant:impl-select`](/skills/impl-select) | One implementation in the `implementations/` exploration tree has clearly won, and you want to select it and flatten it to the repo root. One-way move. |

Each per-skill page is generated from that skill's `SKILL.md` at build time — the operational instructions Claude follows when you invoke it. No parallel docs to maintain; what you see on the page is what Claude reads.
