# Task Assignment Contract

Every spawned task MUST be bounded and self-contained enough that the child does not have to rediscover scope.

```yaml
task_id: BE-APPROVAL-02
feature_id: KOC-APPROVAL
phase_id: PHASE-02
agent: dev-be-agent

objective: Implement approve/reject command API.
requirement_ids: [KOC-REQ-12, KOC-REQ-13]

design_dependencies: [API-CONTRACT-01]
runtime_dependencies: []
write_conflicts: []

ownership:
  write_paths:
    - backend/koc/approval/**
  read_paths:
    - backend/koc/**
    - backend/common/**
  forbidden_write_paths:
    - backend/koc/query/**
    - backend/shared-registration/**

required_context:
  - docs/05-features/koc-approval/README.md
  - docs/03-architecture/...

required_skills:
  - test-driven-development
  - verification-before-completion
conditional_skills:
  systematic-debugging: on_test_or_runtime_failure
  receiving-code-review: on_independent_review_feedback

workflow: workflows/dev-backend.md
role_rules: roles/dev-backend.md
applicable_project_rules: []

acceptance_criteria: []
verification_commands: []
reviewers: [code, api]
expected_output: contracts/task-result.md
stop_conditions: []
```

## Forbidden fields

Assignments MUST NOT contain runtime/model selection such as `model`, `model_tier`, `provider`, or aliases. Agent runtime configuration owns that decision.

## Ownership

A child may write only inside `write_paths`. If implementation requires a forbidden/shared path, return an `integration_request` or `BLOCKED_SCOPE_CHANGE`; do not silently widen scope.
