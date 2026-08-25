# Sync Script for Claude Code and Codex CLI on Windows
$ErrorActionPreference = "SilentlyContinue"

$rootDir = Split-Path -Parent $PSScriptRoot
$claudeUserDir = "$env:USERPROFILE\.claude"
$codexUserDir = "$env:USERPROFILE\.codex"

Write-Host ">>> Synchronizing Agent & Skill Repository to Local Environment..." -ForegroundColor Cyan

# 1. Sync Claude Code
if (Test-Path "$rootDir\claude") {
    Write-Host "[1/4] Syncing Claude Code configurations..." -ForegroundColor Yellow
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
    Write-Host "[2/4] Syncing Codex CLI configurations..." -ForegroundColor Yellow
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

# 3. Sync Plugins (Superpowers, GSD)
if (Test-Path "$rootDir\plugins") {
    Write-Host "[3/4] Syncing Plugins (Superpowers & GSD)..." -ForegroundColor Yellow
    # Superpowers plugin
    if (Test-Path "$rootDir\plugins\superpowers") {
        $codexSuperPlugin = "$codexUserDir\plugins\cache\openai-api-curated\superpowers\11c74d6b"
        if (-not (Test-Path $codexSuperPlugin)) { New-Item -ItemType Directory -Force $codexSuperPlugin | Out-Null }
        Copy-Item -Path "$rootDir\plugins\superpowers\*" -Destination $codexSuperPlugin -Recurse -Force
    }

    # GSD Engine & Profiles
    if (Test-Path "$rootDir\plugins\gsd") {
        # Sync to Claude
        Copy-Item -Path "$rootDir\plugins\gsd\get-shit-done" -Destination "$claudeUserDir\get-shit-done" -Recurse -Force
        Copy-Item -Path "$rootDir\plugins\gsd\gsd-migration-journal" -Destination "$claudeUserDir\gsd-migration-journal" -Recurse -Force
        Copy-Item -Path "$rootDir\plugins\gsd\.gsd-profile" -Destination "$claudeUserDir\.gsd-profile" -Force
        Copy-Item -Path "$rootDir\plugins\gsd\gsd-file-manifest.json" -Destination "$claudeUserDir\gsd-file-manifest.json" -Force
        Copy-Item -Path "$rootDir\plugins\gsd\gsd-install-state.json" -Destination "$claudeUserDir\gsd-install-state.json" -Force

        # Sync to Codex
        Copy-Item -Path "$rootDir\plugins\gsd\get-shit-done" -Destination "$codexUserDir\get-shit-done" -Recurse -Force
        Copy-Item -Path "$rootDir\plugins\gsd\gsd-migration-journal" -Destination "$codexUserDir\gsd-migration-journal" -Recurse -Force
        Copy-Item -Path "$rootDir\plugins\gsd\.gsd-profile" -Destination "$codexUserDir\.gsd-profile" -Force
        Copy-Item -Path "$rootDir\plugins\gsd\gsd-file-manifest.json" -Destination "$codexUserDir\gsd-file-manifest.json" -Force
        Copy-Item -Path "$rootDir\plugins\gsd\gsd-install-state.json" -Destination "$codexUserDir\gsd-install-state.json" -Force
    }
}

# 4. Sync MCP configurations to current workspace
if (Test-Path "$rootDir\mcp\.mcp.json") {
    Write-Host "[4/4] Synchronizing MCP template..." -ForegroundColor Yellow
    if (Test-Path ".\.git") {
        Copy-Item -Path "$rootDir\mcp\.mcp.json" -Destination ".\.mcp.json" -Force
    }
}

Write-Host ">>> Done! All agents, skills, plugins, and configurations are synchronized successfully." -ForegroundColor Green
