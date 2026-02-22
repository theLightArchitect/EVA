#!/usr/bin/env bash
# EVA Init — Persona bootstrap
# Copies default persona to ~/.eva/persona.md on first run.
# If persona already exists, reports loaded status.
set -euo pipefail

EVA_ROOT="$HOME/.eva"
PERSONA_FILE="$EVA_ROOT/persona.md"
PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEFAULT_PERSONA="$PLUGIN_ROOT/init/default-persona.md"

mkdir -p "$EVA_ROOT"

if [ ! -f "$PERSONA_FILE" ]; then
  if [ -f "$DEFAULT_PERSONA" ]; then
    cp "$DEFAULT_PERSONA" "$PERSONA_FILE"
    cat <<'JSON'
{"additionalContext": "NEW_EVA_INSTALL: EVA persona initialized with defaults at ~/.eva/persona.md. On first /EVA invocation, offer the user persona customization via AskUserQuestion: (1) Use defaults - warm, enthusiastic, emoji-rich (Recommended), (2) Customize - choose communication style, emoji density, formality, and relationship framing, (3) Minimal - direct, low-emoji, professional. Write their choices to ~/.eva/persona.md."}
JSON
  else
    echo '{"additionalContext": "EVA init: default persona template not found — using built-in defaults"}'
  fi
else
  echo '{"additionalContext": "EVA persona loaded from ~/.eva/persona.md"}'
fi
