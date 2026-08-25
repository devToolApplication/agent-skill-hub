# Model Routing and Spawn Policy

## Logical tiers

This workflow MUST keep three logical model tiers:

```text
PREMIUM  = high-leverage orchestration and final decisions
STANDARD = implementation and reasoning-heavy subagent work
CHEAP    = bounded/mechanical subagent work
```

Current runtime mapping:

```text
PREMIUM  -> gpt-5.5
STANDARD -> gpt-5.2
CHEAP    -> gpt-5.2
```

`STANDARD` and `CHEAP` intentionally resolve to the same physical model today. They remain separate logical tiers so routing semantics stay stable and the physical model mapping can change later without rewriting workflow rules.

## Tier authority

### PREMIUM

`PREMIUM` is reserved for the Main Orchestrator.

Default runtime model:

```text
gpt-5.5
```

Main owns only high-leverage coordination and decisions:

- user interaction;
- workflow/feature state;
- requirement interpretation;
- decomposition into bounded assignments;
- choosing role and model tier for each subagent;
- synthesizing returned evidence/results;
- resolving conflicting reviewer/research results;
- architecture, scope, and requirement decisions;
- PASS / FAIL / BLOCKED gate decisions;
- next-state routing.

Spawned subagents MUST NOT use `PREMIUM` unless an explicit future workflow policy changes this rule.

### STANDARD

`STANDARD` is for subagent work requiring material reasoning, implementation judgment, or deeper review.

Current model:

```text
gpt-5.2
```

Default STANDARD roles:

- GSD planner;
- implementation/code agent;
- complex debugger;
- code reviewer;
- architecture reviewer;
- security reviewer;
- performance reviewer;
- complex API/database reviewer;
- phase-level deep reviewer.

### CHEAP

`CHEAP` is for narrow, deterministic, evidence-oriented, or mechanical subagent work.

Current model:

```text
gpt-5.2
```

Default CHEAP roles:

- repository/file researcher;
- source inspector;
- library/options researcher;
- GSD researcher;
- simple plan checker;
- specification reviewer;
- test runner/reviewer;
- command runner;
- simple API/database reviewer;
- live API tester;
- browser/E2E executor;
- workflow tester;
- data validator;
- documentation synchronization agent.

## Runtime resolution

Main chooses a logical tier, then runtime resolves the tier to a physical model.

```text
role
  -> logical tier
  -> model profile
  -> physical model
```

Example:

```text
Code Reviewer
  -> STANDARD
  -> gpt-5.2
```

```text
Spec Reviewer
  -> CHEAP
  -> gpt-5.2
```

```text
Main Orchestrator
  -> PREMIUM
  -> gpt-5.5
```

The spawn contract SHOULD preserve both `model_tier` and the resolved `model` for auditability.

## SPAWN-FIRST is mandatory

Delegation is not an optimization hint. It is the default execution policy.

Before main performs any technical/repository/execution task, it MUST ask:

> Can this be expressed as a bounded assignment with clear inputs, permissions, and structured output?

If YES, main MUST spawn a subagent instead of doing the work itself.

The burden of proof is on **not spawning**.

Main MUST delegate by default:

- repository exploration;
- file discovery;
- reading many implementation files;
- code behavior extraction;
- library/framework research;
- alternative comparison;
- detailed phase planning;
- implementation-plan drafting/checking;
- production-code changes;
- test creation;
- routine command/test execution;
- code/spec/test review;
- security/architecture/API/DB/UI/performance review;
- debugging evidence collection;
- integration verification;
- live/E2E execution;
- large documentation drafting/synchronization.

Main MAY directly inspect only the minimum evidence necessary to:

1. form a bounded assignment;
2. resolve conflicts between returned results;
3. make a global architecture/scope/requirement decision;
4. verify that gate evidence is sufficient.

Main MUST NOT redo delegated work merely to double-check it. Spawn another independent reviewer/validator when second-pass evidence is needed.

## Split instead of taking over

If a task is too broad for one subagent, main MUST first split it.

```text
broad problem
-> identify independent questions/work units
-> assign CHEAP/STANDARD tier per unit
-> spawn multiple subagents
-> receive structured results
-> PREMIUM main synthesizes/decides
-> spawn bounded STANDARD/CHEAP subagents for execution
```

Main taking over implementation is a workflow violation, not a normal escalation path.

## Parallel-first policy

When two or more assignments are independent and do not write overlapping state, spawn them concurrently.

Examples:

```text
CHEAP repo research A ------┐
CHEAP library research B ---+--> PREMIUM main synthesis
CHEAP evidence research C --┘
```

```text
CHEAP spec reviewer --------┐
CHEAP test reviewer --------+--> PREMIUM main gate
STANDARD code reviewer -----┤
STANDARD security reviewer -┘
```

Do not parallelize overlapping writers unless the plan explicitly isolates their write sets.

## Failure policy

Do not promote a spawned worker to `PREMIUM` merely because it failed.

```text
Attempt 1
-> assigned CHEAP/STANDARD agent

Attempt 2
-> same tier with clearer evidence/findings

Attempt 3
-> fresh agent with narrower scope

Attempt 4
-> split investigation across multiple CHEAP/STANDARD agents
-> PREMIUM main synthesizes root cause/direction
-> fresh STANDARD implementation agent

Still unresolved
-> BLOCKED with evidence
```

Subagents MUST return `UNCERTAIN` or `BLOCKED` rather than invent certainty.

## Runtime enforcement

The runtime invoking this workflow MUST resolve logical tiers using the model profile.

Current required mapping:

```yaml
model_tiers:
  PREMIUM:
    model: gpt-5.5
    spawn_allowed: false
  STANDARD:
    model: gpt-5.2
    spawn_allowed: true
  CHEAP:
    model: gpt-5.2
    spawn_allowed: true
```

The Main Orchestrator uses `PREMIUM`.
Every normal spawned agent uses either `STANDARD` or `CHEAP` according to role/task complexity.
