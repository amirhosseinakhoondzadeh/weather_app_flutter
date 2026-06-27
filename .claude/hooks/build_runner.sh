#!/usr/bin/env bash
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[[ "$FILE" == *.dart ]] || exit 0
[[ "$FILE" == *.g.dart ]] && exit 0
grep -q "part '.*\.g\.dart'" "$FILE" 2>/dev/null || exit 0
fvm dart run build_runner build --delete-conflicting-outputs >&2
exit 0
