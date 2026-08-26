---
name: autonomous-dev-workflow
description: Orchestrate end-to-end multi-agent software delivery with Grill Me requirements discovery, brainstorming, a conditional BPMN design gate for workflow/process features, GSD planning, skill-aware subagents, TDD implementation, independent reviews, local-first integration/live/E2E gates, CD deployment to test environment, test-environment revalidation, UAT, and final documentation sync. Use PREMIUM for main orchestration and STANDARD/CHEAP for spawned workers. Main is spawn-first and parallel-first; before every spawn Main resolves each required skill to its concrete installed directory/SKILL.md and passes those exact paths in the subagent prompt.
---

# Autonomous Dev Workflow

## Purpose

Run a feature through a deterministic multi-agent lifecycle while keeping the PREMIUM Main Orchestrator focused on:

```text
receive
→ decompose
→ resolve skills
→ route
→ synthesize
→ decide
→ gate
```

Main is not the normal coder, tester, researcher, reviewer, debugger, BPMN modeler/validator, or live-test worker.

## Model tiers

Keep three logical tiers:

```text
PREMIUM  -> gpt-5.5
STANDARD -> gpt-5.2
CHEAP    -> gpt-5.2
```

- `PREMIUM`: Main Orchestrator only.
- `STANDARD`: implementation and reasoning-heavy subagent work.
- `CHEAP`: narrow, deterministic, evidence-oriented subagent work.

Read `references/03-model-routing.md` before spawning.

## Skill preflight is mandatory

Before normal workflow delegation begins, Main MUST discover the actual skills installed/available in the current Codex runtime/workspace and build a session skill index.

Do not assume a fixed filesystem root.

For every canonical workflow skill that may be used, Main resolves:

```yaml
id: <canonical-skill-id>
resolved_as: <installed-name-or-alias>
skill_dir: <actual-installed-directory>
skill_file: <actual-installed-directory>/SKILL.md
verified: true
```

Main may cache this mapping for the orchestration session, but MUST never invent paths.

Read `references/09-skill-routing.md` for discovery, precedence, alias resolution, and path validation.

## Skill routing is mandatory

Model routing and skill routing are independent:

```text
ROLE
├─ model_tier -> physical model
└─ canonical skills -> concrete installed skill paths -> execution method
```

Before every spawn, Main MUST resolve:

1. role;
2. model tier;
3. required skills;
4. applicable conditional skills;
5. concrete `skill_dir` + `skill_file` for each skill;
6. exact inputs/context;
7. permissions;
8. expected output schema.

If a required skill cannot be resolved, do not perform the normal spawn. Record/return `SKILL_UNAVAILABLE`.

If a supplied skill path is invalid when the child starts, the child returns `SKILL_PATH_INVALID` and Main re-resolves it.

## Subagent prompt must contain exact skill paths

Every spawned worker prompt MUST include a clear block equivalent to:

```text
REQUIRED SKILLS — READ BEFORE WORK

1. <skill-id>
   Directory: <resolved-skill-directory>
   SKILL.md: <resolved-skill-directory>/SKILL.md

2. <skill-id>
   Directory: <resolved-skill-directory>
   SKILL.md: <resolved-skill-directory>/SKILL.md

Read and follow every SKILL.md above before doing the assignment.
Use exactly the supplied skill paths.
Do not search for an alternative workflow skill.
If a supplied path is invalid, stop and return SKILL_PATH_INVALID.
```

This is a hard contract, not optional prompt decoration.

Subagents should spend tokens doing their bounded task, not rediscovering workflow skills that Main already resolved.

## Absolute orchestration rules

### MAIN-001 — Main uses PREMIUM

```text
PREMIUM -> gpt-5.5
```

### MAIN-002 — Spawned agents use STANDARD or CHEAP

Normal workers MUST NOT use PREMIUM.

### MAIN-003 — Spawn before doing

If bounded technical work can be expressed with clear inputs/output, Main MUST spawn a subagent instead of doing it directly.

The burden of proof is on **not spawning**.

### MAIN-004 — Resolve before spawn

Main MUST resolve every required skill to a verified concrete path before the child starts.

The order is:

```text
choose role
→ choose tier
→ choose canonical skills
→ resolve actual skill directories/SKILL.md files
→ build narrow prompt
→ spawn
```

### MAIN-005 — Parallelize independent work

When assignments are independent and have no overlapping write set, Main SHOULD resolve all child skill paths first, use the concrete `dispatching-parallel-agents` skill path itself, and spawn children concurrently.

### MAIN-006 — Narrow context

Every subagent receives only relevant:

- objective;
- requirement IDs;
- files/docs/diff;
- standards;
- required skill IDs and exact paths;
- permissions;
- expected output;
- stop conditions.

### MAIN-007 — Independent verification

Implementers never approve themselves.

Every non-trivial implementation task requires independent:

- Specification Reviewer;
- Test Reviewer;
- Code Reviewer;
- applicable dynamic reviewers.

A non-trivial BPMN model also requires an independent BPMN Validator; the modeler cannot self-certify PASS.

### MAIN-008 — Evidence before PASS

Never accept `done`, `fixed`, `tests pass`, `deployed`, `BPMN valid`, or `skill loaded` without inspectable evidence.

### MAIN-009 — No silent scope/architecture change

Subagents report conflicts. Main owns final requirement, scope, architecture, reviewer-conflict, and gate decisions.

BPMN subagents may refine/model/validate approved process semantics but MUST escalate any required business-policy change back to Main.

## Main-owned orchestration skills

Main uses these capabilities when their stage is active and MUST resolve their concrete skill paths before use:

```yaml
requirement_discovery:
  - grill-me

technical_design:
  - brainstorming

process_design_when_applicable:
  - bpmn-design

parallel_dispatch:
  - dispatching-parallel-agents

final_requirement_check:
  - grill-me
```

Main may spawn research agents during brainstorming, but Main retains final architecture authority.

## BPMN applicability rule

After technical design, Main MUST classify whether the feature is a workflow/process feature.

Trigger the BPMN design gate when the feature includes one or more of:

```text
workflow
business process
process orchestration
approval flow
routing / branching by business condition
business state transitions
parallel or inclusive execution paths
long-running waits / timers
external events / human tasks
business error / compensation paths
subprocesses
visual BPMN process definitions
```

Do not trigger BPMN merely because ordinary application code contains sequential `if/else` logic.

When applicability is uncertain but process behavior is central to the feature, prefer running the BPMN gate.

## Canonical workflow

```text
USER ROUGH PLAN
      ↓
PREMIUM MAIN
      ↓
SKILL PREFLIGHT / BUILD SKILL INDEX
      ↓
GRILL-ME REQUIREMENT DISCOVERY
      ↓
USER SPEC + AI SPEC
      ↓
BRAINSTORMING
  ├─ CHEAP research agents
  ├─ optional STANDARD challenger
  └─ PREMIUM Main decides design
      ↓
TECHNICAL DESIGN
      ↓
WORKFLOW / PROCESS FEATURE?
  ├─ no ─────────────────────────────┐
  └─ yes                            │
       ↓                             │
     BPMN DESIGN GATE                │
       ├─ STANDARD BPMN Architect    │
       ├─ STANDARD BPMN Modeler      │
       ├─ CHEAP BPMN Validator       │
       │    └─ FAIL loops to owner   │
       └─ STANDARD Engine Mapper     │
       ↓                             │
     BPMN PASS ──────────────────────┘
      ↓
TECHNICAL DESIGN + PHASES
      ↓
GSD PLAN-PHASE
  ├─ CHEAP researcher
  ├─ STANDARD planner
  └─ CHEAP plan checker
      ↓
SMALL IMPLEMENTATION PLAN
      ↓
STANDARD IMPLEMENTATION AGENT
  └─ read supplied test-driven-development/SKILL.md
      ↓
PARALLEL REVIEWS
  ├─ CHEAP Spec Reviewer
  │    └─ read supplied verification-before-completion/SKILL.md
  ├─ CHEAP Test Reviewer
  │    └─ read supplied verification-before-completion/SKILL.md
  ├─ STANDARD Code Reviewer
  │    ├─ read supplied requesting-code-review/SKILL.md
  │    └─ read supplied verification-before-completion/SKILL.md
  └─ dynamic reviewers
      ↓
PREMIUM MAIN TASK GATE
      ↓
ALL TASKS/PHASES PASS
      ↓
LOCAL INTEGRATION VERIFY
      ↓
LOCAL FULL LIVE/E2E + REGRESSION
      ↓
LOCAL GATE PASS
      ↓
FINALIZE CANDIDATE COMMIT
      ↓
PUSH + CD DEPLOY TEST ENV
      ↓
VERIFY DEPLOYED REVISION
      ↓
TEST-ENV INTEGRATION VERIFY
      ↓
TEST-ENV FULL LIVE/E2E + REGRESSION
      ↓
UAT
      ↓
GRILL-ME FINAL CHECK
      ↓
FINAL AUDIT
      ↓
DOC SYNC
      ↓
DONE
```

Read `references/01-workflow.md` for the base state machine. The BPMN gate defined here is an additional mandatory pre-planning gate whenever the applicability rule is true.

# Stage 0 — Feature initialization + skill preflight

Create/use:

```text
docs/05-features/<YYYYMMDD-feature-name>/
```

Persist rough plan and initialize state to `DRAFT`.

Before spawning planning/research/implementation agents, Main discovers and resolves the concrete skill paths required by this workflow.

Main may delegate mechanical workspace/doc initialization only after the child's required project/domain skills, if any, are resolved and supplied.

# Stage 1 — Requirement discovery

Main resolves and reads the installed `grill-me` skill path, then runs requirement discovery.

Main owns the user conversation and final requirement interpretation.

Repository evidence should be delegated to CHEAP research agents.

Produce:

- `00-discovery/grill-me.md`
- User Spec
- AI Spec with stable `REQ-*`, `NFR-*`, `SEC-*`, `PERF-*` IDs.

# Stage 2 — Technical design / brainstorming

Main resolves and reads the installed `brainstorming` skill.

Default:

1. identify technical questions;
2. spawn independent research agents;
3. collect facts/options/tradeoffs;
4. use challengers when useful;
5. Main synthesizes;
6. Main decides architecture;
7. Main evaluates BPMN applicability before phase planning.

Research agents do not own final architecture decisions.

# Stage 2B — BPMN design gate when applicable

If the BPMN applicability rule is true, Main MUST resolve `bpmn-design` plus the four specialized BPMN skills before GSD phase planning:

```text
bpmn-design
bpmn-architect
bpmn-modeler
bpmn-validator
bpmn-engine-mapper
```

Default delegation:

```text
STANDARD BPMN Architect
  + bpmn-architect
  → 02-design/bpmn/01-process-design.md

STANDARD BPMN Modeler
  + bpmn-modeler
  → 02-design/bpmn/process.bpmn

CHEAP BPMN Validator
  + bpmn-validator
  → 02-design/bpmn/02-bpmn-validation.md

STANDARD BPMN Engine Mapper
  + bpmn-engine-mapper
  → 02-design/bpmn/03-engine-mapping.md
```

Main uses `bpmn-design` as the orchestration contract and retains final architecture/business-policy authority.

Hard BPMN rules:

```text
condition belongs to SequenceFlow, not pseudo decision node
work/evaluation is separate from routing
gateway type must match XOR / OR / AND / event semantics
split/join behavior must be explicit
no-match/default behavior must be explicit or proven unnecessary
business error/timer/cancellation semantics must not be hidden in worker code
vendor-neutral BPMN semantics come before engine-specific mapping
```

The following are forbidden substitutes for BPMN routing semantics:

```text
AI_GATE
CODE_GATE
DECISION_TASK
CHECK_CONDITION_NODE
```

Validation failure routing:

```text
BUSINESS_SEMANTIC
→ bpmn-architect
→ if policy/architecture changes, Main decides

BPMN_SYNTAX / BPMN_SEMANTIC / MODEL_STRUCTURE
→ bpmn-modeler

ENGINE_COMPATIBILITY
→ bpmn-engine-mapper
→ if workaround changes process semantics, return to architect/Main
```

After every BPMN fix, rerun `bpmn-validator`.

Do not continue to Stage 3 until:

```yaml
architect: DONE
modeler: DONE
validator: PASS
engine_mapper: DONE
blocking_ambiguities: 0
```

# Stage 3 — Phase planning

Resolve `gsd-plan-phase` to a concrete installed path before spawning any planning agent.

For BPMN-applicable features, the GSD planner MUST receive the validated BPMN artifacts and engine mapping as immutable process-semantics inputs.

Default:

```text
CHEAP GSD Researcher
→ STANDARD GSD Planner
→ CHEAP Plan Checker
```

All children receive the same verified GSD skill path when that canonical skill is required.

No coding before plan-check PASS. No planning around a failed BPMN gate.

Read `references/06-phase-planning.md`.

# Stage 4 — Implementation

Spawn a fresh STANDARD implementation agent.

Required skill:

```text
test-driven-development
```

Main passes its exact resolved directory and `SKILL.md` path in the prompt.

For BPMN-applicable features, also pass:

```text
02-design/bpmn/01-process-design.md
02-design/bpmn/process.bpmn
02-design/bpmn/02-bpmn-validation.md
02-design/bpmn/03-engine-mapping.md
```

The implementation agent MUST preserve validated BPMN semantics, especially:

```text
node work vs edge routing separation
SequenceFlow conditions
gateway type semantics
join/synchronization behavior
error/timer/wait behavior
```

If implementation exposes a BPMN semantic/engine gap, stop the affected task and route back through the BPMN gate rather than silently changing the process.

Conditional:

```text
on unknown root cause -> systematic-debugging
on review correction -> receiving-code-review
```

Resolve conditional skill paths before they are used.

Implementation agent MUST NOT alter requirements/architecture or approve itself.

# Stage 5 — Parallel independent review

Main resolves all reviewer skill paths before parallel dispatch.

Mandatory:

```text
Spec Reviewer
  CHEAP
  verification-before-completion

Test Reviewer
  CHEAP
  verification-before-completion

Code Reviewer
  STANDARD
  requesting-code-review
  verification-before-completion
```

For BPMN-applicable features, reviewers MUST treat the validated BPMN model + engine mapping as part of the specification and flag semantic drift as a blocking finding.

The prompt for each reviewer contains its own concrete skill paths.

Read `references/05-review-gates.md`.

# Stage 6 — Repair loop

Clear review findings:

```text
STANDARD implementation agent
+ receiving-code-review path
+ test-driven-development path
```

Unknown root cause:

```text
STANDARD debugger
+ systematic-debugging path
→ evidence
→ STANDARD implementation agent
+ test-driven-development path
```

If a finding reveals BPMN semantic drift or an unsupported BPMN capability, route through Stage 2B before implementation continues.

After fix, rerun all affected reviewers with their resolved skills.

# Stage 7 — Phase gate

Phase reviewer requires resolved:

```text
gsd-code-review
gsd-validate-phase
verification-before-completion
```

Any triggered security/UI phase capability must also be resolved to an actual installed skill path before use.

For BPMN-applicable features, the phase reviewer checks implementation traceability against BPMN artifacts and confirms no routing semantics moved into opaque node/task logic.

# Stage 8 — Local-first integration/live validation

Required order:

```text
ALL PHASES PASS
→ LOCAL INTEGRATION
→ LOCAL FULL LIVE/E2E + REGRESSION
→ LOCAL GATE PASS
→ candidate commit
→ PUSH/CD TEST ENV
→ verify exact deployed revision
→ TEST-ENV INTEGRATION
→ TEST-ENV FULL LIVE/E2E + REGRESSION
```

All verification/live agents receive resolved `verification-before-completion` paths plus any required browser/domain-specific skill path.

BPMN-applicable live/integration tests SHOULD cover gateway routing, joins, default/no-match behavior, error/timer/wait behavior, and persistence/recovery relevant to the process.

Never push/CD while local gate is failing.

Any code fix found in test env returns to local fix/review/full local gate before a new candidate is deployed.

Read `references/07-live-validation.md`.

# Stage 9 — UAT + final check

UAT agent receives resolved paths for:

```text
gsd-verify-work
verification-before-completion
```

Main then runs final requirement check using its resolved `grill-me` path.

After final gate, delegate docs sync when applicable.

# Spawn contract

Use `assets/templates/agent-spawn.yaml`.

Every child assignment includes:

```yaml
role: <role>
model_tier: STANDARD | CHEAP
model: gpt-5.2
required_skills:
  - id: <canonical-id>
    resolved_as: <installed-name>
    skill_dir: <actual-directory>
    skill_file: <actual-directory>/SKILL.md
```

Main MUST ensure the actual prompt tells the child to read those exact `SKILL.md` files before work.

# Failure handling

Use:

```text
SKILL_UNAVAILABLE
```

when Main cannot resolve a mandatory skill.

Use:

```text
SKILL_PATH_INVALID
```

when a child receives a path that no longer resolves to the expected skill.

Neither status can PASS a gate.

Do not allow children to search for alternate workflow skills; return to Main for re-resolution.

For a BPMN-applicable feature, missing BPMN skills or `validator: FAIL` is also a hard pre-planning failure.

# Completion definitions

Task complete only when implementation, tests, required reviewers, skill evidence, and blocking finding gates pass.

Phase complete only when all tasks + phase verification pass.

Feature complete only when:

- requirements traceable;
- BPMN design gate PASS when applicable;
- validated BPMN semantics are preserved by the implementation when applicable;
- all phases PASS;
- local integration/live/E2E/regression PASS;
- exact local-tested candidate deployed through CD;
- test-env integration/live/E2E/regression PASS;
- UAT PASS;
- final Grill check PASS;
- docs synchronized;
- zero unresolved BLOCKER/HIGH;
- no unresolved skill/path errors.

## Reference map

Load only as needed:

- `references/01-workflow.md` — base state machine and hard gates.
- `references/02-documentation.md` — docs layout.
- `references/03-model-routing.md` — model tiers.
- `references/04-agent-contracts.md` — spawn contract including concrete skill paths.
- `references/05-review-gates.md` — review policy.
- `references/06-phase-planning.md` — plan sizing/gates.
- `references/07-live-validation.md` — local-first + CD/test-env validation.
- `references/08-rule-routing.md` — engineering rule routing.
- `references/09-skill-routing.md` — canonical role skills, discovery, concrete path resolution, prompt requirements, including BPMN roles.

Templates live under `assets/templates/`.
