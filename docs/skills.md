# Skills

A skill is a Claude Code surface that gathers context conversationally. Invoke one by typing its slash command — `/sextant:<name>` — with or without arguments.

| Skill | Use when… |
|---|---|
| [`/sextant:spec-req`](/skills/spec-req) | You need to look up a requirement by ID or category, trace it through the code, draft a new one — or bootstrap a brand-new `SPEC.md` from scratch (`spec-req init`). |
| [`/sextant:spec-status`](/skills/spec-status) | STATUS.md has drifted from the code and you want it regenerated. The lightweight ledger writer: runs the coverage pass, then rewrites STATUS.md's numbers, category table, and version in place while preserving your prose. No-ops silently on non-spec repos, so `/ship-it` can call it on every release. |
| [`/sextant:spec-sync`](/skills/spec-sync) | You want the full picture of how `SPEC.md` and the code relate, or to reconcile them. Every run analyzes the whole domain — coverage, bidirectional drift, requirement quality. `--to-spec` drafts requirements from undocumented code (via `spec-req`); `--to-source` surfaces the implementation gap list for a dev session. Never auto-writes code, never canonizes code into the spec without confirmation. |

Each per-skill page is generated from that skill's `SKILL.md` at build time — the operational instructions Claude follows when you invoke it. No parallel docs to maintain; what you see on the page is what Claude reads.
