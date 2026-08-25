---
name: engineering-standard
description: Apply the repository-wide engineering standard when designing, implementing, modifying, refactoring, or reviewing backend/service code in Java, Node.js/TypeScript, Python, C#, Go, Rust, or similar languages. Use for module boundaries, code structure, naming, functions, comments, errors, APIs, persistence, integrations, testing, security, reliability, and maintainability. Do not use for trivial prose-only tasks.
---

# Engineering Standard

Use this skill as the default engineering playbook for production code.

## Before changing code

1. Identify the requested behavior and the business module that owns it.
2. Inspect existing repository conventions before creating a new pattern.
3. Locate public contracts, persistence ownership, integrations, and relevant tests.
4. Make the smallest coherent change that preserves boundaries.
5. Reuse existing code only when semantics are genuinely equivalent.
6. Verify with repository formatter, lint/static analysis, tests, and build/type checks where available.

## Mandatory rules

1. Organize non-trivial systems by business capability.
2. Keep business logic out of controllers, transports, ORM entities, and vendor clients.
3. Keep framework/vendor details out of the domain.
4. A function has one primary conceptual responsibility.
5. Use business-oriented names; avoid vague helper/common/process names without a narrow qualifier.
6. Prefer guard clauses and shallow nesting.
7. Other modules consume explicit public contracts only.
8. A module must not directly mutate another module's persistence.
9. Shared code must be business-neutral and scoped clearly. Focused reusable utilities such as `StringUtil`, `TimeUtil`, `DateUtil`, `CollectionUtil`, `JsonUtil`, or `EncodingUtil` are allowed when they define a narrow technical concern and avoid hidden business/infrastructure dependencies. Vague catch-alls such as `CommonUtil`, `CommonService`, `Helper`, or `MiscUtil` are not.
10. Do not create abstractions without a real boundary or variation.
11. Comments explain WHY, constraints, or non-obvious tradeoffs.
12. Errors have meaningful semantics; never swallow failures.
13. External calls have intentional timeout/failure behavior.
14. Retry state-changing work only when semantics are safe, normally with idempotency.
15. Important business behavior must be tested.
16. Preserve coherent existing project conventions instead of introducing a competing architecture.
17. Prefer the simplest design that remains easy to change.

## Progressive disclosure

Read only the references relevant to the task:

- Architecture/modules/language mapping: `references/architecture.md`
- Naming/functions/files/comments/state modeling: `references/code-conventions.md`
- Shared utility classes/modules and reuse rules: `references/shared-utilities.md`
- Errors/logging/configuration/external failure handling: `references/errors-observability.md`
- API/persistence/cache/messaging/workers: `references/api-data-integrations.md`
- Testing/format/lint/CI/dependency/PR quality: `references/testing-quality.md`
- Security/concurrency/performance/resources: `references/security-reliability-performance.md`
- Existing-project exceptions and design heuristics: `references/design-decisions.md`
- Required workflow/checklists for AI coding: `references/ai-workflow.md`

## Layer ownership heuristic

```text
Business truth / invariant / state transition -> domain
Use case / orchestration                      -> application
DB / cache / broker / vendor implementation  -> infrastructure
HTTP / gRPC / consumer / CLI adapter         -> interfaces
Stable contract other modules consume        -> public
Generic business-neutral primitive / focused reusable utility -> shared
```

Do not force empty layers or folders.

## Shared utility rule

The suffix `Util` is not an anti-pattern by itself.

Allowed shared utilities have a bounded technical responsibility, for example:

```text
StringUtil
TimeUtil
DateUtil
CollectionUtil
JsonUtil
EncodingUtil
UrlUtil
```

Keep a utility in `shared` when it is business-neutral, reusable by unrelated modules, and does not hide a service/infrastructure dependency.

Do not put business behavior or I/O behind a utility name:

```text
OrderUtil.canApprove(...)   -> Order domain/application
PaymentUtil.charge(...)     -> payment service/gateway
EmailUtil.send(...)         -> email service/adapter
DatabaseUtil.save(...)      -> repository/infrastructure
CommonUtil.*                -> split by real responsibility
```

For business logic that depends on current time, prefer an injectable `Clock`/`TimeProvider`; use `TimeUtil` primarily for generic parsing, formatting, conversion, and calculation.

## Completion

For a non-trivial feature, risky refactor, public contract change, persistence change, security change, concurrency change, or cross-module change, run the `feature-review` skill after implementation.
