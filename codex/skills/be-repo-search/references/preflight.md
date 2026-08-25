# Preflight

Before work confirm:

- schema is `read-task-v5`;
- domain is `backend`;
- worker is `be_repo_search`;
- worker_skill is exactly `.agents/skills/be-repo-search/SKILL.md`;
- every policy ref exists and is readable;
- scope/questions or write direction are complete for the role;
- no unresolved decision is being delegated to this worker.

Mismatch or missing required input => `BLOCKED`; do not guess.
