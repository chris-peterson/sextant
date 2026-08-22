# sextant — Spec Coverage Status

Tracking status of the requirements declared in [`SPEC.md`](SPEC.md).
Maintained by `/sextant:spec-status`.

**Last audit:** 2026-08-21
**Spec version:** root SPEC.md (unversioned)
**Plugin version:** 0.6.0
**Coverage:** 38 Covered, 0 Partial, 0 Missing/Contradicts
**Evidence pointers:** file

The implementation is the three skill prompts under `skills/`. These requirements
were extracted from their documented behavior via `/sextant:spec-sync --to-spec`,
so each is Covered by the skill it was derived from.

## Status by category

| Prefix | Count | Status | Notes |
|--------|------:|--------|-------|
| LOCATE-01..06 | 6 | All Covered | Shared locate order, no-op gates, requirement-heading extraction (LOCATE-06) — `skills/{spec-req,spec-sync,spec-status}/SKILL.md`, `references/{locate-spec,spec-layout}.md` |
| LOOKUP-01..05 | 5 | All Covered | Lookup/category/trace modes — `skills/spec-req/SKILL.md` |
| AUTHORING-01..12 | 11 | All Covered | Authoring + init (incl. `init from <doc>` extraction, AUTHORING-08; category walkthrough, AUTHORING-10; heading layout, AUTHORING-11..12) — `skills/spec-req/SKILL.md`, `references/{category-prefix,spec-layout}.md`. No AUTHORING-05 — retired with the deferred tier. |
| COVERAGE-01..09 | 9 | All Covered | Ledger refresh, idempotency, counting invariant, evidence pointers — `skills/spec-status/SKILL.md`, `references/evidence-pointer.md` |
| RECONCILE-01..07 | 7 | All Covered | Full-domain analysis, one-way sync — `skills/spec-sync/SKILL.md` |

## Audit history

### 2026-08-22 — Retired requirements struck in place, not deleted

`references/spec-layout.md` gains a Retired requirements section: a
requirement that no longer holds keeps its heading and statement, both struck,
with a dated note on why — never deleted, and the ID never reused. `spec-req`
and `spec-sync --to-spec` each carry a one-line pointer to it.

`LOOKUP-06`, `AUTHORING-05`, and `RECONCILE-08` converted from bare
numbering-gap prose to struck headings carrying their original EARS text,
recovered from the commits that retired them. `IMPL-01..09` stays as prose —
the reference's one exception, for a whole category retired together, where
nine struck headings under a section nobody will read again cost more than
the sentence that replaces them. Coverage stays 38, all Covered: the counting
rule already excluded these IDs either way.

This category table is a per-category rollup, not a per-requirement row, so
there is no row to strike for an individually retired ID — its retirement
already surfaces in the category's Notes column (the AUTHORING row's "No
AUTHORING-05" note, unchanged by this pass). No ledger structure change
follows from this.

### 2026-08-21 — Surface narrowed to what the practice uses

Two features removed and one framing corrected, off the back of auditing the
nine spec-driven repos in this org (`anchor`, `beacon`, `ClaudeWatch`, `cleat`,
`logbook`, `moor`, `sextant`, `shipshape`, `tack`) across 194 spec revisions.

**No spec versioning.** `CURRENT_SPEC_VERSION` leaves the locate order: no repo
has ever set it, and it carried 14 mentions across this codebase and its docs.
The `spec/` directory and justfile `spec` steps stay — `tack` uses them — but as
a layout sextant reads, not a workflow it advances. Zero version bumps exist
across all nine repos in five months; `tack` has sat at `spec/v1/` through 49
revisions of that file. What the history shows instead is in-place rewording on
99 of 173 revisions with an ID delta, which no bump addresses. The archive a
second spec directory would hold is the one git already keeps.

**No deferred tier.** AUTHORING-05 retired and the Future Requirements section
dropped, `FUT-NN` with them. A spec holds what the code is measured against, so
an entry nobody is committed to reads as a coverage gap forever. Of the nine
repos only `cleat` ever carried a single `FUT-` ID, and `tack` deleted its whole
FUT set outright (`7f66c08`). AUTHORING-04 reworded to send a not-now answer to
the project's issue tracker rather than into the spec; LOCATE-05 and COVERAGE-01
lose deferred exclusions that no longer have anything to exclude.

Coverage 39 → 38, all Covered.

Two gaps this audit found and deliberately did not close: category renaming
(seven wholesale prefix renames across the nine repos, up to +149/−149 IDs in a
single commit, every one a hand sweep) is
[#12](https://github.com/chris-peterson/sextant/issues/12), and skill naming is
[#13](https://github.com/chris-peterson/sextant/issues/13).

### 2026-08-13 — Requirement IDs backticked in their headings

A requirement heading now carries its ID in backticks, matching the category
heading above it: an ID is an identifier, and the spec already set it in code
everywhere else it appears. AUTHORING-11 reworded on the write side, LOCATE-06
on the read side — a bare-ID heading still counts, so a spec written before this
parses unchanged and converting one stays a whole-file edit to offer. The
backticks don't reach the anchor (GitHub and docsify both slug the heading text
and drop the code markup), so `SPEC.md#authoring-11` still resolves. Coverage
stays 39, all Covered.

### 2026-08-13 — Requirements become headings

Each requirement now heads its own section — the bare ID, one level below its
category's backticked-prefix heading — so `SPEC.md#coverage-09` addresses one
requirement and a reader arriving at any spec-driven repo meets the same shape.
AUTHORING-11 and AUTHORING-12 specify the layout on the write side, LOCATE-06
the read side, including the inline `- **[XX-NN]**` form earlier specs use.
Coverage 36 → 39, all Covered. The form lives in `references/spec-layout.md`;
this spec was rewritten into it in the same pass.

### 2026-08-11 — LOOKUP-01 reworded

LOOKUP-01 said a requirement is presented "with its implementation status across
all implementations" — residue the candidate retirement missed, contradicting
both the Concepts entry (the implementation is at the repo root) and LOOKUP-06's
retirement note. `spec-req`'s single-requirement mode always presented one row,
so the spec was the stale side. Wording-only; coverage stays 36, all Covered.

### 2026-08-11 — Candidate workflow retired

`impl-new` and `impl-select` are gone, along with the requirements that existed
only to serve them: IMPL-01..09 (scaffold + graduation), LOOKUP-06
(per-implementation status columns), and RECONCILE-08 (cross-implementation
matrix). Coverage 47 → 36, all Covered; the retired IDs are not reused.

The audit behind it: across every repo that keeps a SPEC.md, only `tack` and
`moor` ever had an `implementations/` tree, each with a single candidate, both
flattened (2026-04-29, 2026-05-25). No repo has one now. Across 1,732 local
transcripts (which reach back to 2026-07), `spec-status` was invoked 22 times,
`spec-req` 6, `spec-sync` 5, and the two impl skills zero. The one true
multi-candidate exploration on record predates sextant.

The versioned `spec/<version>/SPEC.md` layout stays — it never depended on the
candidate tree.

### 2026-08-11 — Category naming + init walkthrough

AUTHORING-10 added: `init` walks the user through the proposed category set and
gets sign-off before scaffolding sections. AUTHORING-02 reworded — a new
category's prefix is a single all-caps word of more than one character,
replacing the 2–4 char guidance; the form now lives in
`references/category-prefix.md`. Coverage 46 → 47, all Covered.

Five prefixes renamed to the word they abbreviated, applying the new rule to
this spec: `LOC` → `LOCATE`, `REQ` → `LOOKUP`, `AUTH` → `AUTHORING`, `COV` →
`COVERAGE`, `REC` → `RECONCILE`. `IMPL` kept — the repo's own vocabulary is
already "impl" (`implementations/`, `impl-new`, `impl-select`). Numbers are
unchanged, so `AUTH-04` is today's `AUTHORING-04`; earlier entries in this
history were rewritten to the new prefixes so every ID here resolves against
the current spec. CHANGELOG.md keeps the old IDs it shipped under.

### 2026-08-01 — Evidence-pointer granularity

COVERAGE-09 added: a Covered requirement's `Location` holds a pointer at the
granularity the ledger declares, defaulting to file plus enclosing symbol.
COVERAGE-05 reworded so idempotency covers commits that change no coverage, not only
consecutive runs. Coverage 45 → 46, all Covered. This ledger declares
`**Evidence pointers:** file` — its implementation is the skill prompts, so the
file is the whole unit of evidence.

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

Evidence pointers are the file plus its enclosing symbol by default. To use a
different granularity, add `**Evidence pointers:** line` (or `anchor`, `file`,
`directory`) to the metadata block above — this ledger declares `file`.
