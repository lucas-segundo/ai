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

`claude/cloud-envs/<name>.sh` is what a cloud environment runs. Paste the
contents of [`claude/cloud-envs/setup-script.sh`](claude/cloud-envs/setup-script.sh)
into the environment's setup script; it clones this repo to `/opt/lucas-ai` (or
pulls it if already there) and runs `claude/cloud-envs/default.sh`, so it never
needs to change. Change `AI_BRANCH` in the script to run another
branch (default `main`).
