# shipyard runs from its git ref, with no checkout and no install. CI is the
# writer for what lands; these recipes are for seeing the projection first.
shipyard := "uvx --from 'git+https://github.com/chris-peterson/shipyard@v2' shipyard"

default:
    @just --list

# project source into the generated artifacts (describe, plugin.json, docs)
generate:
    {{shipyard}} generate

# read what the projection job would commit, without keeping it; `git restore .` discards
check:
    {{shipyard}} generate
    git --no-pager diff --stat

# render the docsify docs site and serve it locally
docs:
    {{shipyard}} build-docs
    docsify serve docs --open

# regenerate .claude-plugin/plugin.json from plugin.yml (the canonical descriptor)
plugin-json:
    {{shipyard}} gen-plugin-json

# resync plugin.yml suite.describe from the skills sources
describe:
    {{shipyard}} gen-describe
