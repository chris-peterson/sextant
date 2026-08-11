# Evidence pointers

The shared rule for what a Covered requirement's `Location` holds. **This file
is the single source of truth** — `spec-sync`, `spec-status`, and `spec-req`
all defer here.

An evidence pointer answers "where does the code satisfy this?". It is recorded
once and read many times, across commits that have nothing to do with the
requirement — so its granularity is a trade between how precisely it points and
how long it stays true.

## The default: file plus enclosing symbol

Record `src/git.ts` (`preflightChecks`), not `src/git.ts:62-73`.

A line number is the one fact about an implementation that changes without the
implementation changing: any edit above it shifts it. A symbol name survives
those edits, and `git grep preflightChecks` recovers the exact line on demand.

**Prefer a requirement-ID anchor when the repo has one.** Where the code or its
tests name the ID at the site (`// PF-02`, or a test named
`PF-02: aborts below the floor`), record the anchor — `src/git.ts` (`PF-02`).
The pointer stops being transcribed at all, and the forward pass shifts from
*searching for* evidence to *verifying* an assertion the code makes about
itself. A repo without anchors falls back to the symbol.

**Where there is no symbol to name** — a stylesheet, a config file, a data
fixture — record the file alone (`src/ui.css`). Naming a plausible-looking
selector or key that isn't there is worse than the coarser pointer.

## Choosing a different granularity

A project may prefer another point on the spectrum. Honor its choice:

| Granularity | Example | Precision | Survives | Cost |
|---|---|---|---|---|
| Line range | `src/git.ts:62-73` | exact branch | nothing above it moving | rots on unrelated commits; every refresh rewrites rows |
| **Symbol** (default) | `src/git.ts` (`preflightChecks`) | the function | edits within and above the file | resolves to the whole function, not the branch |
| ID anchor | `src/git.ts` (`PF-02`) | the tagged site | renames and moves | needs the repo to tag call sites |
| File | `src/git.ts` | the file | any edit inside it | a long file points the reader at a lot of code |
| Directory | `src/auth/` | the area | file splits and renames | navigational only; useful where refactoring is constant |

A team that refactors aggressively is right to pick a coarser pointer; one whose
files are small and stable can afford line ranges and get the precision. Neither
is wrong — what is wrong is a precise pointer that has gone stale, because
nothing about a stale `src/git.ts:62-73` looks stale.

**A project declares its choice** with an optional metadata line in STATUS.md:

```markdown
**Evidence pointers:** line
```

Values: `symbol` (default), `anchor`, `line`, `file`, `directory`. When the line
is absent, use `symbol`. A refresh reads the declaration and records new
pointers in that form, so the ledger converges instead of being rewritten by
every run.

## Converting an existing ledger

A ledger written before this rule carries line ranges. The first refresh under
the default rewrites every `Location`, which is a large diff that no coverage
change caused. Report it as a pointer-format conversion, distinct from a
coverage transition, so the summary doesn't read as drift. Subsequent runs are
no-ops. A project that wants to keep its line ranges declares
`**Evidence pointers:** line` and gets no conversion at all.
