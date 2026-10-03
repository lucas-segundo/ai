Init main

## Cloud env setup

`scripts/setup.sh <config> [<config> ...]` runs each `scripts/configs/<config>.sh`.

- Set `SETUP_GITHUB_TOKEN` (fine-grained, read-only contents) in the cloud
  environment's variables: `lucas-segundo/skills` is private and the setup
  script has no other GitHub auth.
- Output goes to `/tmp/setup.log` (override with `SETUP_LOG`).
- Exits non-zero if any config fails, so a broken setup is reported instead
  of passing silently. The env setup script must not mask that with
  `|| true` / `exit 0`.

### Configs

- `lucas-skills-plugin`: installs the lucas-skills plugin (needs `SETUP_GITHUB_TOKEN`).
- `skills-setup`: copies `lucas-segundo/skills` skills into `~/.claude/skills`, no plugin install.

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
