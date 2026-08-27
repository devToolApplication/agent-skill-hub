# Sync Script for Claude Code and Codex CLI on Windows
$ErrorActionPreference = "Stop"

$rootDir = Split-Path -Parent $PSScriptRoot
$claudeUserDir = "$env:USERPROFILE\.claude"
$codexUserDir = "$env:USERPROFILE\.codex"

Write-Host ">>> Synchronizing Agent & Skill Repository to Local Environment..." -ForegroundColor Cyan

# 1. Claude-specific content
if (Test-Path "$rootDir\claude") {
    Write-Host "[1/5] Syncing Claude-specific configurations..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force "$claudeUserDir\agents", "$claudeUserDir\skills", "$claudeUserDir\commands" | Out-Null
    if (Test-Path "$rootDir\claude\agents") { Copy-Item "$rootDir\claude\agents\*" "$claudeUserDir\agents" -Recurse -Force }
    if (Test-Path "$rootDir\claude\skills") { Copy-Item "$rootDir\claude\skills\*" "$claudeUserDir\skills" -Recurse -Force }
    if (Test-Path "$rootDir\claude\commands") { Copy-Item "$rootDir\claude\commands\*" "$claudeUserDir\commands" -Recurse -Force }
    if (Test-Path "$rootDir\claude\CLAUDE.md") { Copy-Item "$rootDir\claude\CLAUDE.md" "$claudeUserDir\CLAUDE.md" -Force }
}

# 2. Codex-specific content
if (Test-Path "$rootDir\codex") {
    Write-Host "[2/5] Syncing Codex-specific configurations..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force "$codexUserDir\agents", "$codexUserDir\skills", "$codexUserDir\rules" | Out-Null
    if (Test-Path "$rootDir\codex\agents") { Copy-Item "$rootDir\codex\agents\*" "$codexUserDir\agents" -Recurse -Force }
    if (Test-Path "$rootDir\codex\skills") { Copy-Item "$rootDir\codex\skills\*" "$codexUserDir\skills" -Recurse -Force }
    if (Test-Path "$rootDir\codex\rules") { Copy-Item "$rootDir\codex\rules\*" "$codexUserDir\rules" -Recurse -Force }
    if (Test-Path "$rootDir\codex\AGENTS.md") { Copy-Item "$rootDir\codex\AGENTS.md" "$codexUserDir\AGENTS.md" -Force }
}

# 3. Canonical shared skills override stale platform copies.
if (Test-Path "$rootDir\shared\skills") {
    Write-Host "[3/5] Installing canonical shared skills for Claude and Codex..." -ForegroundColor Yellow
    Get-ChildItem "$rootDir\shared\skills" -Directory | ForEach-Object {
        $skillName = $_.Name
        foreach ($targetRoot in @("$claudeUserDir\skills", "$codexUserDir\skills")) {
            $target = Join-Path $targetRoot $skillName
            if (Test-Path $target) { Remove-Item $target -Recurse -Force }
            Copy-Item $_.FullName $target -Recurse -Force
        }
    }
}

# 4. Plugins
if (Test-Path "$rootDir\plugins\superpowers") {
    Write-Host "[4/5] Syncing Superpowers plugin..." -ForegroundColor Yellow
    $codexSuperPlugin = "$codexUserDir\plugins\cache\openai-api-curated\superpowers\11c74d6b"
    New-Item -ItemType Directory -Force $codexSuperPlugin | Out-Null
    Copy-Item "$rootDir\plugins\superpowers\*" $codexSuperPlugin -Recurse -Force
}

if (Test-Path "$rootDir\plugins\gsd") {
    Write-Host "[4/5] Syncing GSD engine and profiles..." -ForegroundColor Yellow
    foreach ($target in @($claudeUserDir, $codexUserDir)) {
        New-Item -ItemType Directory -Force $target | Out-Null
        if (Test-Path "$rootDir\plugins\gsd\get-shit-done") { Copy-Item "$rootDir\plugins\gsd\get-shit-done" $target -Recurse -Force }
        if (Test-Path "$rootDir\plugins\gsd\gsd-migration-journal") { Copy-Item "$rootDir\plugins\gsd\gsd-migration-journal" $target -Recurse -Force }
        foreach ($file in @(".gsd-profile", "gsd-file-manifest.json", "gsd-install-state.json")) {
            $source = "$rootDir\plugins\gsd\$file"
            if (Test-Path $source) { Copy-Item $source (Join-Path $target $file) -Force }
        }
    }
}

# 5. Workspace MCP template
if ((Test-Path "$rootDir\mcp\.mcp.json") -and (Test-Path ".\.git")) {
    Write-Host "[5/5] Synchronizing MCP template..." -ForegroundColor Yellow
    Copy-Item "$rootDir\mcp\.mcp.json" ".\.mcp.json" -Force
}

Write-Host ">>> Done. Claude and Codex now use the canonical shared skill set." -ForegroundColor Green
