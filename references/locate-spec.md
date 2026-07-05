# Locating the active SPEC.md

The shared, ordered discovery procedure every sextant skill uses to find the
active SPEC.md. **This file is the single source of truth** — each skill quotes
a one-line summary for the reader but defers here for the authoritative order.
When editing the order, edit it here.

Check in order; the first hit wins:

1. **STATUS.md spec-pointer.** If a `STATUS.md` exists, read its spec-pointer
   link first — the header line, e.g.
   ``Tracking ... declared in [`docs/spec.md`](docs/spec.md)``. STATUS.md names
   where its own spec lives, and that pointer catches non-standard locations
   (e.g. a lowercase `docs/spec.md`) the generic search below would miss.
2. **`spec/` directory** at the repo root or in common subfolders (`vnext/`,
   `exploration/`, `migration/`).
3. **Justfile `spec` variable** pointing to the current version.
4. **`CURRENT_SPEC_VERSION` environment variable.**
5. **`SPEC.md` (or `docs/spec.md`) at the repo root.**

## On a miss, the response is skill-specific

What to do when no SPEC.md is found is **not** uniform — each skill owns its own
behavior (this file only defines the search order):

- **spec-status** — print one line and exit; no prompt, no scaffold, no report.
  It runs unattended inside other workflows, so it self-skips silently.
- **spec-sync** — report that no spec exists and point the user at
  `spec-req init`. It is always user-invoked and interactive.
- **spec-req** — ask the user where the spec is (except `init`, which *expects*
  no spec and scaffolds one).
- **impl-new** — stop and ask; never scaffold an implementation tree before
  there is a contract to build against.
