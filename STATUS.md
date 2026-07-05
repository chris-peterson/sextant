# sextant — Spec Coverage Status

Tracking status of the requirements declared in [`SPEC.md`](SPEC.md).
Maintained by `/sextant:spec-status`.

**Last audit:** 2026-07-05
**Spec version:** root SPEC.md (unversioned)
**Plugin version:** 0.4.0
**Coverage:** 45 Covered, 0 Partial, 0 Missing/Contradicts

The implementation is the five skill prompts under `skills/`. These requirements
were extracted from their documented behavior via `/sextant:spec-sync --to-spec`,
so each is Covered by the skill it was derived from.

## Status by category

| Prefix | Count | Status | Notes |
|--------|------:|--------|-------|
| LOC-01..05 | 5 | All Covered | Shared locate order + no-op gates — `skills/{spec-req,spec-sync,spec-status,impl-new}/SKILL.md` |
| REQ-01..06 | 6 | All Covered | Lookup/category/trace modes — `skills/spec-req/SKILL.md` |
| AUTH-01..09 | 9 | All Covered | Authoring + init (incl. `init from <doc>` extraction, AUTH-08) — `skills/spec-req/SKILL.md` |
| COV-01..08 | 8 | All Covered | Ledger refresh, idempotency, counting invariant — `skills/spec-status/SKILL.md` |
| REC-01..08 | 8 | All Covered | Full-domain analysis, one-way sync — `skills/spec-sync/SKILL.md` |
| IMPL-01..09 | 9 | All Covered | Scaffold + graduation — `skills/{impl-new,impl-select}/SKILL.md` |

## Audit history

### 2026-07-05 — Coverage refresh + vocabulary reconcile

Plugin version 0.3.0 → 0.3.2 (was stale — the `**Plugin version:**` line is now
bumped by the release workflow so it can't drift again). Coverage unchanged: all
45 requirements remain Covered. IMPL-04 reworded from "marked unmet" to "marked
Missing" as part of unifying the status vocabulary across the skills, and
IMPL-03's candidate-name placeholder normalized to `<n>-<name>`; both are
wording-only — the behavior is unchanged, so the rows stay Covered.

## How to use this file

When you implement a new requirement, change the row's status and add an
evidence pointer. When an audit reveals drift, update the row to **Partial**
or **Contradicts** with a one-line note.
