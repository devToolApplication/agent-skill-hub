#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_USER_DIR="$HOME/.claude"
CODEX_USER_DIR="$HOME/.codex"

echo ">>> Synchronizing Agent & Skill Repository to Local Environment..."

# 1. Claude-specific content
if [ -d "$ROOT_DIR/claude" ]; then
    echo "[1/5] Syncing Claude-specific configurations..."
    mkdir -p "$CLAUDE_USER_DIR/agents" "$CLAUDE_USER_DIR/skills" "$CLAUDE_USER_DIR/commands"
    cp -rf "$ROOT_DIR/claude/agents/"* "$CLAUDE_USER_DIR/agents/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/claude/skills/"* "$CLAUDE_USER_DIR/skills/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/claude/commands/"* "$CLAUDE_USER_DIR/commands/" 2>/dev/null || true
    [ -f "$ROOT_DIR/claude/CLAUDE.md" ] && cp -f "$ROOT_DIR/claude/CLAUDE.md" "$CLAUDE_USER_DIR/CLAUDE.md"
fi

# 2. Codex-specific content
if [ -d "$ROOT_DIR/codex" ]; then
    echo "[2/5] Syncing Codex-specific configurations..."
    mkdir -p "$CODEX_USER_DIR/agents" "$CODEX_USER_DIR/skills" "$CODEX_USER_DIR/rules"
    cp -rf "$ROOT_DIR/codex/agents/"* "$CODEX_USER_DIR/agents/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/codex/skills/"* "$CODEX_USER_DIR/skills/" 2>/dev/null || true
    cp -rf "$ROOT_DIR/codex/rules/"* "$CODEX_USER_DIR/rules/" 2>/dev/null || true
    [ -f "$ROOT_DIR/codex/AGENTS.md" ] && cp -f "$ROOT_DIR/codex/AGENTS.md" "$CODEX_USER_DIR/AGENTS.md"
fi

# 3. Canonical shared skills override stale platform copies.
if [ -d "$ROOT_DIR/shared/skills" ]; then
    echo "[3/5] Installing canonical shared skills for Claude and Codex..."
    for skill_dir in "$ROOT_DIR/shared/skills/"*; do
        [ -d "$skill_dir" ] || continue
        skill_name="$(basename "$skill_dir")"
        for target in "$CLAUDE_USER_DIR/skills" "$CODEX_USER_DIR/skills"; do
            mkdir -p "$target"
            rm -rf "$target/$skill_name"
            cp -rf "$skill_dir" "$target/$skill_name"
        done
    done
fi

# 4. Plugins
if [ -d "$ROOT_DIR/plugins/superpowers" ]; then
    echo "[4/5] Syncing Superpowers plugin..."
    mkdir -p "$CODEX_USER_DIR/plugins/cache/openai-api-curated/superpowers/11c74d6b"
    cp -rf "$ROOT_DIR/plugins/superpowers/"* "$CODEX_USER_DIR/plugins/cache/openai-api-curated/superpowers/11c74d6b/" 2>/dev/null || true
fi

if [ -d "$ROOT_DIR/plugins/gsd" ]; then
    echo "[4/5] Syncing GSD engine and profiles..."
    mkdir -p "$CLAUDE_USER_DIR" "$CODEX_USER_DIR"
    for target in "$CLAUDE_USER_DIR" "$CODEX_USER_DIR"; do
        cp -rf "$ROOT_DIR/plugins/gsd/get-shit-done" "$target/" 2>/dev/null || true
        cp -rf "$ROOT_DIR/plugins/gsd/gsd-migration-journal" "$target/" 2>/dev/null || true
        [ -f "$ROOT_DIR/plugins/gsd/.gsd-profile" ] && cp -f "$ROOT_DIR/plugins/gsd/.gsd-profile" "$target/.gsd-profile"
        [ -f "$ROOT_DIR/plugins/gsd/gsd-file-manifest.json" ] && cp -f "$ROOT_DIR/plugins/gsd/gsd-file-manifest.json" "$target/gsd-file-manifest.json"
        [ -f "$ROOT_DIR/plugins/gsd/gsd-install-state.json" ] && cp -f "$ROOT_DIR/plugins/gsd/gsd-install-state.json" "$target/gsd-install-state.json"
    done
fi

# 5. Workspace MCP template
if [ -f "$ROOT_DIR/mcp/.mcp.json" ] && [ -d "./.git" ]; then
    echo "[5/5] Synchronizing MCP template..."
    cp -f "$ROOT_DIR/mcp/.mcp.json" "./.mcp.json"
fi

echo ">>> Done. Claude and Codex now use the canonical shared skill set."
