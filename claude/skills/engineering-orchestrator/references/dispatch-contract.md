# Dispatch Contract v5

## Mandatory identity

Every task names exact `domain`, `worker`, and `worker_skill`. The agent TOML validates the same identity.

Mismatch => `BLOCKED/WORKER_SKILL_MISMATCH`.

## Write gate

Do not dispatch a code/test write worker until all of these are resolved:

1. exact problem;
2. repository/runtime evidence;
3. parent-decided direction;
4. exact files and authorized new files;
5. exact per-file instructions;
6. preservation constraints;
7. forbidden scope;
8. exact policy refs;
9. acceptance criteria;
10. verification plan.

Unknown location/behavior -> read worker.
Unknown design/architecture direction -> parent decides.

## UIUX write prohibition

There is no UIUX production-code write worker in v8.

UIUX produces/validates design contracts. Frontend workers implement all frontend code, including presentation, accessibility, responsive behavior, theme integration, and translations.

## Exact scope

Forbidden examples:

```text
src/**
related files
where necessary
fix all usages
refactor as needed
```

If additional scope is required, worker returns `BLOCKED/SCOPE_INSUFFICIENT` with exact requested paths/symbols.

## Cross-domain work

Split BE and FE write tasks. UIUX requirement IDs may feed FE tasks but are not themselves code tasks.

Parent owns ordering and handoff compatibility.
