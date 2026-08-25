# Atomic TaskSpec v5

There are four task forms.

## 1. Read task

```text
schema=read-task-v5
task_id
domain=backend|frontend|uiux
worker=<exact worker>
worker_skill=<exact skill path>
objective
questions[]
policy_refs[] exact paths
scope.read_roots[] and/or scope.read_files[]
scope.symbols[] when known
acceptance[]
output=worker-result-v5
```

A read worker returns facts/evidence/unknowns only.

## 2. Write task

Only backend/frontend write workers may receive write-task-v5.

Required:

```text
schema=write-task-v5
task_id
domain=backend|frontend
worker=<matching *_code_edit or *_test_author>
worker_skill=<exact dedicated skill path>
objective
problem.summary
problem.evidence[]
decision.fix_direction
decision.rationale
handoff_refs[] when relevant (for example uiux-spec path)
requirement_ids[] when implementing a design contract
policy_refs[] exact files
scope.allowed_files[] exact paths
scope.allowed_symbols[] when known
scope.may_create_files[] exact paths only
changes[] exactly one entry per writable file
  - file
  - target
  - instruction
  - preserve[]
forbidden[]
acceptance[]
verification.worker_checks[]
verification.parent_followup_commands[]
output=worker-result-v5
```

A write task normally has one objective, one domain, one worker, 1-3 files, and zero unresolved design/architecture decisions.

## 3. UIUX spec verification task

```text
schema=uiux-verify-task-v5
domain=uiux
worker=uiux_spec_verify
worker_skill=.agents/skills/uiux-spec-verify/SKILL.md
spec_ref=<exact uiux-spec-v1 path>
requirement_ids[]
implementation_files[] exact paths
policy_refs[]
acceptance[]
output=worker-result-v5
```

This worker compares evidence to the spec. It does not propose frontend architecture or edit code.

## 4. Command task

```text
schema=command-task-v5
domain=shared
worker=command_runner
worker_skill=.agents/skills/command-runner/SKILL.md
working_directory
commands[] exact commands
mutation_permissions
expected_outputs
output=worker-result-v5
```
