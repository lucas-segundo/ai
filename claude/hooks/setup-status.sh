#!/bin/bash
# SessionStart hook: if the cloud env setup failed, print it into the session.
STATUS="${SETUP_STATUS_FILE:-/tmp/setup-status}"
[ -f "$STATUS" ] || exit 0
exit_code="$(sed -n 's/^exit=//p' "$STATUS")"
[ "$exit_code" = 0 ] && exit 0
log="$(sed -n 's/^log=//p' "$STATUS")"
echo "CLOUD ENV SETUP FAILED. Use the debugging-cloud-setup skill and tell the user what happened."
cat "$STATUS"
echo "-- last log lines ($log)"
tail -n 40 "$log" 2>/dev/null
