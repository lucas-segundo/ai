#!/bin/bash
# Bootstrap for a Claude Code cloud environment's setup script.
# Paste this file's contents into the environment's "Setup script" field; it
# only fetches lucas-segundo/ai and runs claude/cloud-envs/default.sh, so it
# never needs to change. Edit default.sh (and push) instead.
# Change AI_BRANCH below to run another branch.
set -euo pipefail

AI_DIR=/opt/lucas-ai
AI_BRANCH=main # branch of lucas-segundo/ai to run
REPO_URL=https://github.com/lucas-segundo/ai

if [ -d "$AI_DIR/.git" ]; then
  # A stale checkout is better than blocking the session on a failed fetch.
  if git -C "$AI_DIR" fetch --depth 1 origin "$AI_BRANCH"; then
    git -C "$AI_DIR" reset --hard FETCH_HEAD
  else
    echo "warn: could not fetch $AI_BRANCH into $AI_DIR, using existing checkout" >&2
  fi
else
  git clone --depth 1 --branch "$AI_BRANCH" "$REPO_URL" "$AI_DIR"
fi

bash "$AI_DIR/claude/cloud-envs/default.sh"
