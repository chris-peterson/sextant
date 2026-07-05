# sextant — Specification

sextant is a Claude Code plugin for AI-assisted, "best-effort" spec-driven development: it writes requirements first, audits implementations against them, and graduates the winning candidate from a spec-driven exploration tree to the implementation at the repo root.

Requirements use [EARS syntax](https://alistairmavin.com/ears) — each is one of:
Ubiquitous (`The <system> shall …`), State-Driven (`While …`), Event-Driven
(`When …`), Optional (`Where …`), or Unwanted Behaviour (`If … then …`).
Each requirement carries a stable ID (`[XX-NN]`); lettered decompositions
(`XX-NNa`) each count as one. Deferred requirements live under Future
Requirements as `[FUT-NN] (→ XX) …`.

## Concepts

- **SPEC.md** — the contract. The authoritative, ordered list of requirements the implementation is measured against. This file.
- **STATUS.md** — the coverage ledger. A machine-refreshable record of how each requirement is classified against the current code; carries human-authored prose (rationale, audit history) that the ledger writer preserves.
- **Requirement** — one normative statement of observable behavior, identified by `[XX-NN]` and written in EARS syntax.
- **Category** — a 2–4 letter mnemonic prefix grouping related requirements (`LOC`, `REQ`, …). Categories partition the requirement space.
- **Coverage classification** — the status of a requirement against the code: **Covered**, **Partial**, **Missing**, or **Contradicts**.
- **Locate order** — the shared, ordered procedure every skill uses to find the active SPEC.md (STATUS.md pointer → `spec/` dir → justfile `spec` var → `CURRENT_SPEC_VERSION` → root `SPEC.md`/`docs/spec.md`).
- **Drift** — behavior the code exhibits that no requirement captures (code → spec), or a requirement the code no longer satisfies (spec → code).
- **Implementation** — code that satisfies the spec. A repo has either one (at the root) or several candidates under `implementations/<version>/<n>-<name>/`.
- **Candidate** — an exploratory implementation built against the spec to stress-test it; an instrumented experiment, not a competitor.
- **Graduation** — the one-way move that selects a winning candidate, retires the others, and flattens the winner to the repo root.

## Requirements

### LOC — Spec & artifact discovery

- **[LOC-01]** The system shall locate the active SPEC.md using a single shared, ordered discovery procedure across all skills.
- **[LOC-02]** While a STATUS.md exists, the system shall consult its spec-pointer link before other discovery steps, so a non-standard spec location is honored.
- **[LOC-03]** When spec-status runs where no SPEC.md is found, the system shall print one line and exit without prompting, scaffolding, or reporting.
- **[LOC-04]** When spec-sync runs where no SPEC.md is found, the system shall report that no spec exists and direct the user to `spec-req init`.
- **[LOC-05]** When counting coverage, the system shall treat each distinct requirement ID — including lettered decompositions — as one normative requirement, and shall exclude deferred (FUT) and retired IDs.

### REQ — Requirement lookup & tracing

- **[REQ-01]** When given a full requirement ID, the system shall present that requirement with its implementation status across all implementations.
- **[REQ-02]** If a requested requirement ID does not exist, then the system shall say so and suggest nearby IDs in the same category.
- **[REQ-03]** When given a category prefix, the system shall present every requirement in that category with per-requirement status and a category coverage summary.
- **[REQ-04]** When tracing a requirement, the system shall report gaps in both directions — implementation gaps and spec gaps.
- **[REQ-05]** When a trace finds no gaps, the system shall state the clean result explicitly rather than reporting nothing.
- **[REQ-06]** Where multiple implementations exist, the system shall present status per implementation rather than a single combined status.

### AUTH — Requirement authoring

- **[AUTH-01]** The system shall draft new requirements in EARS syntax, choosing the pattern that matches the requirement's activation.
- **[AUTH-02]** When authoring a requirement, the system shall assign it to a fitting existing category or create a new one with a non-colliding mnemonic prefix, using the next available number.
- **[AUTH-03]** When a requirement has been drafted, the system shall present it for user confirmation before writing it to SPEC.md.
- **[AUTH-04]** When a confirmed requirement is non-trivial, the system shall ask whether to implement it now or capture it as deferred (FUT).
- **[AUTH-05]** When capturing a deferred requirement, the system shall record it under Future Requirements as `[FUT-NN] (→ XX) …`.
- **[AUTH-06]** When writing a requirement to SPEC.md, the system shall insert it into its category section sorted by ID.
- **[AUTH-07]** When no spec exists, the system shall bootstrap a SPEC.md skeleton (EARS preamble, Concepts, empty category sections) and a STATUS.md stub, without inventing requirements.
- **[AUTH-08]** Where a requirements-source document is supplied to init, the system shall extract its requirements into SPEC.md as EARS statements instead of scaffolding an empty skeleton.
- **[AUTH-09]** If a spec already exists when init is invoked, then the system shall stop and direct the user to `new`.

### COV — Coverage ledger

- **[COV-01]** When refreshing coverage, the system shall classify each non-deferred requirement as Covered, Partial, Missing, or Contradicts by reading the current code rather than trusting the prior ledger.
- **[COV-02]** The spec-status skill shall write only STATUS.md and shall never edit code or SPEC.md.
- **[COV-03]** While a STATUS.md already exists, the system shall edit only its machine-derived regions and preserve human-authored prose and audit history.
- **[COV-04]** When no STATUS.md exists, the system shall generate one from the canonical template.
- **[COV-05]** The coverage refresh shall be idempotent — a run that finds no change shall write nothing and report the ledger already accurate.
- **[COV-06]** When a refresh changes the ledger, the system shall append a dated audit-history entry and print a one-line change summary.
- **[COV-07]** If the code contradicts a requirement's spec text, then the system shall record a needs-decision row rather than reconciling it.
- **[COV-08]** The system shall keep the coverage header count, the sum of per-category counts, and the spec's normative inventory equal.

### REC — Spec/code reconciliation

- **[REC-01]** When reconciling, the system shall analyze the full domain every run — coverage, bidirectional drift, and requirement quality.
- **[REC-02]** The system shall detect divergence in both directions but apply a resolution in only one user-named direction per run.
- **[REC-03]** While reconciling with `--to-spec`, the system shall draft an EARS requirement for each drift item and write it only after confirmation.
- **[REC-04]** While reconciling with `--to-source`, the system shall produce an implementation gap list and hand off to a development session without writing code.
- **[REC-05]** If a requirement and the code contradict, then the system shall surface both sides and shall not auto-resolve the contradiction either way.
- **[REC-06]** When reconciling, the system shall flag non-EARS-conformant or over-specified requirements with a suggested rewrite for each.
- **[REC-07]** The system shall delegate every STATUS.md write to the coverage-ledger skill rather than writing the ledger directly.
- **[REC-08]** Where multiple implementations exist, the system shall classify each separately and present a comparison matrix.

### IMPL — Implementation lifecycle

- **[IMPL-01]** When scaffolding a candidate, the system shall require an existing SPEC.md and stop if none exists.
- **[IMPL-02]** When scaffolding a candidate, the system shall gather stack and constraints conversationally and present a plan for sign-off before creating files.
- **[IMPL-03]** The system shall name candidates `<n>-<name>` (a short, kebab-case label) with the next sequence number, refusing a slug that collides or skips the sequence.
- **[IMPL-04]** When scaffolding a candidate, the system shall seed its STATUS.md with every non-deferred requirement marked Missing (not yet covered), marking none Covered optimistically.
- **[IMPL-05]** The system shall not port code from sibling implementations into a new candidate.
- **[IMPL-06]** Graduation shall be a one-way operation, performed only when a single candidate is the de-facto choice and the others are inactive.
- **[IMPL-07]** When graduating a candidate, the system shall retire the others, flatten the winner to the repo root, and rewrite every reference to the old implementation paths in one coherent change.
- **[IMPL-08]** When graduating, the system shall verify the flattened tree (build, test, install smoke-test, spec-sync gate) and diagnose failures rather than papering over them.
- **[IMPL-09]** When retiring candidates, the system shall describe their contribution in neutral or positive terms.

## Future Requirements

_(none yet)_
