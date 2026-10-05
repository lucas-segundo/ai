#!/bin/bash
# Default cloud env: what runs on every cloud session setup.
# The env's setup script only clones this repo and runs this file, so edit here
# (and push) instead of editing the Claude environment config.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

bash "$ROOT/scripts/setup.sh" lucas-skills-plugin
