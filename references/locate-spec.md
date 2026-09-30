# Locating the active SPEC.md

The shared, ordered discovery procedure every sextant skill uses to find the
active SPEC.md. **This file is the single source of truth** — each skill quotes
a one-line summary for the reader but defers here for the authoritative order.
When editing the order, edit it here, and in
[`scripts/locate-spec.sh`](https://github.com/chris-peterson/sextant/blob/main/scripts/locate-spec.sh), its one executable form.
The skills and the ledger-signal hook run the script rather than walking these
steps themselves, and `tests/locate-spec.test.sh` exercises each step and exit
code below.

Check in order; the first hit wins:

1. **STATUS.md spec-pointer.** If a root `STATUS.md` exists, read its
   spec-pointer link first — the first link on its `Tracking ...` header line,
   e.g. ``Tracking ... declared in [`docs/spec.md`](docs/spec.md)``. STATUS.md
   names where its own spec lives, and that pointer catches non-standard
   locations (e.g. a lowercase `docs/spec.md`) the generic search below would
   miss. A pointer to a file that does not exist is an error to report, not a
   miss to search past.
2. **`spec/` directory**: `spec/SPEC.md`, or `spec/<name>/SPEC.md` for a named
   subfolder (`spec/v1/`, `spec/vnext/`, `spec/exploration/`, `spec/migration/`).
   One spec there is the hit. With more than one, list them and ask rather than
   choosing silently; a STATUS.md pointer (step 1) is how a repo names which one
   is active.
3. **`SPEC.md` (or `docs/spec.md`) at the repo root.**

The script prints `SPEC=`, `STATUS=`, and `VIA=` lines and exits `0` on a hit,
`1` when there is no spec, `2` (with a `CANDIDATE=` line per spec) when `spec/`
holds several and no pointer names one, and `3` (with `POINTER=`) for a broken
spec-pointer.

Most projects resolve at step 1 or step 3: a root `SPEC.md` with a `STATUS.md`
beside it. Step 2 serves a project that keeps its spec under `spec/<version>/`,
which is a layout choice, not a workflow sextant drives.

## On a miss, the response is skill-specific

What to do when no SPEC.md is found is **not** uniform — each skill owns its own
behavior (this file only defines the search order):

- **spec-status** — print one line and exit; no prompt, no scaffold, no report.
  It runs unattended inside other workflows, so it self-skips silently.
- **spec-sync** — report that no spec exists and point the user at
  `spec-req init`. It is always user-invoked and interactive.
- **spec-req** — ask the user where the spec is (except `init`, which *expects*
  no spec and scaffolds one).
