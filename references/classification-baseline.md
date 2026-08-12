# The classification baseline

A ledger row says a requirement is Covered. That claim was made by reading the
code against a particular *requirement text* — and when the text later changes,
the row stays green while the reading behind it goes stale. Nothing in the
ledger shows that, because the row looks identical either way.

The **classification baseline** is the file whose requirement text a ledger's
classifications were made against, named in STATUS.md's metadata block:

```markdown
**Classified against:** spec/v1/SPEC.md
```

**This file is the single source of truth** for how that line is written, read,
and cleared. Each skill quotes a one-line summary and defers here.

## Who writes it

`spec-req bump` writes it, and it is the only thing that does. A bump copies the
spec forward and carries the prior version's ledger with it, so every
classification in the new ledger was made against the *prior* version's text.
Naming that file is what makes the staleness recoverable instead of invisible.

An in-place spec edit writes no baseline: there is no second file to point at.
That case is not covered here.

## Who reads it, and what they do

`spec-status` reads it on refresh. When the line is present, compare each
requirement's current text against the same ID's text in the baseline file:

- **Text unchanged** — the classification still stands on the reading that
  produced it. Leave the row alone.
- **Text differs** — demote to needs-reclassification and say which IDs moved.
  The code may well still satisfy the requirement, but nobody has read it
  against the new wording yet, and that reading is the whole claim.
- **ID absent from the baseline** — a requirement added since the bump. It was
  never classified against anything, so it is unclassified, not demoted.

Compare the requirement's own text, not the whole file: an edit to the Concepts
section or a neighboring category has no bearing on whether this row's reading
holds.

A refresh reclassifies from the code regardless, so the demotion is not what
makes the next audit correct — the forward pass does that on its own. What the
baseline adds is a reader-visible marker in the window *before* that refresh
runs, when a carried-forward ledger otherwise shows green rows for requirements
whose wording has moved underneath them.

## Clearing it

Once a refresh has reclassified against the current spec, the baseline has
served its purpose — the classifications now stand on the current text, and
leaving the line in place would re-demote the same rows on every subsequent run.
Remove it as part of that refresh.

This is what keeps the refresh idempotent: the first run after a bump demotes
and clears, and the next finds nothing to do.

## Why not a stored digest per requirement

Recording a hash of each requirement's text alongside its row would catch the
in-place edit too, which this does not — an edit with no second file to point
at leaves no baseline behind. It was weighed and rejected for now:

- It adds a line per requirement to every ledger, permanently, for a signal most
  refreshes never use.
- Digesting a whole category instead demotes all of its rows whenever
  `spec-req new` adds one — a false signal on the most common authoring
  operation.
- A commit-sha baseline is the same idea and worse: the sha changes on every
  commit, so the ledger would rewrite itself constantly and the coverage
  refresh would stop being idempotent.

The baseline pointer costs one line and only exists between a bump and the next
refresh, which is exactly the window where the staleness is real.
