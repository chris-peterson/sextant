Agent instructions live in [AGENTS.md](./AGENTS.md).

@AGENTS.md

## Claude Code

- Mount the working tree as a plugin to exercise the skills: `claude --plugin-dir .`
  Then `/sextant:spec-req` and the rest resolve against the checkout rather than
  the installed version.
