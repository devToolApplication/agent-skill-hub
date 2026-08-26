---
name: autonomous-dev-workflow
description: Orchestrate end-to-end multi-agent software delivery with Grill Me requirements discovery, brainstorming, GSD planning, skill-aware subagents, TDD implementation, independent reviews, local-first integration/live/E2E gates, CD deployment to test environment, test-environment revalidation, UAT, and final documentation sync. Use PREMIUM for main orchestration and STANDARD/CHEAP for spawned workers. Main is spawn-first and parallel-first; workers must receive explicit required skills before execution.
---

# Autonomous Dev Workflow

## Purpose

Run a feature through a deterministic multi-agent lifecycle while keeping the PREMIUM Main Orchestrator focused on:

```text
receive
→ decompose
→ route
→ synthesize
→ decide
→ gate
```

Main is not the normal coder, tester, researcher, reviewer, debugger, or live-test worker.

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

## Skill routing is mandatory

Model routing and skill routing are independent:

```text
ROLE
├─ model_tier -> physical model
└─ required_skills / conditional_skills -> execution method
```

Before every spawn, Main MUST resolve:

1. role;
2. model tier;
3. required skills;
4. applicable conditional skills;
5. exact inputs/context;
6. permissions;
7. expected output schema.

Read `references/09-skill-routing.md` before spawning any implementation, reviewer, debugger, planner, live-test, or UAT agent.

If a required skill is unavailable, the subagent MUST return `SKILL_UNAVAILABLE`; it MUST NOT silently substitute a different process.

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

### MAIN-004 — Parallelize independent work

When assignments are independent and have no overlapping write set, Main SHOULD use:

```text
dispatching-parallel-agents
```

and spawn them concurrently.

### MAIN-005 — Narrow context

Every subagent receives only relevant:

- objective;
- requirement IDs;
- files/docs/diff;
- standards;
- required skills;
- permissions;
- expected output;
- stop conditions.

### MAIN-006 — Independent verification

Implementers never approve themselves.

Every non-trivial implementation task requires independent:

- Specification Reviewer;
- Test Reviewer;
- Code Reviewer;
- applicable dynamic reviewers.

### MAIN-007 — Evidence before PASS

Never accept `done`, `fixed`, `tests pass`, or `deployed` without inspectable evidence.

### MAIN-008 — No silent scope/architecture change

Subagents report conflicts. Main owns final requirement, scope, architecture, reviewer-conflict, and gate decisions.

## Main-owned orchestration skills

Main uses these capabilities when their stage is active:

```yaml
requirement_discovery:
  - grill-me

technical_design:
  - brainstorming

parallel_dispatch:
  - dispatching-parallel-agents

final_requirement_check:
  - grill-me
```

Main may spawn research agents during brainstorming, but Main retains final architecture authority.

## Canonical workflow

```text
USER ROUGH PLAN
      ↓
PREMIUM MAIN
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
  └─ test-driven-development
      ↓
PARALLEL REVIEWS
  ├─ CHEAP Spec Reviewer
  │    └─ verification-before-completion
  ├─ CHEAP Test Reviewer
  │    └─ verification-before-completion
  ├─ STANDARD Code Reviewer
  │    ├─ requesting-code-review
  │    └─ verification-before-completion
  └─ dynamic reviewers
      ↓
PREMIUM MAIN TASK GATE
      ↓
ALL TASKS/P HASES PASS
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

Read `references/01-workflow.md` for the exact state machine.

# Stage 0 — Feature initialization

Create/use:

```text
docs/05-features/<YYYYMMDD-feature-name>/
```

Follow `references/02-documentation.md`.

Main may delegate mechanical workspace creation to a CHEAP documentation/repository agent.

# Stage 1 — Requirement discovery

Main runs `grill-me` for requirement discovery.

Repository evidence needed to answer questions SHOULD be gathered by CHEAP research agents.

Produce:

- user spec;
- AI spec;
- stable `REQ-*`, `NFR-*`, `SEC-*`, `PERF-*` IDs;
- acceptance criteria;
- scenarios;
- scope/out-of-scope.

Do not proceed while critical intent is unresolved.

# Stage 2 — Technical design

Main runs `brainstorming`.

Default pattern:

```text
identify independent questions
→ dispatch CHEAP research agents in parallel
→ optionally dispatch STANDARD specialist/challenger
→ collect evidence/options/tradeoffs
→ PREMIUM Main synthesizes and decides
```

Research agents do not own architecture decisions.

# Stage 3 — Phase planning

Use GSD planning semantics:

```text
CHEAP research
→ STANDARD planner
→ CHEAP plan checker
→ revision until PASS/BLOCKED
```

Canonical role skill:

```text
gsd-plan-phase
```

Every implementation plan MUST include a `Required Skills` section. Use `assets/templates/implementation-plan.md`.

No coding before plan-check PASS.

# Stage 4 — Implementation

Spawn a fresh STANDARD implementation agent.

Required skill:

```yaml
required_skills:
  - test-driven-development
```

Conditional skills:

```yaml
conditional_skills:
  on_debug:
    - systematic-debugging
  on_review_fix:
    - receiving-code-review
```

Implementation agent may modify assigned code/tests, but may not change requirements/architecture or approve itself.

# Stage 5 — Parallel task review

Main SHOULD use `dispatching-parallel-agents` to spawn independent reviewers.

Mandatory mapping:

```yaml
specification_reviewer:
  model_tier: CHEAP
  required_skills:
    - verification-before-completion

test_reviewer:
  model_tier: CHEAP
  required_skills:
    - verification-before-completion

code_reviewer:
  model_tier: STANDARD
  required_skills:
    - requesting-code-review
    - verification-before-completion
```

Dynamic reviewers follow `references/05-review-gates.md` and `references/09-skill-routing.md`.

# Stage 6 — Repair loop

Clear review finding:

```text
STANDARD implementation agent
→ receiving-code-review
→ test-driven-development
→ verification
→ affected reviewers again
```

Unknown root cause:

```text
STANDARD debugger
→ systematic-debugging
→ root-cause evidence
→ STANDARD implementation agent
→ test-driven-development
→ reviewers again
```

Main does not perform routine debugging itself.

# Stage 7 — Phase gate

After all task gates in a phase PASS, spawn a fresh phase reviewer:

```yaml
model_tier: STANDARD
required_skills:
  - gsd-code-review
  - gsd-validate-phase
  - verification-before-completion
```

Conditionally add:

- `gsd-secure-phase`;
- `gsd-ui-review`.

Cross-task gaps become explicit gap plans and return through normal planning/implementation/review.

# Stage 8 — Local-first integration and live validation

This order is mandatory:

```text
ALL PHASES PASS
→ LOCAL_INTEGRATION_VERIFY
→ LOCAL_LIVE_TESTING
→ READY_FOR_CD_TEST
→ CD_TEST_DEPLOYING
→ TEST_ENV_INTEGRATION_VERIFY
→ TEST_ENV_LIVE_TESTING
→ UAT
```

There is no normal path from implementation directly to CD/test environment.

## Local integration

Spawn verifier with:

```yaml
required_skills:
  - verification-before-completion
```

## Local live/E2E

Run every mandatory live/E2E scenario locally before push/CD.

Default agents are CHEAP and require:

```yaml
required_skills:
  - verification-before-completion
```

For browser/UI scenarios, add the installed browser/Playwright skill explicitly.

Local gate requires:

- integration PASS;
- mandatory live/E2E PASS;
- regression PASS;
- required skill evidence;
- zero BLOCKER/HIGH;
- no code change after PASS without revalidation.

Only then finalize candidate revision and push.

## CD/test environment

Deploy the exact candidate that passed local gate.

Verify deployed SHA/version before testing.

Then rerun:

- integration;
- API live;
- workflow live;
- data validation;
- browser/E2E;
- regression.

Test-env agents also require `verification-before-completion` plus scenario-specific installed skills.

If test env finds a bug:

```text
capture evidence
→ reproduce/fix LOCAL
→ code review/test review
→ FULL LOCAL GATE again
→ new candidate
→ CD again
→ test env again
```

Never patch shared test environment to bypass local-first validation.

Read `references/07-live-validation.md`.

# Stage 9 — UAT and final audit

UAT begins only after both local and test-env live gates PASS.

Spawn UAT agent with:

```yaml
required_skills:
  - gsd-verify-work
  - verification-before-completion
```

After UAT PASS, Main runs final `grill-me` check against original intent.

Then verify:

- requirement traceability complete;
- all phases PASS;
- local gate PASS;
- deployed candidate identity verified;
- test-env gate PASS;
- UAT PASS;
- no BLOCKER/HIGH;
- current-state service/architecture docs synchronized.

# Spawn contract

Every spawned assignment MUST include:

```yaml
agent_id: "<unique-id>"
role: "<role>"
model_tier: "<STANDARD|CHEAP>"
model: "gpt-5.2"
required_skills:
  - "<skill-id>"
conditional_skills: {}
objective: "<bounded objective>"
inputs: []
standards: []
permissions: {}
expected_output:
  schema: "<schema>"
stop_conditions: []
```

Use `assets/templates/agent-spawn.yaml`.

# Skill evidence

Every result SHOULD include:

```yaml
skills_used:
  - <skill-id>
missing_skills: []
```

A mandatory role returning `SKILL_UNAVAILABLE` cannot PASS its gate.

# Completion

A task is DONE only after implementation/tests and all mandatory/applicable reviewers PASS.

A phase is DONE only after all tasks and phase-level validation PASS.

A feature is DONE only after:

```text
Requirements PASS
All phases PASS
Local integration PASS
Local live/E2E/regression PASS
CD candidate identity verified
Test-env integration PASS
Test-env live/E2E/regression PASS
UAT PASS
Final Grill check PASS
Traceability complete
Current-state docs synchronized
BLOCKER/HIGH = 0
```

# Reference map

Load only what is needed:

- `references/01-workflow.md` — lifecycle states and hard gates.
- `references/02-documentation.md` — docs layout and ownership.
- `references/03-model-routing.md` — PREMIUM/STANDARD/CHEAP mapping and spawn-first rules.
- `references/04-agent-contracts.md` — tier + skill aware assignment/result contracts.
- `references/05-review-gates.md` — reviewer mapping, severity, re-review.
- `references/06-phase-planning.md` — phase/plan sizing.
- `references/07-live-validation.md` — local-first + CD/test-env validation.
- `references/08-rule-routing.md` — project standards/reviewer triggers.
- `references/09-skill-routing.md` — canonical role -> required/conditional skill mapping.

Templates live under `assets/templates/`.
