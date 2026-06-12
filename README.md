# sextant

AI-assisted, "best-effort" SPEC-driven development.

A Claude Code plugin that writes requirements first, audits implementations against them, and graduates the winning candidate from the spec-driven exploration tree to **the** implementation at the repo root.

A sextant is the precision nautical instrument used to fix position against external references — here, the external reference is `SPEC.md`, and the position is the implementation's coverage of it.

End-user docs: https://chris-peterson.github.io/sextant

## Repo layout

```text
.claude-plugin/plugin.json   plugin manifest
skills/spec-req/             /sextant:spec-req — look up, trace, create spec requirements, and bootstrap a new spec (init)
skills/spec-status/          /sextant:spec-status — refresh STATUS.md to match current coverage (lightweight, automatable ledger writer)
skills/spec-sync/            /sextant:spec-sync — full-domain coverage + drift analysis of SPEC.md vs code; one-way --to-spec / --to-source reconciliation
skills/impl-new/             /sextant:impl-new — scaffold a new candidate implementation under implementations/<v>/<slug>/
skills/impl-select/          /sextant:impl-select — select the winning candidate from implementations/ and graduate it to the repo root
docs/                        end-user docs site (docsify, GitHub Pages)
```

## Try the plugin locally

```bash
claude --plugin-dir .
```

Launches Claude Code with the working tree mounted as a plugin.

## Docs

```bash
just docs
```

Serves the docsify site at `docs/` locally. Deployed to GitHub Pages on push to `main` via `.github/workflows/deploy-docs.yml`.

## License

MIT
