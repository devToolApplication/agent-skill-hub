# Agent Contracts

## Model-tier contract

This workflow uses logical tiers in every assignment:

```text
PREMIUM  -> gpt-5.5
STANDARD -> gpt-5.2
CHEAP    -> gpt-5.2
```

`PREMIUM` is reserved for the Main Orchestrator.
Normal spawned agents MUST use either `STANDARD` or `CHEAP`.

The purpose of the tier is routing semantics. The physical model is resolved from the model profile.

## Spawn contract

Every spawn MUST specify both logical tier and resolved model:

```yaml
agent_id: unique-id
role: role-name
model_tier: STANDARD | CHEAP
model: gpt-5.2
objective: concise bounded assignment
inputs:
  - exact files, excerpts, diffs, commands, or requirement IDs
standards:
  - only applicable project standards
permissions:
  read_code: true
  write_code: false
  write_tests: false
  run_tests: false
  read_docs: true
  write_feature_docs: false
  write_service_docs: false
  modify_requirements: false
  modify_architecture: false
  run_live_system: false
expected_output:
  schema: named-contract
stop_conditions:
  - assignment complete
  - evidence insufficient
  - environment blocked
```

Use `assets/templates/agent-spawn.yaml`.

## Default tier by role

Use `STANDARD` when the task requires substantial implementation/reasoning judgment:

- implementation/code agent;
- GSD planner;
- complex debugger;
- code reviewer;
- architecture reviewer;
- security reviewer;
- performance reviewer;
- complex API/database reviewer;
- phase-level deep reviewer.

Use `CHEAP` when the task is narrow, deterministic, evidence-oriented, or mechanical:

- repository/file researcher;
- source inspector;
- library/options researcher;
- GSD researcher;
- simple plan checker;
- specification reviewer;
- test reviewer/runner;
- command runner;
- simple API/database reviewer;
- live/E2E executor;
- data validator;
- documentation sync agent.

Main may override `CHEAP <-> STANDARD` based on task complexity, but MUST NOT assign `PREMIUM` to a normal spawned agent.

## Delegation-first rule

The main agent MUST prefer spawning subagents over performing bounded technical work itself.

Delegate by default:

- repository exploration and file discovery;
- source inspection and evidence collection;
- technical research and option comparison;
- phase-detail planning and plan checking;
- implementation and test authoring;
- command/test execution;
- code/spec/test/security/architecture/API/DB/UI/performance review;
- debugging investigation;
- integration and live/E2E validation;
- documentation drafting and synchronization.

Main should receive structured results, synthesize them, make global decisions, enforce gates, and choose the next assignment.

When a task is too broad to delegate safely, main MUST first split it into narrower assignments rather than taking over execution.

Main may directly inspect only the minimum evidence necessary to construct an assignment, resolve conflicting subagent results, or verify a gate.

## Parallel-first rule

When multiple assignments are independent and do not have overlapping write sets, main SHOULD spawn them concurrently.

Typical parallel groups:

```text
CHEAP repo research + CHEAP library research + CHEAP architecture evidence
```

```text
CHEAP spec reviewer + CHEAP test reviewer + STANDARD code reviewer + applicable specialist reviewers
```

Do not parallelize overlapping writers unless the plan explicitly isolates their files/symbols.

## Least privilege

### Code agent

Can normally:
- read/write assigned production code;
- read/write assigned tests;
- run tests/verification commands.

Cannot:
- rewrite requirements;
- approve architecture changes;
- globally approve its own task.

### Reviewer

Can normally:
- read code/docs/diff;
- run tests or analyzers required for verification.

Cannot:
- silently patch production code;
- alter requirements/architecture.

### Researcher

Read-only. Returns facts/options/tradeoffs/unknowns.

### Live test agent

Can run real systems/scenarios and capture evidence. Cannot patch production code.

## Implementation result

```yaml
status: COMPLETE | PARTIAL | BLOCKED
plan_id: P02-03
requirements:
  REQ-001: implemented
files_changed: []
tests_added: []
tests_modified: []
commands_executed:
  - command: "..."
    result: PASS | FAIL
deviations: []
known_risks: []
uncertainties: []
```

## Research result

```yaml
status: COMPLETE | BLOCKED
facts: []
options: []
tradeoffs: []
risks: []
unknowns: []
recommendation: optional
```

Recommendations are advisory; main owns architectural decisions.

## Communication rule

Prefer:

```text
PREMIUM Main -> structured assignment
STANDARD/CHEAP Subagent -> structured result
PREMIUM Main -> synthesize / gate / next assignment
```

Avoid long free-form chains between subagents.

Main SHOULD NOT re-perform delegated work merely to obtain a second answer. If independent verification is required, spawn another `STANDARD` or `CHEAP` reviewer with the appropriate contract.
