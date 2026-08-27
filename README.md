# agent-skill-hub

Centralized hub for **Agents**, **Skills**, **Workflow Commands**, **Rules**, plugins and MCP configuration used by Claude Code and Codex CLI.

## Source layout

```text
agent-skill-hub/
├── shared/                  # Canonical cross-runtime content (source of truth)
│   └── skills/
├── claude/                  # Claude-specific agents/commands/config
├── codex/                   # Codex-specific agents/rules/config
├── plugins/
├── mcp/
└── scripts/
    ├── sync.ps1
    └── sync.sh
```

`shared/skills/*` is authoritative for skills that must behave identically on Claude and Codex. During sync, platform-specific files are copied first and shared skills are then installed cleanly into both runtimes, replacing any stale local copy of the same skill.

## Sync

Windows:

```powershell
.\scripts\sync.ps1
```

Linux/macOS/Git Bash:

```bash
chmod +x scripts/sync.sh
./scripts/sync.sh
```

Targets:

- Claude: `~/.claude`
- Codex: `~/.codex`

## Autonomous development workflow

The canonical workflow is `shared/skills/autonomous-dev-workflow`.

Key rules:

- Main orchestrates and dispatches **agents only**. Workflow/task definitions MUST NOT select a model, provider or model tier.
- Planning produces an execution DAG and actively splits independent work for parallel agent execution.
- Multiple instances of the same agent may run concurrently when dependencies are satisfied and write ownership does not overlap.
- Every implementation agent performs self-test, self-code-review and final verification before handoff.
- Self-review never replaces independent review.
- Role rules, role workflows, orchestration rules and task/result contracts are separate artifacts.

To change cross-runtime workflow behavior, edit `shared/skills/...` once, commit, pull on another machine and run the sync script.
