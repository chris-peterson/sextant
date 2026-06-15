#!/usr/bin/env bash
# Copy each skills/*/SKILL.md into docs/skills/<name>.md, stripping the YAML
# frontmatter (the leading --- ... --- block). Used by `just docs` and by the
# GitHub Pages deploy workflow so the docs site renders each skill's source
# of truth directly, with no parallel doc artifact to maintain.
#
# Also copy the repo's own SPEC.md and STATUS.md into docs/ so the "Sextant²"
# page renders them live — the same render-the-source pattern. The
# copies are gitignored; this script is the only thing that writes them.

set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p docs/skills
for skill in skills/*/SKILL.md; do
  name=$(basename "$(dirname "$skill")")
  awk '/^---$/{fm++; next} fm>=2' "$skill" > "docs/skills/$name.md"
done

cp SPEC.md STATUS.md docs/

# Render the suite: block to docs/suite.json for the live session preview.
python3 scripts/gen-suite-json.py
