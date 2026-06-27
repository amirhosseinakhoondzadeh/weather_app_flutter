#!/usr/bin/env bash
INPUT=$(cat)
[ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ] && exit 0
if ! OUT=$(fvm flutter test 2>&1); then
  echo "tests are red - keep going until the suite is green:" >&2
  echo "$OUT" | tail -n 25 >&2
  exit 2
fi
exit 0
