# Sync Script for Claude Code and Codex CLI on Windows
$ErrorActionPreference = "SilentlyContinue"

$rootDir = Split-Path -Parent $PSScriptRoot
$claudeUserDir = "$env:USERPROFILE\.claude"
$codexUserDir = "$env:USERPROFILE\.codex"

Write-Host ">>> Synchronizing Agent & Skill Repository to Local Environment..." -ForegroundColor Cyan

# 1. Sync Claude Code
if (Test-Path "$rootDir\claude") {
    Write-Host "[1/3] Syncing Claude Code configurations..." -ForegroundColor Yellow
    if (-not (Test-Path "$claudeUserDir\agents")) { New-Item -ItemType Directory -Force "$claudeUserDir\agents" | Out-Null }
    if (-not (Test-Path "$claudeUserDir\skills")) { New-Item -ItemType Directory -Force "$claudeUserDir\skills" | Out-Null }
    if (-not (Test-Path "$claudeUserDir\commands")) { New-Item -ItemType Directory -Force "$claudeUserDir\commands" | Out-Null }

    Copy-Item -Path "$rootDir\claude\agents\*" -Destination "$claudeUserDir\agents" -Recurse -Force
    Copy-Item -Path "$rootDir\claude\skills\*" -Destination "$claudeUserDir\skills" -Recurse -Force
    Copy-Item -Path "$rootDir\claude\commands\*" -Destination "$claudeUserDir\commands" -Recurse -Force
    if (Test-Path "$rootDir\claude\CLAUDE.md") {
        Copy-Item -Path "$rootDir\claude\CLAUDE.md" -Destination "$claudeUserDir\CLAUDE.md" -Force
    }
}

# 2. Sync Codex CLI
if (Test-Path "$rootDir\codex") {
    Write-Host "[2/3] Syncing Codex CLI configurations..." -ForegroundColor Yellow
    if (-not (Test-Path "$codexUserDir\agents")) { New-Item -ItemType Directory -Force "$codexUserDir\agents" | Out-Null }
    if (-not (Test-Path "$codexUserDir\skills")) { New-Item -ItemType Directory -Force "$codexUserDir\skills" | Out-Null }
    if (-not (Test-Path "$codexUserDir\rules")) { New-Item -ItemType Directory -Force "$codexUserDir\rules" | Out-Null }

    Copy-Item -Path "$rootDir\codex\agents\*" -Destination "$codexUserDir\agents" -Recurse -Force
    Copy-Item -Path "$rootDir\codex\skills\*" -Destination "$codexUserDir\skills" -Recurse -Force
    Copy-Item -Path "$rootDir\codex\rules\*" -Destination "$codexUserDir\rules" -Recurse -Force
    if (Test-Path "$rootDir\codex\AGENTS.md") {
        Copy-Item -Path "$rootDir\codex\AGENTS.md" -Destination "$codexUserDir\AGENTS.md" -Force
    }
}

# 3. Sync MCP configurations to current workspace (if running inside a repo)
if (Test-Path "$rootDir\mcp\.mcp.json") {
    Write-Host "[3/3] Synchronizing MCP template..." -ForegroundColor Yellow
    if (Test-Path ".\.git") {
        Copy-Item -Path "$rootDir\mcp\.mcp.json" -Destination ".\.mcp.json" -Force
    }
}

Write-Host ">>> Done! All agents, skills, and configurations are synchronized successfully." -ForegroundColor Green
