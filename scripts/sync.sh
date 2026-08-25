#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_USER_DIR="$HOME/.claude"
CODEX_USER_DIR="$HOME/.codex"

echo ">>> Synchronizing Agent & Skill Repository to Local Environment..."

# 1. Sync Claude Code
if [ -d "$ROOT_DIR/claude" ]; then
    echo "[1/3] Syncing Claude Code configurations..."
    mkdir -p "$CLAUDE_USER_DIR/agents" "$CLAUDE_USER_DIR/skills" "$CLAUDE_USER_DIR/commands"
    cp -rf "$ROOT_DIR/claude/agents/"* "$CLAUDE_USER_DIR/agents/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/claude/skills/"* "$CLAUDE_USER_DIR/skills/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/claude/commands/"* "$CLAUDE_USER_DIR/commands/" 2>/dev/null || true
    [ -f "$ROOT_DIR/claude/CLAUDE.md" ] && cp -f "$ROOT_DIR/claude/CLAUDE.md" "$CLAUDE_USER_DIR/CLAUDE.md"
fi

# 2. Sync Codex CLI
if [ -d "$ROOT_DIR/codex" ]; then
    echo "[2/3] Syncing Codex CLI configurations..."
    mkdir -p "$CODEX_USER_DIR/agents" "$CODEX_USER_DIR/skills" "$CODEX_USER_DIR/rules"
    cp -rf "$ROOT_DIR/codex/agents/"* "$CODEX_USER_DIR/agents/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/codex/skills/"* "$CODEX_USER_DIR/skills/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/codex/rules/"* "$CODEX_USER_DIR/rules/" 2>/dev/null || true
    [ -f "$ROOT_DIR/codex/AGENTS.md" ] && cp -f "$ROOT_DIR/codex/AGENTS.md" "$CODEX_USER_DIR/AGENTS.md"
fi

# 3. Sync MCP configurations to current workspace
if [ -f "$ROOT_DIR/mcp/.mcp.json" ] && [ -d "./.git" ]; then
    echo "[3/3] Synchronizing MCP template..."
    cp -f "$ROOT_DIR/mcp/.mcp.json" "./.mcp.json"
fi

echo ">>> Done! All agents, skills, and configurations are synchronized successfully."
