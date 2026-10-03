#!/bin/bash
# Wrapper for cloud env scripts. Usage: run.sh [env-name]  (default: default)
# Runs claude/cloud-envs/<env-name>.sh, logs everything to $SETUP_LOG and writes
# $SETUP_STATUS_FILE. Always exits 0 so the session still starts on failure; the
# SessionStart hook then shows the failure and the debugging-cloud-setup skill explains it.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NAME="${1:-default}"
LOG="${SETUP_LOG:-/tmp/setup.log}"
STATUS="${SETUP_STATUS_FILE:-/tmp/setup-status}"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
export SETUP_LOG=/dev/null  # setup.sh would duplicate our log

echo "== run $NAME $(date -u +%FT%TZ)" >>"$LOG"

# Install the debug tooling first, so it exists even if the env script fails.
mkdir -p "$CLAUDE_HOME/skills" "$CLAUDE_HOME/hooks"
cp -r "$ROOT/claude/skills/debugging-cloud-setup" "$CLAUDE_HOME/skills/"
cp "$ROOT/claude/hooks/setup-status.sh" "$CLAUDE_HOME/hooks/"
python3 - "$CLAUDE_HOME" <<'PY' >>"$LOG" 2>&1 || echo "warn: hook install failed" >>"$LOG"
import json, os, sys
home = sys.argv[1]
path = os.path.join(home, "settings.json")
cfg = json.load(open(path)) if os.path.exists(path) else {}
cmd = f"bash {home}/hooks/setup-status.sh"
groups = cfg.setdefault("hooks", {}).setdefault("SessionStart", [])
if not any(h.get("command") == cmd for g in groups for h in g.get("hooks", [])):
    groups.append({"hooks": [{"type": "command", "command": cmd}]})
json.dump(cfg, open(path, "w"), indent=2)
PY

script="$ROOT/claude/cloud-envs/$NAME.sh"
if [ -f "$script" ]; then
  bash "$script" 2>&1 | tee -a "$LOG"
  rc=${PIPESTATUS[0]}
else
  echo "error: env '$NAME' not found at $script" | tee -a "$LOG"
  rc=127
fi

{
  echo "env=$NAME"
  echo "exit=$rc"
  echo "log=$LOG"
  echo "at=$(date -u +%FT%TZ)"
} >"$STATUS"
exit 0
