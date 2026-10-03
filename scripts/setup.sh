#!/bin/bash
# Entry point for Claude Code cloud env setup.
# Runs each given config from scripts/configs/<name>.sh in order.
# Usage: setup.sh name [name ...]

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
