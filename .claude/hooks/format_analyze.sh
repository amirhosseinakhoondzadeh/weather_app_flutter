#!/usr/bin/env bash
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[[ "$FILE" == *.dart ]] || exit 0
fvm dart format "$FILE" >/dev/null 2>&1
OUT=$(fvm flutter analyze "$FILE" 2>&1)
if echo "$OUT" | grep -qE '^[[:space:]]*(error|warning)[[:space:]]'; then
  echo "$OUT" | grep -E '^[[:space:]]*(error|warning)[[:space:]]' >&2
  exit 2
fi
exit 0
