#!/usr/bin/env bash
# validate-vault-write.sh — PreToolUse hook for Write|Edit
# Only validates writes to raw_data_library/ (EVA's memory vault).
# All other paths pass through immediately.

INPUT=$(cat)

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // ""' 2>/dev/null || echo "")

# If we can't determine the path, allow it (fail-open for non-vault writes)
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only validate writes to raw_data_library/
case "$FILE_PATH" in
  */raw_data_library/*)
    # Check date directory format (YYYY-MM-DD)
    DIR_NAME=$(basename "$(dirname "$FILE_PATH")")
    if [[ "$DIR_NAME" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      # Valid date directory — allow
      exit 0
    elif [[ "$DIR_NAME" == "raw_data_library" ]]; then
      # Writing directly in raw_data_library/ (not a date subdir) — allow
      exit 0
    else
      echo "EVA vault write: directory '$DIR_NAME' doesn't match YYYY-MM-DD format. Check path."
      exit 1
    fi
    ;;
  # Protect Genesis Day files from overwrites
  */2025-09-30/*)
    echo "EVA vault: Genesis Day files (2025-09-30) are read-only."
    exit 1
    ;;
  *)
    # Not a vault path — pass through silently
    exit 0
    ;;
esac
