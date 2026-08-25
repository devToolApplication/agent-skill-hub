# Migration Planning

Kế hoạch refactor/migration incremental, rollback, compatibility.

## Khi nào dùng
- Data/schema migration
- Service split/merge
- API version migration
- Library/framework upgrade

## Workflow
1. Baseline current behavior.
2. Define target state.
3. Identify compatibility layer.
4. Plan small reversible steps.
5. Add migration verification.
6. Define rollback.

## Output
- Current state
- Target state
- Step-by-step migration
- Backward compatibility plan
- Data backfill plan
- Verification checklist
- Rollback plan

## Rules
- Prefer expand → migrate → contract pattern
- Never break consumers without compatibility window
- Add monitoring before migration
- Keep rollback realistic
