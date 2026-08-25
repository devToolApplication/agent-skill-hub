---
name: frontend-modular-architecture
description: Enforces a framework-agnostic, feature-first frontend architecture for implementation, refactoring, bug fixes, and code review. Use when creating or modifying frontend code in React, Vue, Angular, Svelte, Next.js, Nuxt, or similar projects. Requires explicit dependency boundaries, localized changes, maintainable code, appropriate tests, and independent subagent review before completion.
compatibility: Designed for Codex or other coding agents with repository access. Multi-agent/subagent support is strongly recommended; if custom agent types are unavailable, use built-in worker/default agents with the bundled reviewer prompts.
metadata:
  version: "1.0.0"
  architecture: "feature-first-modular"
---

# Frontend Modular Architecture

Use this skill whenever the task creates, changes, refactors, reviews, or fixes frontend code.

The goal is not to force one framework or one library. The goal is to make changes easy to locate, easy to modify, easy to test, and difficult to accidentally couple.

## Non-negotiable outcomes

Every completed change MUST aim for all of the following:

1. Business changes are localized to the relevant feature/domain.
2. Framework-specific code does not leak into unrelated business logic without a reason.
3. Dependencies flow in the allowed direction.
4. Shared code is domain-independent.
5. Infrastructure concerns are centralized.
6. Backend DTOs do not become the application's permanent domain model by accident.
7. Components remain focused on presentation and interaction.
8. State is kept at the narrowest correct scope.
9. Tests cover meaningful behavior and regression risk.
10. Independent reviewer subagents inspect non-trivial changes before completion.

Read:
- `references/architecture.md` for module/layer rules.
- `references/conventions.md` for coding conventions.
- `references/review-protocol.md` for the mandatory review gate.

## Operating mode

Do not blindly impose a new folder structure on an existing project.

Before changing code:

1. Inspect the repository structure.
2. Identify framework, build tool, package manager, router, state solution, query/cache solution, testing tools, lint/format rules, aliases, and existing conventions.
3. Locate the feature/domain owning the requested behavior.
4. Inspect neighboring files and follow established local style when it does not violate a critical rule.
5. Determine the smallest coherent change.
6. Identify existing reusable code before creating new abstractions.
7. Identify commands available for validation.

Preserve existing architecture when it is reasonable. Improve incrementally. Do not perform unrelated migrations.

## Architecture model

Default conceptual layers:

```text
app
  -> features
  -> shared
  -> core

features
  -> shared
  -> core

shared
  -X-> features

core
  -X-> features
```

The exact physical folders may differ. Preserve the dependency meaning even if names differ.

### app

Application composition only:

- bootstrap
- global providers
- routing composition
- layouts
- global configuration
- top-level guards
- application wiring

Do not place feature business logic here.

### features

Organize business capabilities by feature/domain, for example:

```text
features/
  auth/
  customer/
  order/
  payment/
```

A feature may contain only the folders it actually needs:

```text
feature/
  api/
  components/
  hooks-or-composables/
  model/
  pages/
  services/
  store/
  types/
  validators/
  utils/
  index.*
```

Do not create empty folders to satisfy a template.

### shared

Contains reusable, domain-independent code:

- UI primitives
- generic reusable components
- generic hooks/composables
- date/string/number/collection utilities
- generic types
- generic validators

Shared MUST NOT depend on a business feature.

If code understands `Order`, `Customer`, `Invoice`, or another domain concept, it normally belongs to that domain instead of `shared`.

### core

Contains platform/infrastructure concerns:

- HTTP client
- storage
- authentication plumbing
- logging
- telemetry
- cache infrastructure
- global error mapping
- i18n infrastructure
- environment/config access

Feature code should use infrastructure abstractions instead of scattering direct browser/network/storage access throughout UI components.

## Public feature boundary

When the project supports module public APIs, feature consumers SHOULD import from the feature boundary:

```text
features/order
```

instead of deep internals such as:

```text
features/order/components/order-form/internal/...
```

Internal refactoring should not force unrelated consumers to change.

Cross-feature imports require justification. Prefer:
1. shared domain-neutral contracts,
2. application composition,
3. or the other feature's explicit public API.

Never deep-import another feature's internals.

## Change placement decision

For every new unit of code, decide in this order:

1. Is it specific to one feature/domain?
   - Put it inside that feature.

2. Is it truly domain-independent and reusable?
   - Put it in shared.

3. Is it infrastructure/platform integration?
   - Put it in core.

4. Is it application composition?
   - Put it in app.

5. Is it currently used only once?
   - Prefer keeping it close to the caller unless separation clearly improves responsibility or testability.

Code that changes together should stay together.

## Components

A component SHOULD primarily:
- render data,
- own local interaction state,
- emit/trigger user actions,
- compose smaller UI pieces.

Move complex business decisions into domain functions, services, hooks/composables, or feature-level modules.

Do not split components only to satisfy line-count rules. Split by responsibility and change boundaries.

Review strongly when a component:
- mixes fetching, mapping, validation, permissions, storage, navigation, and rendering,
- has many unrelated effects,
- has large nested condition trees,
- or cannot be tested without setting up the whole application.

## Functions

Prefer functions that:
- perform one coherent job,
- use domain-specific names,
- have clear inputs and outputs,
- minimize hidden side effects,
- are pure when practical.

Avoid vague names such as:
- `processData`
- `handleData`
- `common`
- `helper`
- `manager`
- `misc`

unless the meaning is genuinely clear in context.

UI event handlers may use names such as `handleSubmit`.
Business operations should use intent names such as `submitOrder`, `cancelOrder`, or `calculateOrderTotal`.

## API and domain models

Do not force UI code to depend forever on backend wire formats.

For unstable, awkward, or backend-specific contracts, use:

```text
API DTO
  -> mapper/adapter
  -> application/domain model
  -> UI
```

Simple stable APIs do not require ceremonial mapping layers. Add the boundary when it protects the application from meaningful contract coupling.

Feature API functions should express business intent:

```text
getOrders
getOrder
createOrder
cancelOrder
```

not generic feature-level wrappers named only `get`, `post`, or `request`.

## State placement

Classify state before adding a store.

### Local UI state
Examples:
- modal open
- active tab
- expanded row
- draft input

Keep it local when possible.

### Server state
Examples:
- orders
- customers
- documents

Prefer the project's server-state/query/cache mechanism when appropriate.

### Global application state
Examples:
- authenticated user
- permissions
- language
- theme
- feature flags

Use a global store only when the state truly needs global coordination.

Do not copy server state into global state without a concrete reason.

## Error handling

Do not scatter inconsistent generic try/catch + alert behavior across components.

Use the project's central error handling and feature-specific presentation where appropriate.

Separate:
- transport/infrastructure errors,
- domain/application errors,
- user-facing presentation.

Preserve useful error context. Do not swallow errors silently.

## Routing and permissions

Avoid duplicating raw route strings and role checks throughout the UI when the project already has or clearly needs a centralized abstraction.

Prefer intent:

```text
customerRoutes.detail(id)
permission.can("order:create")
canCancelOrder(order, user)
```

over repeated fragile string/role comparisons.

## Abstraction policy

Do not over-engineer.

Prefer:
- direct readable code,
- local duplication when the abstraction is uncertain,
- standard library/framework capabilities,
- existing project utilities.

Do not create new:
- manager
- factory
- service
- adapter
- repository
- base class
- global helper

unless it removes a real responsibility boundary, volatile dependency, or repeated pattern.

A small amount of duplication is better than the wrong abstraction.

## Implementation workflow

For each task:

### Phase 1 — Discover
Inspect relevant code and repository conventions.

### Phase 2 — Design
Write down internally:
- owning feature/domain,
- affected modules,
- dependency direction,
- data flow,
- state placement,
- API boundary,
- test impact.

For a small bug fix this can be very brief.

### Phase 3 — Implement
Make the smallest coherent change.

Do not mix unrelated cleanup into the patch.

### Phase 4 — Self-validate
Run the narrowest useful checks first:
- focused unit tests,
- type check,
- lint,
- affected package build.

Then run broader checks when practical and justified.

### Phase 5 — Independent review
For every non-trivial code change, spawn independent reviewer subagents according to `references/review-protocol.md`.

Prefer the bundled project-scoped Codex custom agents when available:
- `frontend_architecture_reviewer`
- `frontend_code_quality_reviewer`
- `frontend_test_reviewer`

Definitions:
- `.codex/agents/frontend-architecture-reviewer.toml`
- `.codex/agents/frontend-code-quality-reviewer.toml`
- `.codex/agents/frontend-test-reviewer.toml`

Spawn the three reviewers independently, preferably in parallel, after implementation and initial validation.

If the current Codex surface cannot resolve project-scoped custom agent names, spawn built-in `default`/`worker` subagents and provide the equivalent fallback prompts:
- `agents/architecture-reviewer.md`
- `agents/code-quality-reviewer.md`
- `agents/test-reviewer.md`

Reviewers should inspect the implementation independently. The primary implementation agent MUST NOT pretend to be the independent reviewer.

### Phase 6 — Fix review findings
Fix all BLOCKER and HIGH findings before completion unless they are clearly false positives.

After fixes, re-run the affected reviewer once.

Do not enter an endless review loop. Two review rounds are normally the maximum. If a serious issue still remains, report it clearly instead of hiding it.

### Phase 7 — Final validation
Run relevant tests/checks again after review fixes.

### Phase 8 — Completion report
Report concisely:
- what changed,
- architectural decisions worth knowing,
- tests/checks run,
- reviewer result,
- any remaining risk or follow-up.

Do not claim a check passed unless it was actually run.

## When subagents are unavailable

If the runtime truly has no subagent/multi-agent capability:

1. Say that independent subagent review could not be executed.
2. Perform the same review protocol sequentially as a fallback.
3. Clearly label it as a fallback, not independent review.

Do not silently skip the review gate.

## Severity policy

Reviewer findings use:

- BLOCKER — correctness, security, data loss, broken architecture boundary, or guaranteed production failure.
- HIGH — likely bug/regression, severe coupling, missing critical tests, major maintainability problem.
- MEDIUM — meaningful improvement that is not required to safely complete the task.
- LOW — polish, naming, minor simplification.

Completion gate:
- BLOCKER: zero
- HIGH: zero
- MEDIUM/LOW: may remain only when explicitly documented and reasonable.

## Prime directive

Optimize for localized future change.

A request about one feature should normally modify that feature and a small number of stable shared/core boundaries.

If a simple business change requires unrelated edits across many directories, treat that as an architectural smell and minimize further coupling.
