# Task Result Contract

Every agent returns structured evidence. `COMPLETE` is invalid without evidence required by its workflow.

```yaml
task_id: BE-APPROVAL-02
agent: dev-be-agent
status: COMPLETE | FIX_REQUIRED | BLOCKED | FAILED

requirements_verified: []
files_changed: []

workflow_evidence:
  steps:
    - id: PREPARE
      status: PASS
    - id: IMPLEMENT
      status: PASS
    - id: SELF_TEST
      status: PASS
      commands: []
    - id: SELF_REVIEW
      status: PASS
      findings: []
    - id: FINAL_VERIFY
      status: PASS

verification:
  commands: []
  passed: []
  failed: []

integration_requests: []
risks: []
open_questions: []
```

Rules:

- `BLOCKED` is never treated as `PASS`.
- A changed implementation invalidates affected previous SELF_TEST, SELF_REVIEW and independent-review evidence.
- Findings fixed during self-review must be documented and followed by a fresh affected test run and fresh self-review.
- Reviewer results use explicit `PASS | FAIL | BLOCKED | NOT_TESTED | NOT_APPLICABLE` semantics.
