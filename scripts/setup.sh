#!/bin/bash
# Entry point for Claude Code cloud env setup.
# Runs each enabled config from scripts/configs/<name>.sh in order.
# Usage: setup.sh            # run all enabled configs
#        setup.sh name ...   # run only the given configs

# Enabled configs, in execution order. Comment out a line to disable it.
CONFIGS=(
  lucas-skills-plugin
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configs"

[ "$#" -gt 0 ] && CONFIGS=("$@")

for name in "${CONFIGS[@]}"; do
  script="$CONFIG_DIR/$name.sh"
  if [ ! -f "$script" ]; then
    echo "warn: config '$name' not found at $script"
    continue
  fi
  echo "==> $name"
  bash "$script" || echo "warn: config '$name' failed"
done
exit 0
