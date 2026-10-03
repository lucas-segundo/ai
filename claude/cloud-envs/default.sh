#!/bin/bash
# Default cloud env: what runs on every cloud session setup.
# The env's setup script only clones this repo and runs run.sh, so edit here
# (and push) instead of editing the Claude environment config.
# Set SETUP_DEBUG=1 for a shell trace.
set -euo pipefail
[ "${SETUP_DEBUG:-}" = 1 ] && set -x

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "-- preflight"
echo "SETUP_GITHUB_TOKEN set: ${SETUP_GITHUB_TOKEN:+yes}"
echo "git: $(git --version 2>&1)"
echo "claude: $(claude --version 2>&1 || echo missing)"
echo "github.com reachable: $(git ls-remote https://github.com/lucas-segundo/ai HEAD >/dev/null 2>&1 && echo yes || echo no)"

bash "$ROOT/scripts/setup.sh" skills-setup
