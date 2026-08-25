# frontend-modular-architecture

Framework-agnostic Codex skill for maintainable frontend projects.

Main rules:
- feature-first modular structure
- explicit dependency direction
- localized changes
- domain-independent shared layer
- centralized infrastructure
- state at the narrowest correct scope
- no premature abstraction
- mandatory independent subagent review for non-trivial changes

## Files

- `SKILL.md` — main workflow and enforcement rules
- `references/architecture.md` — architecture reference
- `references/conventions.md` — coding conventions
- `references/review-protocol.md` — review gate
- `agents/architecture-reviewer.md` — subagent prompt
- `agents/code-quality-reviewer.md` — subagent prompt
- `agents/test-reviewer.md` — subagent prompt

The skill follows the Agent Skills folder format: the skill directory name matches the `name` in `SKILL.md`.

If the Codex runtime supports multi-agent/subagent execution, the parent agent should spawn the three reviewer roles. If custom agent types are unavailable, use built-in worker/default subagents and pass the corresponding prompt file as the role instructions.


## Codex custom subagents

The bundle includes true project-scoped Codex custom agents:

```text
.codex/agents/
  frontend-architecture-reviewer.toml
  frontend-code-quality-reviewer.toml
  frontend-test-reviewer.toml
```

Copy/extract the skill folder into a repository and place those `.codex/agents/*.toml` files at the repository root's `.codex/agents/` path if the skill itself is stored elsewhere.

The skill instructs the parent Codex agent to spawn all three reviewers after non-trivial implementation work.

The TOML files intentionally do not pin a model or reasoning effort, so they inherit the parent/session defaults. They are `read-only` reviewers.
