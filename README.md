Init main

## Cloud env setup

`scripts/setup.sh <config> [<config> ...]` runs each `scripts/configs/<config>.sh`.

- `SETUP_GITHUB_TOKEN` is optional now that the repos are public. Set it
  (fine-grained, read-only contents) only if a config needs a private repo.
- Output goes to `/tmp/setup.log` (override with `SETUP_LOG`).
- Exits non-zero if any config fails. `claude/cloud-envs/default.sh` catches
  that, appends a failure note (with the log tail) to `~/.claude/CLAUDE.md` and
  exits 0, so the session still starts and the agent can read `/tmp/setup.log`
  and explain what broke. Remove the `if` in `default.sh` to make a failure
  block the session instead.

### Configs

- `lucas-skills-plugin`: installs the lucas-skills plugin.
- `mattpocock-skills-plugin`: installs the mattpocock-skills plugin from
  [mattpocock/skills](https://github.com/mattpocock/skills).

### Cloud envs

`claude/cloud-envs/<name>.sh` is what a cloud environment runs. Paste this bootstrap in the environment's setup script; it never needs to change:

```bash
#!/bin/bash
set -euo pipefail
AI_DIR=/opt/lucas-ai
if [ -d "$AI_DIR/.git" ]; then
  git -C "$AI_DIR" pull --ff-only
else
  git clone --depth 1 https://github.com/lucas-segundo/ai "$AI_DIR"
fi
bash "$AI_DIR/claude/cloud-envs/default.sh"
```

## Reusable workflows

`.github/workflows/claude.yml` runs Claude Code when `@claude` is mentioned
in an issue, PR comment or review. A repo uses it with a caller that keeps the
triggers and grants the token permissions (the shared workflow can only narrow
them):

```yaml
name: Claude Code

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [opened, assigned]
  pull_request_review:
    types: [submitted]

jobs:
  claude:
    permissions:
      contents: read
      pull-requests: write
      issues: read
      id-token: write
      actions: read
    uses: lucas-segundo/ai/.github/workflows/claude.yml@main
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
```

The calling repo needs the `CLAUDE_CODE_OAUTH_TOKEN` secret.
