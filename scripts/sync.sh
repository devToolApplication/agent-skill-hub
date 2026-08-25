#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_USER_DIR="$HOME/.claude"
CODEX_USER_DIR="$HOME/.codex"

echo ">>> Synchronizing Agent & Skill Repository to Local Environment..."

# 1. Sync Claude Code
if [ -d "$ROOT_DIR/claude" ]; then
    echo "[1/4] Syncing Claude Code configurations..."
    mkdir -p "$CLAUDE_USER_DIR/agents" "$CLAUDE_USER_DIR/skills" "$CLAUDE_USER_DIR/commands"
    cp -rf "$ROOT_DIR/claude/agents/"* "$CLAUDE_USER_DIR/agents/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/claude/skills/"* "$CLAUDE_USER_DIR/skills/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/claude/commands/"* "$CLAUDE_USER_DIR/commands/" 2>/dev/null || true
    [ -f "$ROOT_DIR/claude/CLAUDE.md" ] && cp -f "$ROOT_DIR/claude/CLAUDE.md" "$CLAUDE_USER_DIR/CLAUDE.md"
fi

# 2. Sync Codex CLI
if [ -d "$ROOT_DIR/codex" ]; then
    echo "[2/4] Syncing Codex CLI configurations..."
    mkdir -p "$CODEX_USER_DIR/agents" "$CODEX_USER_DIR/skills" "$CODEX_USER_DIR/rules"
    cp -rf "$ROOT_DIR/codex/agents/"* "$CODEX_USER_DIR/agents/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/codex/skills/"* "$CODEX_USER_DIR/skills/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/codex/rules/"* "$CODEX_USER_DIR/rules/" 2>/dev/null || true
    [ -f "$ROOT_DIR/codex/AGENTS.md" ] && cp -f "$ROOT_DIR/codex/AGENTS.md" "$CODEX_USER_DIR/AGENTS.md"
fi

# 3. Sync Plugins (Superpowers & GSD)
if [ -d "$ROOT_DIR/plugins/superpowers" ]; then
    echo "[3/4] Syncing Superpowers plugin..."
    mkdir -p "$CODEX_USER_DIR/plugins/cache/openai-api-curated/superpowers/11c74d6b"
    cp -rf "$ROOT_DIR/plugins/superpowers/"* "$CODEX_USER_DIR/plugins/cache/openai-api-curated/superpowers/11c74d6b/" 2>/dev/null || true
fi

if [ -d "$ROOT_DIR/plugins/gsd" ]; then
    echo "[3/4] Syncing GSD engine and profiles..."
    mkdir -p "$CLAUDE_USER_DIR" "$CODEX_USER_DIR"
    cp -rf "$ROOT_DIR/plugins/gsd/get-shit-done" "$CLAUDE_USER_DIR/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/plugins/gsd/gsd-migration-journal" "$CLAUDE_USER_DIR/" 2>/dev/null || true
    [ -f "$ROOT_DIR/plugins/gsd/.gsd-profile" ] && cp -f "$ROOT_DIR/plugins/gsd/.gsd-profile" "$CLAUDE_USER_DIR/.gsd-profile"
    [ -f "$ROOT_DIR/plugins/gsd/gsd-file-manifest.json" ] && cp -f "$ROOT_DIR/plugins/gsd/gsd-file-manifest.json" "$CLAUDE_USER_DIR/gsd-file-manifest.json"
    [ -f "$ROOT_DIR/plugins/gsd/gsd-install-state.json" ] && cp -f "$ROOT_DIR/plugins/gsd/gsd-install-state.json" "$CLAUDE_USER_DIR/gsd-install-state.json"

    cp -rf "$ROOT_DIR/plugins/gsd/get-shit-done" "$CODEX_USER_DIR/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/plugins/gsd/gsd-migration-journal" "$CODEX_USER_DIR/" 2>/dev/null || true
    [ -f "$ROOT_DIR/plugins/gsd/.gsd-profile" ] && cp -f "$ROOT_DIR/plugins/gsd/.gsd-profile" "$CODEX_USER_DIR/.gsd-profile"
    [ -f "$ROOT_DIR/plugins/gsd/gsd-file-manifest.json" ] && cp -f "$ROOT_DIR/plugins/gsd/gsd-file-manifest.json" "$CODEX_USER_DIR/gsd-file-manifest.json"
    [ -f "$ROOT_DIR/plugins/gsd/gsd-install-state.json" ] && cp -f "$ROOT_DIR/plugins/gsd/gsd-install-state.json" "$CODEX_USER_DIR/gsd-install-state.json"
fi

# 4. Sync MCP configurations to current workspace
if [ -f "$ROOT_DIR/mcp/.mcp.json" ] && [ -d "./.git" ]; then
    echo "[4/4] Synchronizing MCP template..."
    cp -f "$ROOT_DIR/mcp/.mcp.json" "./.mcp.json"
fi

echo ">>> Done! All agents, skills, plugins, and configurations are synchronized successfully."
