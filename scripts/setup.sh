#!/bin/bash
# Entry point for Claude Code cloud env setup.
# Runs each given config from scripts/configs/<name>.sh in order.
# Usage: setup.sh name [name ...]
# Set SETUP_GITHUB_TOKEN (read-only, fine-grained) to let configs clone private GitHub repos.

# Authenticate github.com git calls for this run only; the token is passed via
# env to child processes and never written to ~/.gitconfig. Appended after any
# existing GIT_CONFIG_* entries so it takes precedence without dropping them.
if [ -n "$SETUP_GITHUB_TOKEN" ]; then
  n="${GIT_CONFIG_COUNT:-0}"
  export "GIT_CONFIG_KEY_$n=url.https://x-access-token:${SETUP_GITHUB_TOKEN}@github.com/.insteadOf"
  export "GIT_CONFIG_VALUE_$n=https://github.com/"
  export GIT_CONFIG_COUNT=$((n + 1))
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configs"

if [ "$#" -eq 0 ]; then
  echo "usage: $0 name [name ...]"
  echo "available configs:"
  for f in "$CONFIG_DIR"/*.sh; do [ -e "$f" ] && echo "  $(basename "$f" .sh)"; done
  exit 0
fi

for name in "$@"; do
  script="$CONFIG_DIR/$name.sh"
  if [ ! -f "$script" ]; then
    echo "warn: config '$name' not found at $script"
    continue
  fi
  echo "==> $name"
  bash "$script" || echo "warn: config '$name' failed"
done
exit 0
