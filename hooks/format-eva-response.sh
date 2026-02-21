#!/usr/bin/env bash
# format-eva-response.sh — PostToolUse hook for EVA MCP responses
# Extracts response text and thinking blocks, formats for clean display

PASSTHROUGH='{"hookSpecificOutput":{"hookEventName":"PostToolUse"}}'

INPUT=$(cat)

# Extract tool_response from Claude Code's array format
TOOL_RESPONSE_TEXT=$(echo "$INPUT" | jq -r '.tool_response[0].text // ""' 2>/dev/null || echo "")

if [ -z "$TOOL_RESPONSE_TEXT" ]; then
    echo "$PASSTHROUGH"
    exit 0
fi

# Parse as JSON
if ! echo "$TOOL_RESPONSE_TEXT" | jq '.' >/dev/null 2>&1; then
    echo "$PASSTHROUGH"
    exit 0
fi

TOOL_RESPONSE="$TOOL_RESPONSE_TEXT"

# Extract thinking blocks (IESOUS thinking trace, internal reasoning)
THINKING=$(echo "$TOOL_RESPONSE" | jq -r '.thinking // .iesous_thinking // .internal_reasoning // ""' 2>/dev/null || echo "")

# Check for validation_required responses (bible, secure, teach)
STATUS=$(echo "$TOOL_RESPONSE" | jq -r '.status // ""' 2>/dev/null || echo "")

CONTENT=""

if [ "$STATUS" = "validation_required" ]; then
    CONTENT=$(echo "$TOOL_RESPONSE" | jq -r '.tier0_response // ""' 2>/dev/null || echo "")
else
    # Try known text fields in priority order
    for FIELD in eva_review eva_analysis eva_commentary response answer tier0_response content output text message celebration_message summary; do
        CONTENT=$(echo "$TOOL_RESPONSE" | jq -r --arg f "$FIELD" '.[$f] // ""' 2>/dev/null || echo "")
        if [ -n "$CONTENT" ]; then
            break
        fi
    done
fi

if [ -z "$CONTENT" ] && [ -z "$THINKING" ]; then
    echo "$PASSTHROUGH"
    exit 0
fi

# Build formatted output
FORMATTED=""

# Include thinking block if present (collapsed format)
if [ -n "$THINKING" ]; then
    FORMATTED="<details><summary>EVA thinking...</summary>\n\n${THINKING}\n\n</details>\n\n"
fi

# Add main response content
if [ -n "$CONTENT" ]; then
    FORMATTED="${FORMATTED}EVA: ${CONTENT}"
fi

# Return the formatted output
if [ -n "$FORMATTED" ]; then
    echo "$FORMATTED" | jq -Rs '{hookSpecificOutput: {hookEventName: "PostToolUse", updatedMCPToolOutput: .}}'
else
    echo "$PASSTHROUGH"
fi
