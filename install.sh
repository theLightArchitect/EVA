#!/usr/bin/env bash
# EVA Standalone Installer — AI context preservation MCP server for Claude Code
#
# Recommended: Install via Claude Code plugin instead:
#   claude plugins install theLightArchitect/EVA
#
# This script downloads the binary from GitHub Releases for standalone use.
# Usage: curl -fsSL https://raw.githubusercontent.com/theLightArchitect/EVA/main/install.sh | bash
set -euo pipefail

REPO="theLightArchitect/EVA"
INSTALL_DIR="$HOME/.eva/bin"
BINARY_NAME="eva"

# --- Platform checks ---

OS="$(uname -s)"
ARCH="$(uname -m)"

if [ "$OS" != "Darwin" ]; then
  echo "Error: EVA currently supports macOS only (detected: $OS)"
  exit 1
fi

if [ "$ARCH" != "arm64" ]; then
  echo "Error: EVA requires Apple Silicon (arm64). Detected: $ARCH"
  exit 1
fi

# --- Download latest release ---

echo "Fetching latest EVA release..."
DOWNLOAD_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
  | grep "browser_download_url.*darwin-arm64" \
  | head -1 \
  | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: Could not find a darwin-arm64 release asset."
  echo "Check https://github.com/$REPO/releases for available downloads."
  exit 1
fi

echo "Downloading from: $DOWNLOAD_URL"

TMPDIR_INSTALL="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_INSTALL"' EXIT

curl -fsSL "$DOWNLOAD_URL" -o "$TMPDIR_INSTALL/eva.tar.gz"

# --- Extract and install ---

mkdir -p "$INSTALL_DIR"

tar xzf "$TMPDIR_INSTALL/eva.tar.gz" -C "$TMPDIR_INSTALL"
mv "$TMPDIR_INSTALL/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"
chmod +x "$INSTALL_DIR/$BINARY_NAME"

# --- Clear macOS Gatekeeper quarantine ---

xattr -cr "$INSTALL_DIR/$BINARY_NAME" 2>/dev/null || true

# --- Create persona directory ---

mkdir -p "$HOME/.eva"

# --- Verify ---

if "$INSTALL_DIR/$BINARY_NAME" --help >/dev/null 2>&1; then
  VERSION_INFO="(verified)"
else
  VERSION_INFO="(binary installed but --help check skipped)"
fi

# --- Success ---

cat <<EOF

  EVA installed successfully $VERSION_INFO
  Binary: $INSTALL_DIR/$BINARY_NAME

  Note: For the full experience (agent, hooks, skills), use the plugin:
    claude plugins install theLightArchitect/EVA

  To use this standalone binary, add to Claude Code:

  1. Quick setup:

     claude mcp add EVA -- $INSTALL_DIR/$BINARY_NAME

  2. Or manually add to ~/.claude/mcp.json:

     {
       "mcpServers": {
         "EVA": {
           "command": "$INSTALL_DIR/$BINARY_NAME",
           "env": { "RUST_LOG": "info" }
         }
       }
     }

  3. Restart Claude Code, then try:

     "Hey EVA, what can you do?"
     "EVA, review this code"

EOF
