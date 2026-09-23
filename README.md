# sextant

**sextant: manages drift between spec and code.**

![Claude Code](https://img.shields.io/badge/Claude%20Code-%23D97757.svg?logo=claudecode&logoColor=white)
![GitHub top language](https://img.shields.io/github/languages/top/chris-peterson/sextant)
![GitHub Release](https://img.shields.io/github/v/release/chris-peterson/sextant?sort=semver&display_name=release&logo=github&label=latest)

AI-assisted, best-effort spec-driven development: keep requirements in source control, track how the code covers them, reconcile the two either direction.

A sextant is the precision nautical instrument used to fix position against external references. Here the external reference is `SPEC.md`, and the position is the implementation's coverage of it.

End-user docs: https://chris-peterson.github.io/sextant

Working on sextant (repo layout, the `just` targets, and the conventions this
codebase holds itself to) is in [AGENTS.md](./AGENTS.md), the same file the
agents read. Requirements are in [SPEC.md](./SPEC.md), their coverage in
[STATUS.md](./STATUS.md).

## License

MIT
