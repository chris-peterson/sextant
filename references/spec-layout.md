# Spec layout

The shared rule for how requirements sit on the page in a SPEC.md. **This file
is the single source of truth** — `spec-req`, `spec-sync`, and `spec-status`
each quote a one-line summary and defer here, whether they are writing the
layout or reading it.

## The shape

A category is a heading whose text is its backticked prefix, with the
category's full name on the line beneath. Each requirement is a heading one
level below, whose text is its backticked ID, with the EARS statement beneath
it. The ID is backticked for the same reason the prefix is: it's an identifier,
not prose.

```markdown
### `LOCATE`
Spec & artifact discovery

#### `LOCATE-01`
The system shall locate the active SPEC.md using a single shared, ordered
discovery procedure across all skills.

#### `LOCATE-02`
While a STATUS.md exists, the system shall consult its spec-pointer link before
other discovery steps.
```

**The heading levels are relative, not fixed.** What holds is that a
requirement sits exactly one level below its category. Pick the absolute level
from the document: `##`/`###` in a spec whose categories are top-level sections,
`###`/`####` where they nest under a `## Requirements` umbrella (sextant's own
SPEC.md is the second). Match whatever the file already does.

## Why headings

A heading gets an anchor, and an anchor is a link. `SPEC.md#locate-01` addresses
one requirement — paste it into a review comment, an issue, or a commit message
and the reader lands on the requirement rather than on a 500-line file to scroll.
The anchor is the ID lowercased, so it is derivable without opening the file —
the backticks don't reach it, because GitHub and docsify both slug the heading's
text and drop the code markup around it.

The second payoff is across projects: every spec-driven repo puts its
requirements in the same place in the same form, so a reader (or an agent)
arriving at an unfamiliar spec doesn't have to work out that repo's convention
first.

## What counts as a requirement

**A requirement is a requirement-ID heading, and nothing else is.** That is what
makes the count in [`counting-rule.md`](counting-rule.md) mechanical: the
normative inventory is the set of ID headings under `## Requirements`, minus
retired IDs. There is no deferred tier: a spec carries the requirements the code
is measured against, and an idea that may not happen is an issue, not an entry.

On the read side an ID heading counts whether or not it carries backticks —
`#### LOCATE-01` and ``#### `LOCATE-01` `` are the same requirement. Write the
backticked form; a spec written before this rule keeps parsing and counting
unchanged, and converting it is a whole-file edit to offer, not to fold into
another change.

Prose that is *about* the requirements — a numbering-gap note, a rationale
paragraph, a retired-ID note — stays as body text under the category heading,
never as a heading of its own. Keeping it headless is what keeps it out of the
inventory:

```markdown
_No LOOKUP-06 — it required per-implementation status columns and retired with
the candidate workflow._
```

## Referring to a requirement

In prose, name the ID plainly (`AUTHORING-08`) or link it
(`[AUTHORING-08](SPEC.md#authoring-08)`). Bracketed IDs (`[XX-NN]`) remain
readable and are what older specs and ledgers use; both forms resolve to the
same ID, so a STATUS.md row or an audit entry written either way still traces.

## Reading a spec that predates this layout

Earlier specs write a category as `### XX — Name` and each requirement as a
bullet:

```markdown
- **[LOCATE-01]** The system shall locate the active SPEC.md …
```

Read that form too — extraction, counting, and coverage all work on it
unchanged. When adding a requirement to such a spec, **match the file**:
consistency inside one spec beats a half-converted one, the same way
[`category-prefix.md`](category-prefix.md) leaves a spec's existing terse
prefixes alone. Converting the whole file to headings is a separate, whole-file
edit — offer it, and do it only if the user says yes.
