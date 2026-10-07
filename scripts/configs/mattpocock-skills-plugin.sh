#!/bin/bash
# Install the mattpocock-skills plugin from github.com/mattpocock/skills.
# Exits non-zero on the first failing step so setup.sh can report it.
set -euo pipefail

claude plugin marketplace add mattpocock/skills
claude plugin install mattpocock-skills@mattpocock --scope user

# Verify instead of trusting exit codes
plugins="$(claude plugin list)"
grep -q mattpocock-skills <<<"$plugins" || {
  echo "error: mattpocock-skills not listed after install" >&2
  exit 1
}
