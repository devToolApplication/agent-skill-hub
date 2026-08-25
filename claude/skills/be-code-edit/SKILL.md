---
name: be-code-edit
description: Bounded backend production-code executor with hard rules for exception boundaries, logging ownership, API layering, transactions, persistence, integrations, shared utilities, and mapping standards.
metadata:
  version: "8.0.0"
---

# be-code-edit

Implement only exact parent-decided write-task-v5 changes.

## Shared Utilities & Core Library Rules

- **Shared Core Lib**: In Java microservices, always check project notes (CLAUDE.md/AGENTS.md) for develop-tool-core-lib (n.devTool.core.utils.*).
- **When to Code in Util**: Place pure technical, business-neutral, reusable logic (string, date, json, cache, rest client, generic collection) into develop-tool-core-lib/src/main/java/vn/devTool/core/utils/.
- **When to Code in Class/Service**: Keep business rules, domain invariants, and entity-specific logic in local service/domain classes.
- **DTO/Entity Mapping Standard (Mapper First)**:
  - Always prioritize MapperUtil (mapperUtil.map(...), mapList(...), mapPage(...), mapTo(...)).
  - Only write manual mapping when data shapes diverge drastically or require custom business calculations.
  - Where partial mapping is possible, map common fields using MapperUtil first and manually set/override only the divergent fields.

## Exception hard rules

- Do not add try/catch around every method.
- Do not catch only to log and rethrow.
- Catch only for meaningful recover/retry/translate/compensate/required-cleanup/boundary handling.
- Keep business/domain exceptions semantic; transport mapping belongs at transport boundary.
- Prefer centralized HTTP/message/job exception handling where the framework/project convention supports it.

## Logging hard rules

- Do not log method entry/exit by default.
- Do not log every repository call.
- Do not log the same failure at repository -> service -> controller -> global handler.
- Prefer one owning failure log at the final/recovery boundary.
- DEBUG diagnostic detail; INFO meaningful normal lifecycle/business event; WARN abnormal but recovered/retrying/fallback; ERROR unrecovered operation failure.
- Use structured context and never log secrets/tokens/passwords/sensitive payloads.

## Layer/transaction/integration rules

- Service/domain code must not own HTTP status/response mapping.
- Respect parent-decided transaction ownership; do not silently widen transaction scope.
- Do not mix remote calls into transaction scope unless explicitly decided.
- Respect repository/module ownership.
- Reuse existing timeout/retry/circuit-breaker/idempotency patterns; no new dependency without authorization.
- Preserve authn/authz/validation and data-integrity checks.

## Scope

Exact allowed files/symbols only. New files/dependencies/contracts require explicit TaskSpec authorization. Inspect final diff and return BLOCKED on policy/scope conflict.

Return worker-result-v5 only. Read eferences/preflight.md, eferences/backend-hard-rules.md, eferences/self-check.md and every task policy ref.
