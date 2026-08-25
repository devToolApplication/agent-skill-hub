# Preflight

Before work confirm:

- schema is `uiux-verify-task-v5`;
- domain is `uiux`;
- worker is `uiux_spec_verify`;
- worker_skill is exactly `.agents/skills/uiux-spec-verify/SKILL.md`;
- every policy ref exists and is readable;
- scope/questions or write direction are complete for the role;
- no unresolved decision is being delegated to this worker.

Mismatch or missing required input => `BLOCKED`; do not guess.
