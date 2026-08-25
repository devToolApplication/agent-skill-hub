---
name: autonomous-dev-workflow
description: Orchestrate end-to-end multi-agent software feature delivery from rough plan through Grill Me requirements discovery, brainstorming, GSD phase planning, narrow implementation agents, independent reviews, repair loops, phase gates, integration verification, live/E2E testing, UAT, and final documentation sync. Use logical model tiers: PREMIUM for the main orchestrator, STANDARD/CHEAP for subagents. Current mapping is PREMIUM=gpt-5.5, STANDARD=gpt-5.2, CHEAP=gpt-5.2. Strongly prefer spawning parallel subagents while main only coordinates, synthesizes, decides, and gates.
---

# Autonomous Dev Workflow

## Objective

Run a feature through a deterministic, evidence-based multi-agent lifecycle while preserving the Main Orchestrator for high-leverage reasoning.

This workflow is **spawn-first** and **parallel-first**.

```text
PREMIUM MAIN
= receive + decompose + route + synthesize + decide + gate

STANDARD/CHEAP SUBAGENTS
= inspect + research + plan details + code + test + review + debug + live validate + docs
```

The main agent is an orchestrator, not a normal worker.

## Model-tier policy

Keep three logical tiers even if multiple tiers currently resolve to the same physical model.

```text
PREMIUM  -> gpt-5.5
STANDARD -> gpt-5.2
CHEAP    -> gpt-5.2
```

Tier meaning:

- `PREMIUM`: Main Orchestrator only; global reasoning, decisions, synthesis, gates.
- `STANDARD`: reasoning-heavy subagent work such as implementation, planning, code review, architecture/security/performance review, complex debugging.
- `CHEAP`: bounded/mechanical subagent work such as repository research, source inspection, test execution, spec review, live execution, evidence collection, docs synchronization.

Normal spawned agents MUST use `STANDARD` or `CHEAP`. Do not spawn `PREMIUM` for ordinary worker roles.

Read `references/03-model-routing.md` before spawning agents.

## Absolute orchestration rules

### MAIN-001 — Main uses PREMIUM

The Main Orchestrator MUST use logical tier:

```text
PREMIUM
```

Current resolved model:

```text
gpt-5.5
```

### MAIN-002 — Subagents use STANDARD or CHEAP

Every spawned worker/reviewer/researcher/tester MUST declare:

```text
model_tier: STANDARD | CHEAP
```

Current resolved model for both tiers:

```text
gpt-5.2
```

### MAIN-003 — Spawn before doing

Before main performs technical/repository/execution work itself, it MUST ask whether the work can be expressed as a bounded assignment.

If yes, main MUST spawn one or more subagents instead.

The burden of proof is on **not spawning**.

### MAIN-004 — Main owns decisions, not execution

Main owns:

- user interaction;
- workflow state;
- requirement interpretation;
- decomposition;
- assignment/tier selection;
- result synthesis;
- architecture/scope decisions;
- reviewer-conflict resolution;
- prioritization;
- PASS/FAIL/BLOCKED gates;
- next-state routing.

Main SHOULD NOT directly:

- broadly explore repositories;
- inspect many implementation files;
- research libraries/options;
- draft detailed implementation plans when a planner can do it;
- edit production code;
- write implementation tests;
- run routine tests;
- perform normal code review;
- perform routine debugging investigation;
- execute live/E2E scenarios;
- perform large documentation synchronization.

Main MAY inspect only the minimum evidence needed to construct an assignment, resolve conflicts, make a global decision, or verify a gate.

### MAIN-005 — Parallelize independent work

When assignments are independent and have no overlapping write set, spawn them concurrently.

Examples:

```text
CHEAP repo research A ------┐
CHEAP library research B ---+--> PREMIUM main synthesis
CHEAP evidence research C --┘
```

```text
CHEAP spec reviewer --------┐
CHEAP test reviewer --------+--> PREMIUM main review gate
STANDARD code reviewer -----┤
STANDARD security reviewer -┘
```

### MAIN-006 — Narrow context

Every spawn receives only:

- exact objective;
- exact relevant files/docs/diff;
- relevant requirement IDs;
- applicable standards;
- permissions;
- expected output schema;
- stop conditions.

Do not dump the whole conversation or repository history into subagents.

### MAIN-007 — Independent review

Implementers MUST NOT approve their own work.

Every non-trivial implementation plan requires independent:

- Specification Reviewer;
- Test Reviewer;
- Code Reviewer.

Add dynamic reviewers when applicable.

### MAIN-008 — Evidence before PASS

Never accept `done`, `fixed`, or `tests pass` without inspectable evidence.

### MAIN-009 — No silent scope/architecture change

Subagents MUST NOT silently alter requirements, scope, or major architecture.

They return the conflict/decision request. PREMIUM main decides and records it.

### MAIN-010 — Split before taking over

If a task is too broad for one subagent:

```text
split problem
-> assign STANDARD/CHEAP tier per unit
-> spawn multiple subagents
-> receive structured results
-> PREMIUM main synthesizes
-> spawn bounded execution agents
```

Main taking over production implementation is not a normal escalation path.

## Default tier routing

Use `STANDARD` by default for:

- GSD planner;
- implementation/code agent;
- complex debugger;
- code reviewer;
- architecture reviewer;
- security reviewer;
- performance reviewer;
- complex API/database reviewer;
- phase-level deep reviewer.

Use `CHEAP` by default for:

- repository/file researcher;
- source inspector;
- library/options researcher;
- GSD researcher;
- simple plan checker;
- specification reviewer;
- test reviewer/runner;
- command runner;
- live API tester;
- browser/E2E executor;
- workflow tester;
- data validator;
- documentation synchronization agent.

Main MAY route a CHEAP role to STANDARD when task complexity warrants it. Current physical model remains `gpt-5.2` for either tier, but the logical distinction MUST be preserved.

## Canonical workflow

```text
USER ROUGH PLAN
      │
      ▼
PREMIUM MAIN
      │
      ├─ Grill Me / requirement conversation
      │
      └─ spawn CHEAP repository evidence agents as needed
      ▼
USER SPEC + AI SPEC
      │
      ▼
BRAINSTORMING
      │
      ├─ CHEAP repo/library/option research agents
      ├─ optional STANDARD challenger for complex tradeoffs
      └─ PREMIUM main synthesizes + decides architecture
      ▼
TECHNICAL DESIGN + PHASES
      │
      ▼
GSD PLAN-PHASE
      │
      ├─ CHEAP researcher
      ├─ STANDARD planner
      └─ CHEAP plan checker
      ▼
SMALL IMPLEMENTATION PLAN
      │
      ▼
STANDARD CODE AGENT + TDD
      │
      ▼
PARALLEL REVIEWS
      │
      ├─ CHEAP Spec Reviewer
      ├─ CHEAP Test Reviewer
      ├─ STANDARD Code Reviewer
      └─ dynamic STANDARD/CHEAP reviewers
      ▼
PREMIUM MAIN GATE
  ┌───┴────┐
 FAIL     PASS
  │         │
  ▼         ▼
fix loop   next plan
  │         │
  └─────────┤
            ▼
        PHASE GATE
            │
      FAIL ─┼─ PASS
        │       │
        ▼       ▼
     gap plan  next phase
            │
            ▼
      ALL PHASES PASS
            │
            ▼
   STANDARD/CHEAP integration agents
            │
            ▼
      CHEAP live/E2E agents
            │
            ▼
           UAT
            │
            ▼
      GRILL-ME CHECK
            │
            ▼
      PREMIUM FINAL GATE
            │
            ▼
      CHEAP docs sync agent
            │
            ▼
           DONE
```

## Stage 0 — Feature initialization

Initialize the feature workspace described in `references/02-documentation.md`.

Feature root:

```text
docs/05-features/<YYYYMMDD-feature-name>/
```

Persist the rough plan and initialize state to `DRAFT`.

Main may delegate mechanical workspace/doc initialization to a CHEAP agent.

## Stage 1 — Requirement discovery

Run `grill-me plan`.

Main owns the user conversation and final requirement interpretation.

Any repository evidence needed during requirement discovery SHOULD be delegated to CHEAP research agents.

Produce:

- `00-discovery/grill-me.md`
- `docs/01-product/features/<feature>/user-spec.md`
- `docs/02-ai-spec/features/<feature>/ai-spec.md`

Use stable IDs such as `REQ-*`, `NFR-*`, `SEC-*`, `PERF-*`.

Advance only when critical requirements and acceptance criteria are explicit enough. State: `REQUIREMENTS_LOCKED`.

## Stage 2 — Technical design / brainstorming

Main orchestrates `brainstorming`.

Default pattern:

1. identify technical questions;
2. spawn independent CHEAP research agents in parallel;
3. use STANDARD specialist/challenger agents for reasoning-heavy questions when useful;
4. collect facts/options/tradeoffs;
5. PREMIUM main synthesizes;
6. PREMIUM main decides architecture and records decisions.

Research agents do not own the final architecture decision.

Produce:

- `01-design/technical-design.md`
- `01-design/architecture-impact.md`
- `01-design/data-flow.md`
- `01-design/decisions.md`

Split approved design into coherent phases. State: `DESIGN_READY`.

## Stage 3 — Phase planning

For each phase invoke GSD phase planning.

Default tier routing:

```text
CHEAP research
-> STANDARD planner
-> CHEAP plan checker
-> revision until PASS/BLOCKED
```

Main receives plan/check results and makes only the phase-plan gate decision.

Every implementation document must be executable by one fresh STANDARD code agent with narrow context.

Use `assets/templates/implementation-plan.md`.

No coding before plan-check PASS.

## Stage 4 — Implementation

Main prepares a narrow assignment and spawns a fresh STANDARD implementation agent.

Inputs SHOULD include only:

- current implementation plan;
- assigned requirement IDs;
- relevant phase boundaries/decisions;
- exact files/interfaces to inspect;
- applicable engineering standards;
- verification commands.

Use `references/04-agent-contracts.md` and `assets/templates/agent-spawn.yaml`.

Implementation agent:

- may read/write assigned code;
- may read/write assigned tests;
- uses TDD where applicable;
- runs required verification;
- may use systematic debugging;
- MUST NOT alter requirements or architecture;
- MUST NOT approve its own task.

## Stage 5 — Parallel independent review

After implementation, main creates one canonical review bundle and immediately spawns reviewers.

Mandatory roles:

```text
Specification Reviewer -> CHEAP
Test Reviewer          -> CHEAP
Code Reviewer          -> STANDARD
```

Spawn them in parallel when read-only over the same diff/evidence.

Dynamic reviewers MAY include:

- Architecture -> STANDARD;
- DB -> CHEAP or STANDARD;
- API/Event -> CHEAP or STANDARD;
- Security -> STANDARD;
- Performance -> STANDARD;
- UI/UX -> CHEAP or STANDARD;
- Infrastructure/operations -> CHEAP or STANDARD.

Reviewers are read-only by default and MUST NOT silently patch code.

Use `references/05-review-gates.md`.

## Stage 6 — Repair loop

If any mandatory reviewer fails:

1. PREMIUM main aggregates/deduplicates findings;
2. main resolves conflicting findings only when needed;
3. spawn a STANDARD code agent with the bounded correction bundle;
4. agent fixes + verifies;
5. re-spawn all affected reviewers.

If root cause is unclear, spawn CHEAP evidence/debug agents and/or a STANDARD debugger. Main synthesizes the evidence and routes a bounded fix.

Do not let main debug implementation directly unless resolving a global design decision.

## Stage 7 — Phase gate

After all plans in the phase pass, spawn phase-level verification/review agents.

Use GSD quality capabilities where available.

Phase review searches for cross-task problems:

- integration mismatch;
- duplicate abstractions;
- wrong dependency direction;
- inconsistent contracts;
- missing requirement coverage;
- runtime-flow errors.

PREMIUM main receives results and decides the phase gate.

Failures become explicit gap plans and return through normal planning/implementation/review.

## Stage 8 — Integration + live/E2E

After all phases pass, spawn STANDARD/CHEAP integration agents based on complexity.

Then spawn specialized CHEAP live agents, preferably in parallel by independent scenario/domain:

- API Live Test Agent;
- Browser/E2E Agent;
- Workflow Scenario Agent;
- Data Validation Agent;
- External Integration Agent.

Use real system behavior in an appropriate test environment where practical.

Live agents capture evidence and MUST NOT patch production code.

Failures return to main for classification, then to STANDARD/CHEAP debug/fix agents.

Read `references/07-live-validation.md`.

## Stage 9 — UAT and final audit

After automated live/E2E passes:

1. run GSD `verify-work` / UAT;
2. run `grill-me check` against original intent;
3. spawn CHEAP verification agents for traceability/evidence if needed;
4. PREMIUM main performs final completion gate;
5. spawn CHEAP documentation agent to synchronize current-state docs;
6. main verifies returned documentation evidence/diff;
7. set state to `DONE` only when all gates pass.

## Failure escalation

Do not escalate a worker to PREMIUM merely because it failed.

Prefer:

```text
same tier + better context
-> fresh agent
-> narrower task
-> split into multiple CHEAP/STANDARD investigations
-> PREMIUM main synthesis/decision
-> fresh STANDARD execution agent
```

Eventually mark `BLOCKED` with evidence if unresolved.

## Agent spawn contract

Every spawned assignment MUST preserve the logical tier:

```yaml
agent_id: "<unique-id>"
role: "<role>"
model_tier: "<STANDARD|CHEAP>"
model: "gpt-5.2"
objective: "<bounded objective>"
```

The `model` is resolved from `model_tier`; both fields are retained for auditability.

Use `assets/templates/agent-spawn.yaml`.

## Context budget

Main preserves its context by delegating repository-heavy and execution-heavy work.

Before every spawn provide exact inputs and expected output. After return retain only evidence/results needed for synthesis and the next gate.

Fresh agents are preferred for:

- independent research;
- implementation plans;
- implementation tasks;
- independent reviews;
- escalated debugging;
- phase reviews;
- live validation.

## Completion definitions

A task is complete only when implementation, required tests, Spec review, Test review, Code review, and applicable dynamic reviews pass with no unresolved blocking finding.

A phase is complete only when all tasks pass and phase verification passes with no blocking gap.

A feature is complete only when all requirements are traceable, all phases pass, integration passes, live/E2E passes, UAT passes, final Grill check passes, and current-state documentation is synchronized.

## Reference map

Load only what is needed:

- `references/01-workflow.md` — state machine, gates, failure routes.
- `references/02-documentation.md` — canonical docs layout and ownership.
- `references/03-model-routing.md` — PREMIUM/STANDARD/CHEAP routing, model mapping, spawn-first policy.
- `references/04-agent-contracts.md` — tier-aware spawn, permissions, structured outputs.
- `references/05-review-gates.md` — reviewer roles, severity, aggregation, re-review.
- `references/06-phase-planning.md` — phase boundaries and implementation-plan sizing.
- `references/07-live-validation.md` — integration, live/E2E, evidence, UAT.
- `references/08-rule-routing.md` — choose project standards/reviewers from changed areas.

Templates live under `assets/templates/`.
