# Counting requirements

The shared normative-count rule. **This file is the single source of truth** —
`spec-sync` and `spec-status` both quote a summary but defer here. Getting the
count wrong is the most common STATUS.md drift, so the rule is stated once.

- One normative requirement = one distinct `[XX-NN]` ID, **including lettered
  decompositions** — `CL-21a`, `CL-21b`, … each count as one. A row labeled
  `CL-01..37 (+CL-19a)` whose real ID set includes `CL-21a..d` and `CL-36a..d`
  has a count of 46, not 38.
- **Exclude** from the normative count: FUT/deferred IDs and retired/struck IDs
  (removed from the spec, or shown struck-through). Retired IDs belong in the
  numbering-gap prose ("no PROV-04 … intentional"), never in the count.
- **Enforce the invariant:** the coverage header count == the sum of the
  per-category counts == the spec's normative inventory. The drift found in real
  repos was always one of these three disagreeing.
