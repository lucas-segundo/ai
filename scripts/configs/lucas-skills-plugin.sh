#!/bin/bash
# Clone github.com/lucas-segundo/skills and install its lucas-skills plugin.
# The skills repo is private: needs SETUP_GITHUB_TOKEN (see setup.sh).
# Exits non-zero on the first failing step so setup.sh can report it.
set -euo pipefail

SKILLS_DIR=/home/user/skills

if [ -z "${SETUP_GITHUB_TOKEN:-}" ]; then
  echo "error: SETUP_GITHUB_TOKEN not set; cannot clone private lucas-segundo/skills" >&2
  exit 1
fi

if [ ! -d "$SKILLS_DIR/.git" ]; then
  git clone --depth 1 https://github.com/lucas-segundo/skills "$SKILLS_DIR"
else
  git -C "$SKILLS_DIR" pull --ff-only
fi

claude plugin marketplace add lucas-segundo/skills
claude plugin install lucas-skills@lucas-plugins --scope user

# Verify instead of trusting exit codes
plugins="$(claude plugin list)"
grep -q lucas-skills <<<"$plugins" || {
  echo "error: lucas-skills not listed after install" >&2
  exit 1
}
