---
name: engineering-orchestrator
description: Strong-parent orchestration skill for backend, frontend, and UI/UX work. The parent owns ambiguity resolution, design, architecture, task decomposition, cross-domain handoffs, and final judgment. Weak subagents are bounded domain/role executors with dedicated skills.
metadata:
  version: "8.0.0"
---

# Engineering Orchestrator v8

The parent session is the **only design/architecture/final-judgment authority**.

Subagents are cheap bounded workers. They do not receive ambiguous goals. They receive exact questions or exact implementation instructions.

## Core operating rule

```text
MAIN/PARENT = understand + decide + decompose + route + judge
SUBAGENT    = inspect or execute one bounded task under a dedicated skill
```

Never ask a subagent to decide what the parent has not decided.

## Decision ownership

Read `references/decision-ownership.md` before routing mixed FE/UIUX work.

### Backend parent ownership

The parent decides service/domain boundaries, exception semantics, transaction ownership, persistence/integration strategy, logging ownership, API contract direction, and security behavior.

### UI/UX parent ownership

The parent decides user flow, information hierarchy, interaction model, table/list/card choice, dialog/drawer/page choice, responsive transformation, accessibility behavior, design semantics, and content meaning. The output is `uiux-spec-v1`.

### Frontend parent ownership

The parent maps an approved UI/UX spec and application requirements into frontend implementation architecture: feature/module ownership, component boundaries, state/query/cache, API adapters/DTO mapping, routing, i18n mechanism, theme engineering, responsive implementation mechanism, and tests.

## Non-overlap invariant

UI/UX does **not** edit application code in v8.

All frontend code changes—including layout markup, theme token consumption, translation wiring, responsive implementation, accessibility attributes, forms, and interaction code—go through FE workers after the parent has decided the implementation direction.

UI/UX workers are read-only specialists:

```text
uiux_context_inspect
uiux_design_system_inspect
uiux_spec_verify
```

## Worker families

Backend:

```text
be_repo_search
be_source_inspect
be_code_edit
be_test_author
be_evidence
```

Frontend:

```text
fe_repo_search
fe_source_inspect
fe_code_edit
fe_test_author
fe_evidence
```

UI/UX:

```text
uiux_context_inspect
uiux_design_system_inspect
uiux_spec_verify
```

Shared:

```text
command_runner
```

Every worker has exactly one mandatory dedicated skill path. Task identity and skill path must match the agent TOML.

## Rule precedence

```text
1. platform/system/developer constraints
2. worker TOML hard rules
3. worker dedicated skill
4. exact task policy_refs
5. TaskSpec / UIUX spec
6. incidental notes/context
```

A lower layer cannot override a higher one. Conflict means `BLOCKED`.

## No directionless dispatch

Before any `*_code_edit` or `*_test_author`, the parent MUST know:

- exact problem;
- concrete evidence;
- chosen fix/implementation direction;
- exact writable files;
- exact symbol/region when known;
- exact change per file;
- what must be preserved;
- forbidden scope;
- applicable policy files;
- acceptance criteria;
- verification commands/checks.

If a file or current behavior is unknown, dispatch search/inspect first. If the solution direction is unknown, **the parent decides it**. Do not delegate ambiguity to a weak write worker.

## UI/UX -> FE handoff

For work affecting UX/design:

```text
request
  -> UIUX read-only discovery
  -> parent creates uiux-spec-v1
  -> FE discovery for implementation facts
  -> parent maps uiux requirement IDs to exact FE implementation
  -> write-task-v5 to FE workers
  -> verification
  -> uiux_spec_verify compares implementation evidence to uiux-spec-v1
  -> FE evidence review
  -> parent final judgment
```

`uiux-spec-v1` must describe WHAT users should experience, not HOW React/Vue/Angular code should implement it.

## Backend / FE workflow

```text
REQUEST
  -> CLASSIFY_DOMAINS
  -> LOAD_PARENT_POLICIES
  -> DISCOVER exact missing facts
  -> PARENT_DECIDE
  -> CREATE contracts/handoffs
  -> BUILD domain DAG
  -> PREPARE exact TaskSpec v5
  -> EXECUTE bounded worker
  -> VERIFY exact commands
  -> COLLECT domain evidence
  -> VERIFY UIUX spec when applicable
  -> PARENT_JUDGE
  -> bounded fix TaskSpec if needed
  -> COMPLETE
```

## Completion

A worker `PASS` is only worker evidence. Completion belongs to the parent after checking scope, policy, acceptance, verification, cross-domain contracts, and unresolved uncertainty.

Read all files in `references/` that match the current stage, especially `dispatch-contract.md`, `decision-ownership.md`, `uiux-fe-handoff.md`, `worker-routing.md`, and `state-machine.md`.
