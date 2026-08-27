# Agent Contracts

## Dedicated Agent Dispatch

Mỗi nhiệm vụ trong workflow được điều phối trực tiếp tới một Dedicated Agent tương ứng. Mỗi Agent được đóng gói sẵn tập Skills, Tools và MCP servers:

```text
ASSIGNMENT
└─ target_agent (subagent_type)
   ├─ tools & mcp access (isolated per agent)
   └─ pre-configured skills
```

## Agent Catalog

| Agent Name | Description | Tools / MCP | Skills |
|---|---|---|---|
| `ba-agent` | Business Analysis & Spec | Read, Write, Edit, Grep, Glob | `requirement-analysis`, `user-story-writing`, `acceptance-criteria`, `functional-specification` |
| `architect-agent` | System Architecture & Design | Read, Write, Edit, Grep, Glob, MongoDB MCP | `system-architecture`, `microservice-design`, `api-contract-design`, `architecture-decision-record` |
| `dev-be-agent` | Backend Development | Read, Write, Edit, Bash, Grep, Glob, MongoDB MCP | `test-driven-development`, `systematic-debugging`, `api-contract-design`, `integration-patterns` |
| `dev-fe-agent` | Frontend Development | Read, Write, Edit, Bash, Grep, Glob | `dev-fe-design-skills`, `tailwind-design-system`, `responsive-layout`, `angular-animations-patterns` |
| `test-qa-agent` | QA & Testing | Read, Write, Edit, Bash, Grep, Glob | `test-strategy`, `test-case-design`, `playwright-e2e-testing`, `api-testing`, `bug-report-writing` |
| `bpmn-agent` | BPMN Workflow Design | Read, Write, Edit, Grep, Glob | `bpmn-modeler`, `bpmn-design`, `bpmn-validator`, `bpmn-architect` |
| `trade-analysis-agent` | Trade Strategy & Rules | Read, Write, Edit, Grep, Glob, MongoDB MCP | `requirement-analysis`, `data-requirement-spec`, `technical-risk-assessment` |

## Spawn Contract

Khi spawn subagent, Main chỉ định trực tiếp qua `subagent_type`:

```yaml
agent_id: unique-id
subagent_type: ba-agent | architect-agent | dev-be-agent | dev-fe-agent | test-qa-agent | bpmn-agent | trade-analysis-agent
prompt: |
  <Mô tả nhiệm vụ cụ thể, input từ role trước, và output mong muốn>
```

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
