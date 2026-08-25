---
name: engineering-standard
description: Repository-wide generic engineering policy used by the engineering orchestrator and atomic workers. Covers architecture, naming, APIs/data, testing, security/reliability, maintainability, and reuse. Use backend-engineering for stricter server-side exception/logging/transaction/API policies.
metadata:
  version: "6.0.0"
---

# Engineering Standard

Use as the generic engineering policy knowledge base. Pair with `engineering-orchestrator` for non-trivial work and add domain skills such as `backend-engineering`, `frontend-modular-architecture`, or `ui-ux-design` when relevant.

## Mandatory generic rules

1. Organize non-trivial systems by business capability.
2. Keep business logic out of controllers/transports, ORM entities, and vendor clients.
3. Keep framework/vendor details out of domain logic.
4. A function has one primary conceptual responsibility.
5. Use business-oriented names; avoid vague helper/common/process names without a narrow qualifier.
6. Prefer guard clauses and shallow nesting.
7. Other modules consume explicit public contracts only.
8. A module must not directly mutate another module's persistence.
9. Shared code must be business-neutral and narrowly scoped.
10. Do not create abstractions without a real boundary or variation.
11. Comments explain WHY, constraints, or non-obvious tradeoffs.
12. Errors have meaningful semantics; never swallow failures.
13. External calls have intentional timeout/failure behavior.
14. Retry state-changing work only when semantics are safe, normally with idempotency.
15. Important business behavior must be tested.
16. Preserve coherent existing project conventions instead of introducing a competing architecture.
17. Prefer the simplest design that remains easy to change.
18. Search for an existing equivalent before creating a new file, utility, abstraction, or dependency.
19. Do not broaden a feature change into unrelated refactoring.
20. Do not weaken types, assertions, validation, or verification merely to make a change pass.

## Progressive disclosure

- architecture/modules: `references/architecture.md`
- naming/functions/files/comments/state: `references/code-conventions.md`
- shared utilities/reuse: `references/shared-utilities.md`
- generic errors/observability: `references/errors-observability.md`
- generic API/data/messaging: `references/api-data-integrations.md`
- testing/format/lint/CI/dependencies: `references/testing-quality.md`
- security/concurrency/performance/resources: `references/security-reliability-performance.md`
- existing-project design heuristics: `references/design-decisions.md`

For backend changes, prefer the more specific `backend-engineering/references/*` policies where they overlap; domain-specific policy refines this generic standard.

## Layer ownership heuristic

```text
Business truth / invariant / state transition -> domain
Use case / orchestration                      -> application
DB / cache / broker / vendor implementation  -> infrastructure
HTTP / gRPC / consumer / CLI adapter         -> interfaces
Stable contract other modules consume        -> public
Generic business-neutral primitive           -> shared
```

Do not force empty layers/folders.

## Shared utility rule

Focused technical utilities such as `StringUtil`, `TimeUtil`, `DateUtil`, `CollectionUtil`, `JsonUtil`, and `EncodingUtil` are valid when business-neutral and dependency-light.

Do not hide business behavior or I/O behind utility names.
