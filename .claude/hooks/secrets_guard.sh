#!/usr/bin/env bash
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // .tool_input.new_str // empty')
[[ "$FILE" == *.dart ]] || exit 0
if echo "$CONTENT" | grep -Eiq "api[_]?key[[:space:]]*=[[:space:]]*['\"]"; then
  echo "API_KEY must come from --dart-define, never hardcoded in source." >&2
  exit 2
fi
if echo "$CONTENT" | grep -Eiq "(print|debugPrint|log)\(.*api[_]?key"; then
  echo "Do not print API_KEY to logs." >&2
  exit 2
fi
exit 0
