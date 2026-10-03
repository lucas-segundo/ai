---
name: debugging-cloud-setup
description: Explains why the cloud environment setup script failed. Use when the session starts with "CLOUD ENV SETUP FAILED", or when skills are missing in a cloud session, or the user asks why setup failed.
---

# Debugging cloud setup

1. Read `/tmp/setup-status` (`env`, `exit`, `log`, `at`) and the full log (`/tmp/setup.log`).
2. Find the first `error:` line. Later errors are usually consequences.
3. Check the usual causes:
   - `SETUP_GITHUB_TOKEN set:` is empty in the preflight: the env variable is missing, misspelled, or the env was edited after this session started. Tell the user to add it and start a new session.
   - `error: ... cannot clone` or `Authentication failed` / `not found`: token expired, or it lacks read access to `lucas-segundo/skills`.
   - `github.com reachable: no`: network policy or proxy blocks GitHub.
   - `claude: missing`: the CLI is not installed (only matters for plugin configs).
   - `env '<name>' not found`: wrong env name or the ai repo branch lacks the file.
4. To dig deeper, re-run with a trace: `SETUP_DEBUG=1 bash <ai repo>/claude/cloud-envs/run.sh <env>`. Never print the token value.
5. Reply in a few lines: what failed, why, and the exact fix. Do not edit the user's repos unless asked.
