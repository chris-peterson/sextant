# sextant — Specification

sextant is a Claude Code plugin for AI-assisted, "best-effort" spec-driven development: it keeps a plain-language spec under source control, tracks how the code covers it, and reconciles the two in whichever direction the user names.

Requirements lead the code sometimes and lag it often, and both are normal entry
points. A spec can be authored ahead of the work, recovered from an implementation
that already shipped, or grown a requirement at a time as behavior lands. Nothing
here assumes the spec came first.

Requirements use [EARS syntax](https://alistairmavin.com/ears) — each is one of:
Ubiquitous (`The <system> shall …`), State-Driven (`While …`), Event-Driven
(`When …`), Optional (`Where …`), or Unwanted Behaviour (`If … then …`).

Each requirement is its own heading carrying a stable ID (`XX-NN`), one level
below its category's heading, so every requirement has a linkable anchor
(`SPEC.md#locate-01`). Lettered decompositions (`XX-NNa`) each count as one.
Everything on the page is a requirement the code is measured against; ideas that
may or may not happen belong in the issue tracker, not the spec. The layout is
specified in `references/spec-layout.md`.

## Concepts

- **SPEC.md** — the contract. The authoritative, ordered list of requirements the implementation is measured against. This file.
- **STATUS.md** — the coverage ledger. A machine-refreshable record of how each requirement is classified against the current code; carries human-authored prose (rationale, audit history) that the ledger writer preserves.
- **Requirement** — one normative statement of observable behavior, written in EARS syntax under a heading bearing its ID.
- **Category** — a prefix grouping related requirements (`LOCATE`, `LOOKUP`, `AUTHORING`, …): more than one character, all caps, a single word with no punctuation, spelling out the name people say for the thing rather than an ad-hoc contraction (an established initialism like `UX` or `CLI` is that name). Categories partition the requirement space.
- **Coverage classification** — the status of a requirement against the code: **Covered**, **Partial**, **Missing**, or **Contradicts**.
- **Evidence pointer** — where the code satisfies a requirement, recorded in the ledger's `Location`. Its granularity is the project's choice (line range → symbol → anchor → file → directory), defaulting to file plus enclosing symbol so it survives edits it isn't about.
- **Locate order** — the shared, ordered procedure every skill uses to find the active SPEC.md (STATUS.md pointer → `spec/` dir → justfile `spec` var → root `SPEC.md`/`docs/spec.md`).
- **Drift** — behavior the code exhibits that no requirement captures (code → spec), or a requirement the code no longer satisfies (spec → code).
- **Implementation** — the code that satisfies the spec, at the repo root.

## Requirements

### `LOCATE`
Spec & artifact discovery

#### `LOCATE-01`
The system shall locate the active SPEC.md using a single shared, ordered discovery procedure across all skills.

#### `LOCATE-02`
While a STATUS.md exists, the system shall consult its spec-pointer link before other discovery steps, so a non-standard spec location is honored.

#### `LOCATE-03`
When spec-status runs where no SPEC.md is found, the system shall print one line and exit without prompting, scaffolding, or reporting.

#### `LOCATE-04`
When spec-sync runs where no SPEC.md is found, the system shall report that no spec exists and direct the user to `spec-req init`.

#### `LOCATE-05`
When counting coverage, the system shall treat each distinct requirement ID — including lettered decompositions — as one normative requirement, and shall exclude retired IDs.

#### `LOCATE-06`
When reading a spec, the system shall take each requirement-ID heading as one requirement whether or not the heading backticks the ID, and shall also recognize requirements written in the inline `- **[XX-NN]**` form a spec predating the heading layout uses.

### `LOOKUP`
Requirement lookup & tracing

#### `LOOKUP-01`
When given a full requirement ID, the system shall present that requirement with its implementation status.

#### `LOOKUP-02`
If a requested requirement ID does not exist, then the system shall say so and suggest nearby IDs in the same category.

#### `LOOKUP-03`
When given a category prefix, the system shall present every requirement in that category with per-requirement status and a category coverage summary.

#### `LOOKUP-04`
When tracing a requirement, the system shall report gaps in both directions — implementation gaps and spec gaps.

#### `LOOKUP-05`
When a trace finds no gaps, the system shall state the clean result explicitly rather than reporting nothing.

#### ~~`LOOKUP-06`~~
~~Where multiple implementations exist, the system shall present status per implementation rather than a single combined status.~~

_Retired 2026-08-11 — the candidate-runoff workflow it belonged to was retired. The ID is not reused._

### `AUTHORING`
Requirement authoring

#### `AUTHORING-01`
The system shall draft new requirements in EARS syntax, choosing the pattern that matches the requirement's activation.

#### `AUTHORING-02`
When authoring a requirement, the system shall assign it to a fitting existing category or create a new one whose prefix is a non-colliding single all-caps word of more than one character, using the next available number.

#### `AUTHORING-03`
When a requirement has been drafted, the system shall present it for user confirmation before writing it to SPEC.md.

#### `AUTHORING-04`
When a confirmed requirement is non-trivial, the system shall ask whether to implement it now, and shall direct a not-now answer to the project's issue tracker rather than recording the requirement in SPEC.md.

#### ~~`AUTHORING-05`~~
~~When capturing a deferred requirement, the system shall record it under Future Requirements as a `FUT-NN` heading naming the category it targets.~~

_Retired 2026-08-21 — it captured requirements the project was not committing to as spec entries of their own. Those belong in the issue tracker; the ID is not reused._

#### `AUTHORING-06`
When writing a requirement to SPEC.md, the system shall insert it into its category section sorted by ID.

#### `AUTHORING-07`
When no spec exists, the system shall bootstrap a SPEC.md skeleton (EARS preamble, Concepts, empty category sections) and a STATUS.md stub, without inventing requirements.

#### `AUTHORING-08`
Where a requirements-source document is supplied to init, the system shall extract its requirements into SPEC.md as EARS statements instead of scaffolding an empty skeleton.

#### `AUTHORING-09`
If a spec already exists when init is invoked, then the system shall stop and direct the user to `new`.

#### `AUTHORING-10`
When bootstrapping a spec, the system shall walk the user through the proposed category set — each prefix, its name, and what it covers — and obtain sign-off before scaffolding any section.

#### `AUTHORING-11`
When writing a requirement to SPEC.md, the system shall give it its own heading whose text is the backticked requirement ID, so the requirement carries a linkable anchor.

#### `AUTHORING-12`
When writing a category section to SPEC.md, the system shall head it with the backticked category prefix and carry the category's full name beneath that heading.

### `COVERAGE`
Coverage ledger

#### `COVERAGE-01`
When refreshing coverage, the system shall classify each requirement as Covered, Partial, Missing, or Contradicts by reading the current code rather than trusting the prior ledger.

#### `COVERAGE-02`
The spec-status skill shall write only STATUS.md and shall never edit code or SPEC.md.

#### `COVERAGE-03`
While a STATUS.md already exists, the system shall edit only its machine-derived regions and preserve human-authored prose and audit history.

#### `COVERAGE-04`
When no STATUS.md exists, the system shall generate one from the canonical template.

#### `COVERAGE-05`
The coverage refresh shall be idempotent across commits that change no coverage — such a run shall write nothing and report the ledger already accurate.

#### `COVERAGE-06`
When a refresh changes the ledger, the system shall append a dated audit-history entry and print a one-line change summary.

#### `COVERAGE-07`
If the code contradicts a requirement's spec text, then the system shall record a needs-decision row rather than reconciling it.

#### `COVERAGE-08`
The system shall keep the coverage header count, the sum of per-category counts, and the spec's normative inventory equal.

#### `COVERAGE-09`
When recording evidence for a Covered requirement, the system shall record a pointer at the granularity the ledger declares, defaulting to the file plus its enclosing symbol rather than a line number.

### `RECONCILE`
Spec/code reconciliation

#### `RECONCILE-01`
When reconciling, the system shall analyze the full domain every run — coverage, bidirectional drift, and requirement quality.

#### `RECONCILE-02`
The system shall detect divergence in both directions but apply a resolution in only one user-named direction per run.

#### `RECONCILE-03`
While reconciling with `--to-spec`, the system shall draft an EARS requirement for each drift item and write it only after confirmation.

#### `RECONCILE-04`
While reconciling with `--to-source`, the system shall produce an implementation gap list and hand off to a development session without writing code.

#### `RECONCILE-05`
If a requirement and the code contradict, then the system shall surface both sides and shall not auto-resolve the contradiction either way.

#### `RECONCILE-06`
When reconciling, the system shall flag non-EARS-conformant or over-specified requirements with a suggested rewrite for each.

#### `RECONCILE-07`
The system shall delegate every STATUS.md write to the coverage-ledger skill rather than writing the ledger directly.

#### ~~`RECONCILE-08`~~
~~Where multiple implementations exist, the system shall classify each separately and present a comparison matrix.~~

_Retired 2026-08-11 — the candidate-runoff workflow it belonged to was retired. The ID is not reused._

_No IMPL category — IMPL-01..09 covered scaffolding candidate implementations under `implementations/<version>/<n>-<name>/` and graduating a winner to the repo root. That workflow is retired; the IDs are not reused._
