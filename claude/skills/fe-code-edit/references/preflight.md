# Preflight

Before work confirm:

- schema is `write-task-v5`;
- domain is `frontend`;
- worker is `fe_code_edit`;
- worker_skill is exactly `.agents/skills/fe-code-edit/SKILL.md`;
- every policy ref exists and is readable;
- scope/questions or write direction are complete for the role;
- no unresolved decision is being delegated to this worker.

Mismatch or missing required input => `BLOCKED`; do not guess.
