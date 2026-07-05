# EARS requirement patterns

The five [EARS](https://alistairmavin.com/ears) patterns. **This file is the
single source of truth** — `spec-req` and `spec-sync` quote it; defer here when
authoring or checking a requirement. Choose the pattern that matches the
requirement's *activation*:

- **Ubiquitous** (no keyword): `The <system> shall <response>` — always-active
  constraints.
- **State-Driven** (`While`): `While <precondition>, the <system> shall
  <response>` — behavior depends on system state.
- **Event-Driven** (`When`): `When <trigger>, the <system> shall <response>` —
  triggered by a discrete event.
- **Optional** (`Where`): `Where <feature is included>, the <system> shall
  <response>` — configurable features.
- **Unwanted Behaviour** (`If…then`): `If <condition>, then the <system> shall
  <response>` — error handling and edge cases.

Patterns combine: `While <state>, when <trigger>, the <system> shall
<response>`.
