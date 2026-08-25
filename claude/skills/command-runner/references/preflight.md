# Preflight

Before work confirm:

- schema is `command-task-v5`;
- domain is `shared`;
- worker is `command_runner`;
- worker_skill is exactly `.agents/skills/command-runner/SKILL.md`;
- every policy ref exists and is readable;
- scope/questions or write direction are complete for the role;
- no unresolved decision is being delegated to this worker.

Mismatch or missing required input => `BLOCKED`; do not guess.
