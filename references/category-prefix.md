# Category prefixes

The shared rule for naming a requirement category. **This file is the single
source of truth** — `spec-req` defers here from both `new` and `init`, and
`spec-sync --to-spec` reaches it through `spec-req`'s create flow.

A prefix is the `XX` in `[XX-NN]`. It is written once and read in every
requirement ID, every ledger row, and every code anchor that cites one — so it
is named for the reader, not the typist.

## The form

- **More than one character.** A single letter carries no meaning at the point
  of use; `[A-04]` tells the reader nothing.
- **All caps.** `AUTH`, not `Auth` or `auth`.
- **One word — no spaces, hyphens, underscores, or punctuation.** The ID splits
  on its hyphen, so a hyphen inside the prefix makes `[SPEC-REQ-01]` ambiguous.
- **Unique** among the prefixes already in the spec.

There is no upper length. `RENDERING` is a fine prefix.

## Choosing the word

**Use the name people already say for the thing.** Usually that's the whole
word: `RENDERING`, not `RN` — the short form saves five characters and costs the
reader a lookup every time.

**An established abbreviation is that name.** `UX`, `CI`, `CLI`, `API`, `HTTP`,
`SQL` — nobody says "user experience section," and `USEREXPERIENCE` is worse on
every axis than `UX`. Don't expand an initialism that already reads as one word
to its audience. The same holds for a domain's own settled short forms (`AUTH`
for authentication, `CONFIG` for configuration).

The test is what you'd say out loud when pointing at the section. If that's a
word, use the word; if it's letters, use the letters. What the rule rules out is
the ad-hoc contraction invented at typing time — `RN` for rendering, `DPLY` for
deployment — which no one says and every reader has to decode.

The pressure to abbreviate comes from typing IDs; the payoff of a name that
reads lands on everyone who later meets it in a status table, a commit message,
or a code comment.

**Renaming a prefix is expensive**, which is why the naming happens up front:
every requirement in the category is re-IDed, every ledger row and audit-history
entry that names an old ID goes stale, and any code anchor citing one has to be
found and rewritten. Spend the time on the name before the category has
requirements in it.

A spec that already uses terse prefixes keeps them — consistency inside one spec
beats a partial migration.
