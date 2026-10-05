#!/bin/bash
# Default cloud env: what runs on every cloud session setup.
# The env's setup script only clones this repo and runs this file, so edit here
# (and push) instead of editing the Claude environment config.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_FILE="${SETUP_LOG:-/tmp/setup.log}"
export SETUP_LOG="$LOG_FILE"

# If setup fails, still let the session start: a failing env setup script blocks
# the session, so there is no agent to ask what went wrong. Instead leave a
# user-level CLAUDE.md that tells the agent to read the log and report.
if ! bash "$ROOT/scripts/setup.sh" lucas-skills-plugin; then
  mkdir -p "$HOME/.claude"
  {
    echo "# Cloud env setup FAILED"
    echo
    echo "The env setup script (lucas-segundo/ai, claude/cloud-envs/default.sh) failed."
    echo "Before anything else, read $LOG_FILE, tell the user what went wrong and"
    echo "propose a fix in lucas-segundo/ai. Last log lines:"
    echo
    echo '```'
    tail -n 40 "$LOG_FILE" 2>/dev/null || true
    echo '```'
  } >> "$HOME/.claude/CLAUDE.md"
  echo "warn: setup failed, wrote failure note to $HOME/.claude/CLAUDE.md" >&2
fi
exit 0
