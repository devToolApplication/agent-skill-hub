# Agent Contracts

## Routing contract

Every assignment has two independent routing dimensions:

```text
ROLE
├─ model_tier -> model profile -> physical model
└─ required_skills / conditional_skills -> execution method
```

Model routing is defined in `03-model-routing.md`.
Skill routing is defined in `09-skill-routing.md`.

## Model-tier contract

```text
PREMIUM  -> gpt-5.5
STANDARD -> gpt-5.2
CHEAP    -> gpt-5.2
```

`PREMIUM` is reserved for the Main Orchestrator. Normal spawned agents MUST use `STANDARD` or `CHEAP`.

## Skill contract

Before every spawn, Main MUST resolve the role into explicit `required_skills` and any applicable `conditional_skills`.

A spawned agent MUST load/use every listed required skill.

If a required skill cannot be resolved, return:

```yaml
status: SKILL_UNAVAILABLE
missing_skills:
  - <skill-id>
```

Do not silently substitute another workflow.

## Spawn contract

Every spawn MUST specify:

```yaml
agent_id: unique-id
role: role-name
model_tier: STANDARD | CHEAP
model: gpt-5.2
required_skills:
  - skill-id
conditional_skills: {}
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
  - required skill unavailable
  - environment blocked
```

Use `assets/templates/agent-spawn.yaml`.

## Canonical role examples

### Implementation agent

```yaml
role: implementation_agent
model_tier: STANDARD
required_skills:
  - test-driven-development
conditional_skills:
  on_debug:
    - systematic-debugging
  on_review_fix:
    - receiving-code-review
```

### Test reviewer

```yaml
role: test_reviewer
model_tier: CHEAP
required_skills:
  - verification-before-completion
```

### Code reviewer

```yaml
role: code_reviewer
model_tier: STANDARD
required_skills:
  - requesting-code-review
  - verification-before-completion
```

### Phase deep reviewer

```yaml
role: phase_deep_reviewer
model_tier: STANDARD
required_skills:
  - gsd-code-review
  - gsd-validate-phase
  - verification-before-completion
```

See `09-skill-routing.md` for the full role matrix.

## Delegation-first rule

Main MUST prefer spawning subagents over performing bounded technical work itself.

Delegate by default:

- repository exploration and file discovery;
- source inspection and evidence collection;
- technical research and option comparison;
- phase-detail planning and plan checking;
- implementation and test authoring;
- command/test execution;
- code/spec/test/security/architecture/API/DB/UI/performance review;
- debugging investigation;
- integration and local/test-env live validation;
- documentation drafting and synchronization.

Main receives structured results, synthesizes them, makes global decisions, enforces gates, and chooses the next assignment.

When a task is too broad, split it into narrower assignments before considering direct execution.

## Parallel-first rule

When assignments are independent and do not have overlapping write sets, Main SHOULD use `dispatching-parallel-agents` and spawn them concurrently.

Typical group:

```text
CHEAP Spec Reviewer
+ CHEAP Test Reviewer
+ STANDARD Code Reviewer
+ applicable specialist reviewers
```

Each parallel child still receives its own role-specific skills.

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
- run tests/analyzers required for verification.

Cannot:
- silently patch production code;
- alter requirements/architecture.

### Researcher

Read-only. Returns facts/options/tradeoffs/unknowns.

### Live test agent

Can run local or deployed scenarios and capture evidence. Cannot patch production code.

## Implementation result

```yaml
status: COMPLETE | PARTIAL | BLOCKED | SKILL_UNAVAILABLE
plan_id: P02-03
requirements:
  REQ-001: implemented
skills_used:
  - test-driven-development
files_changed: []
tests_added: []
tests_modified: []
commands_executed:
  - command: "..."
    result: PASS | FAIL
deviations: []
known_risks: []
uncertainties: []
missing_skills: []
```

## Research result

```yaml
status: COMPLETE | BLOCKED | SKILL_UNAVAILABLE
skills_used: []
facts: []
options: []
tradeoffs: []
risks: []
unknowns: []
missing_skills: []
recommendation: optional
```

Recommendations are advisory; Main owns architectural decisions.

## Communication rule

Prefer:

```text
PREMIUM Main -> structured assignment including skills
STANDARD/CHEAP Subagent -> structured evidence/result + skills_used
PREMIUM Main -> synthesize / gate / next assignment
```

Main SHOULD NOT re-perform delegated work merely to obtain a second answer. Spawn another reviewer/validator with the appropriate skill contract.
