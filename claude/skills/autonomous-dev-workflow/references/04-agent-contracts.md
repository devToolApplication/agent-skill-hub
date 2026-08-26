# Agent Contracts

## Routing contract

Every assignment has two independent routing dimensions:

```text
ROLE
├─ model_tier -> model profile -> physical model
└─ canonical skills -> concrete installed skill paths -> execution method
```

Model routing is defined in `03-model-routing.md`.
Skill/path routing is defined in `09-skill-routing.md`.

## Model-tier contract

```text
PREMIUM  -> gpt-5.5
STANDARD -> gpt-5.2
CHEAP    -> gpt-5.2
```

`PREMIUM` is reserved for the Main Orchestrator. Normal spawned agents MUST use `STANDARD` or `CHEAP`.

## Skill-resolution contract

Before every spawn, Main MUST:

1. resolve the role into canonical `required_skills` and applicable `conditional_skills`;
2. locate the concrete installed directory for every required skill;
3. locate and verify the exact `SKILL.md` file;
4. preserve the canonical ID, installed/aliased name, directory, and file path in the assignment;
5. render the same resolved paths into the human-readable prompt sent to the subagent.

Main should build/cache a session skill index once and reuse it, while revalidating paths when needed.

A subagent MUST NOT choose a different skill implementation by itself.

## Missing/invalid skill handling

If Main cannot resolve a required skill before spawn:

```yaml
status: SKILL_UNAVAILABLE
missing_skills:
  - <skill-id>
```

If a supplied path becomes invalid when the subagent starts:

```yaml
status: SKILL_PATH_INVALID
invalid_skills:
  - id: <skill-id>
    skill_file: <supplied-path>
```

In both cases, return control to Main. Do not silently substitute another workflow or filesystem path.

## Spawn contract

Every spawn MUST specify:

```yaml
agent_id: unique-id
role: role-name
model_tier: STANDARD | CHEAP
model: gpt-5.2

required_skills:
  - id: test-driven-development
    resolved_as: test-driven-development
    skill_dir: <concrete-installed-directory>
    skill_file: <concrete-installed-directory>/SKILL.md

conditional_skills: {}

skill_prompt_policy:
  read_before_work: true
  use_supplied_paths_only: true
  subagent_may_search_alternative_skills: false

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
  - supplied skill path invalid
  - environment blocked
```

Use `assets/templates/agent-spawn.yaml`.

## Required prompt block

Main MUST include a clear block in the actual subagent prompt, for example:

```text
REQUIRED SKILLS — READ BEFORE WORK

- test-driven-development
  Directory: <resolved-directory>
  SKILL.md: <resolved-directory>/SKILL.md

- verification-before-completion
  Directory: <resolved-directory>
  SKILL.md: <resolved-directory>/SKILL.md

Read and follow every SKILL.md above before doing the assignment.
Use exactly the supplied skill paths.
Do not search for an alternative skill implementation.
If any path is invalid, return SKILL_PATH_INVALID to Main.
```

The structured assignment and prompt MUST contain the same skill resolution.

## Canonical role examples

### Implementation agent

```yaml
role: implementation_agent
model_tier: STANDARD
required_skills:
  - id: test-driven-development
    skill_dir: <resolved-directory>
    skill_file: <resolved-directory>/SKILL.md
conditional_skills:
  on_debug:
    - id: systematic-debugging
      skill_dir: <resolved-directory>
      skill_file: <resolved-directory>/SKILL.md
  on_review_fix:
    - id: receiving-code-review
      skill_dir: <resolved-directory>
      skill_file: <resolved-directory>/SKILL.md
```

### Test reviewer

```yaml
role: test_reviewer
model_tier: CHEAP
required_skills:
  - id: verification-before-completion
    skill_dir: <resolved-directory>
    skill_file: <resolved-directory>/SKILL.md
```

### Code reviewer

```yaml
role: code_reviewer
model_tier: STANDARD
required_skills:
  - id: requesting-code-review
    skill_dir: <resolved-directory>
    skill_file: <resolved-directory>/SKILL.md
  - id: verification-before-completion
    skill_dir: <resolved-directory>
    skill_file: <resolved-directory>/SKILL.md
```

### Phase deep reviewer

```yaml
role: phase_deep_reviewer
model_tier: STANDARD
required_skills:
  - id: gsd-code-review
    skill_dir: <resolved-directory>
    skill_file: <resolved-directory>/SKILL.md
  - id: gsd-validate-phase
    skill_dir: <resolved-directory>
    skill_file: <resolved-directory>/SKILL.md
  - id: verification-before-completion
    skill_dir: <resolved-directory>
    skill_file: <resolved-directory>/SKILL.md
```

See `09-skill-routing.md` for the full role matrix and path-resolution policy.

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

When assignments are independent and do not have overlapping write sets, Main SHOULD resolve all child skill paths first, then use `dispatching-parallel-agents` and spawn them concurrently.

Typical group:

```text
CHEAP Spec Reviewer
+ CHEAP Test Reviewer
+ STANDARD Code Reviewer
+ applicable specialist reviewers
```

Each parallel child receives its own exact role-specific skill paths.

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
status: COMPLETE | PARTIAL | BLOCKED | SKILL_UNAVAILABLE | SKILL_PATH_INVALID
plan_id: P02-03
requirements:
  REQ-001: implemented
skills_used:
  - id: test-driven-development
    skill_file: <resolved-directory>/SKILL.md
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
invalid_skills: []
```

## Research result

```yaml
status: COMPLETE | BLOCKED | SKILL_UNAVAILABLE | SKILL_PATH_INVALID
skills_used: []
facts: []
options: []
tradeoffs: []
risks: []
unknowns: []
missing_skills: []
invalid_skills: []
recommendation: optional
```

Recommendations are advisory; Main owns architectural decisions.

## Communication rule

Prefer:

```text
PREMIUM Main
  -> resolve concrete skill paths
  -> structured assignment + explicit skill-path prompt
STANDARD/CHEAP Subagent
  -> read supplied SKILL.md files
  -> structured evidence/result + skills_used
PREMIUM Main
  -> synthesize / gate / next assignment
```

Main SHOULD NOT re-perform delegated work merely to obtain a second answer. Spawn another reviewer/validator with the appropriate resolved skill paths.
