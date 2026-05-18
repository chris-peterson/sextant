---
name: spec-req
description: Look up, trace, and create spec requirements. Triggers on 'spec-req', requirement IDs (e.g., 'CM-01'), category prefixes (e.g., 'CM'), or 'new requirement'.
argument-hint: "<XX-NN | XX | new>"
---

# Spec Req

Look up requirements by ID or category, trace them through implementations, and surface gaps in both directions. Also handles creating new requirements.

```mermaid
%%{ init: { 'look': 'handDrawn' } }%%
flowchart TD
    Start(["/sextant:spec-req arg"]) --> Parse

    Parse{"Parse argument"} -->|"XX-NN"| Single["Single requirement lookup"]
    Parse -->|"XX"| Category["Category lookup"]
    Parse -->|"new"| New["New requirement"]

    subgraph "Lookup"
        Single --> FindSpec["Locate SPEC.md"]
        Category --> FindSpec
        FindSpec --> Extract["Extract matching requirements"]
        Extract --> Table["Present requirement table"]
    end

    subgraph "Trace"
        Table --> Trace["Search implementations"]
        Trace --> Gaps["Report gaps both directions"]
    end

    subgraph "Create"
        New --> FindSpec2["Locate SPEC.md"]
        FindSpec2 --> Classify["Auto-assign category + number"]
        Classify --> Confirm["User confirms"]
        Confirm --> Write["Write to SPEC.md"]
    end
```

## Locate the spec

Find the current SPEC.md. Check in order:

1. `spec/` directory at the repo root or in common subfolder locations (`vnext/`, `exploration/`, `migration/`)
2. Justfile `spec` variable pointing to the current version
3. `CURRENT_SPEC_VERSION` environment variable
4. `SPEC.md` at the repo root

If no SPEC.md is found, ask the user where it is.

## Mode: Single requirement (`sextant:spec-req XX-NN`)

Look up one requirement by its full ID.

1. **Find the requirement** in SPEC.md. If the ID doesn't exist, say so and suggest nearby IDs in the same category.

2. **Present a table** with the requirement and its implementation status across all implementations:

```text
| ID    | Requirement              | impl-1       | impl-2       |
|-------|--------------------------|--------------|--------------|
| CM-01 | Config file loading      | Covered      | Partial      |
|       |                          | src/cfg.py:45| src/cfg.js:30|
```

3. **Trace through implementations** to find gaps:
   - **Implementation gaps** — the spec says something the code doesn't do. Search for the requirement ID in comments, grep for keywords from the requirement text, and read relevant code to verify behavior.
   - **Spec gaps** — the code around this requirement does something the spec doesn't mention. Look at neighboring code, recent commits touching related files, and STATUS.md notes.

4. **Report findings** below the table:

```text
Gaps found:
  → impl-2: missing env var override (CM-01 says "env vars take precedence")
  → Spec gap: impl-1 supports YAML config (src/cfg.py:62) but spec only mentions JSON
```

If no gaps are found, say so — a clean result is useful information.

## Mode: Category lookup (`sextant:spec-req XX`)

Look up all requirements in a category.

1. **Extract all requirements** matching the category prefix from SPEC.md.

2. **Present a summary table** with implementation status:

```text
## CM — Configuration (4 requirements)

| ID    | Requirement              | Status  | Location          |
|-------|--------------------------|---------|-------------------|
| CM-01 | Config file loading      | Covered | src/cfg.py:45     |
| CM-02 | Env var overrides        | Partial | src/cfg.py:72     |
| CM-03 | Validation on startup    | Missing | —                 |
| CM-04 | Config hot-reload        | FUT     | (deferred)        |
```

3. **Trace each non-FUT requirement** through implementations, same as single-requirement mode but summarized. Only report gaps — don't repeat "no gaps" for every covered requirement.

4. **Category summary** at the bottom:

```text
Coverage: 1/3 active requirements (33%)
Gaps: 2 implementation gaps, 1 spec gap
```

## Mode: New requirement (`sextant:spec-req new`)

Guide the user through creating a new requirement. This replaces the standalone `spec-new-req` skill.

### Step 1: Classify

Read existing categories and their highest requirement numbers from the spec.

Based on the user's description:
- **Match to an existing category** if it fits. Use the next available number.
- **Create a new category** if none fits. Choose a 2-3 letter mnemonic that doesn't collide with existing prefixes.
- **Draft the requirement text using [EARS syntax](https://alistairmavin.com/ears)** — choose the pattern that fits the requirement's activation:
  - **Ubiquitous** (no keyword): `The <system> shall <response>` — always-active constraints
  - **State-Driven**: `While <precondition>, the <system> shall <response>` — behavior depends on system state
  - **Event-Driven**: `When <trigger>, the <system> shall <response>` — triggered by a discrete event
  - **Optional**: `Where <feature is included>, the <system> shall <response>` — configurable features
  - **Unwanted Behaviour**: `If <condition>, then the <system> shall <response>` — error handling and edge cases
  - Patterns combine: `While <state>, when <trigger>, the <system> shall <response>`

Present for confirmation:

```text
Proposed requirement:

  [XX-NN] <drafted requirement text>
  Category: <name> (existing|new)

Does this look right?
```

### Step 2: Scope check

After the user confirms:

- **Trivial/isolated** — ask: "This looks straightforward — implement now, or capture for later?"
- **Non-trivial** — ask: "This touches [scope]. Implement now, or capture as `FUT-NN`?"

### Step 3: Write

**If implementing now:**
1. Add to SPEC.md in the appropriate category section, sorted by ID
2. Update STATUS.md with "unmet" for each tracked implementation
3. Flow to implementations — make the change, update STATUS.md to "covered"

**If capturing as future:**
1. Add to SPEC.md under "Future Requirements" as `[FUT-NN] (→ XX) <requirement text>`

**Confirm:**

```text
Captured [XX-NN]: <short description>
  → SPEC.md updated
  → STATUS.md updated (if applicable)
  → N implementations updated (if applicable)
```

## Multiple implementations

When multiple implementations exist, always show status per implementation in the table columns rather than a single status. This is where spec-driven development gets its value — disagreements between implementations often reveal spec ambiguities.
