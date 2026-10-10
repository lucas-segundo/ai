#!/bin/bash
# Bootstrap for a Claude Code cloud environment's setup script.
# Paste this file's contents into the environment's "Setup script" field; it
# only fetches lucas-segundo/ai and runs claude/cloud-envs/default.sh, so it
# never needs to change. Edit default.sh (and push) instead.
set -euo pipefail

AI_DIR=/opt/lucas-ai
REPO_URL=https://github.com/lucas-segundo/ai

if [ -d "$AI_DIR/.git" ]; then
  # A stale checkout is better than blocking the session on a failed pull.
  git -C "$AI_DIR" pull --ff-only || echo "warn: could not update $AI_DIR, using existing checkout" >&2
else
  git clone --depth 1 "$REPO_URL" "$AI_DIR"
fi

bash "$AI_DIR/claude/cloud-envs/default.sh"
