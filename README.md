# sextant

AI-assisted, "best-effort" SPEC-driven development.

A Claude Code plugin that writes requirements first, reconciles them with the code either direction, and graduates the winning candidate from the spec-driven exploration tree to **the** implementation at the repo root.

A sextant is the precision nautical instrument used to fix position against external references — here, the external reference is `SPEC.md`, and the position is the implementation's coverage of it.

End-user docs: https://chris-peterson.github.io/sextant

Working on sextant — repo layout, the `just` targets, and the conventions this
codebase holds itself to — is in [AGENTS.md](./AGENTS.md), the same file the
agents read. Requirements are in [SPEC.md](./SPEC.md), their coverage in
[STATUS.md](./STATUS.md).

## License

MIT
