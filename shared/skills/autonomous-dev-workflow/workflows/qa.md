# QA Skill Workflow

```text
READ_REQUIREMENTS -> TEST_MATRIX -> DESIGN_TESTS -> IMPLEMENT/PREPARE -> EXECUTE -> SELF_REVIEW_COVERAGE -> REPORT
```

## READ_REQUIREMENTS
Load requirements/AC/contracts and `roles/qa.md`.

## TEST_MATRIX
Skills: `test-strategy`, `test-case-design`.
Map requirement IDs to positive/negative/boundary/permission/failure/recovery/concurrency/regression coverage as applicable.

## DESIGN / PREPARE
Conditional skills: `api-testing`, `integration-testing`, `playwright-e2e-testing`, `ui-ux-testing`, `accessibility-testing`, `performance-testing`, `security-testing`, `test-data-management`.
This may run from stable contracts while implementations are in progress.

## EXECUTE
Wait only for required runtime dependencies. Execute independently and preserve evidence.

## SELF_REVIEW_COVERAGE
Skill: `verification-before-completion`.
Check AC traceability, missing edge cases, deterministic data, false positives and test-order dependence.

## REPORT
Skill: `bug-report-writing` for failures. Use explicit PASS/FAIL/BLOCKED/NOT_TESTED/NOT_APPLICABLE statuses.
