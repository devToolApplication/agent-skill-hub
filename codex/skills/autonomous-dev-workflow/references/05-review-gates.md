# Review Gates

## Mandatory task reviewers

Every non-trivial plan requires independent:

1. Specification Reviewer
2. Test Reviewer
3. Code Reviewer

Dispatch in parallel when they only read shared evidence.

## Dynamic reviewers

Trigger based on changed area:

- Architecture Reviewer: new modules, dependency direction, responsibilities, major refactor.
- DB Reviewer: schema/index/query/migration/transaction semantics.
- API/Event Reviewer: contracts, DTOs, public integrations, compatibility.
- Security Reviewer: auth/authz/secrets/uploads/external URLs/tenant isolation/sensitive data.
- Performance Reviewer: realtime/high-throughput/concurrency/batching/cache/streaming.
- UI/UX Reviewer: layout, interaction, forms, navigation, accessibility, responsive behavior.

## Review priority

1. explicit user requirements;
2. AI spec;
3. explicit architecture/design decisions;
4. project review policy;
5. engineering standards;
6. service current-state docs;
7. phase spec;
8. implementation plan;
9. existing repository convention;
10. generic best practice;
11. reviewer preference.

A reviewer must not fail a task based purely on personal preference when higher-priority project decisions are satisfied.

## Common result contract

```yaml
reviewer: code-review
status: PASS | FAIL | UNCERTAIN | BLOCKED
blocking_findings:
  - id: CR-001
    rule: ARCH-001
    severity: BLOCKER | HIGH
    file: path
    evidence: precise evidence
    issue: concise problem
    expected: desired behavior
    required_fix: bounded correction
warnings:
  - id: CR-W001
    rule: CODE-101
    severity: MEDIUM | LOW
    issue: concise problem
    suggestion: optional improvement
verified:
  - item: requirement-or-rule
    status: PASS
uncertainties: []
```

Use `assets/templates/review-result.yaml`.

## Severity

Default:

- `BLOCKER`: FAIL
- `HIGH`: FAIL
- `MEDIUM`: warning unless project policy says blocking
- `LOW`: warning

This prevents endless autonomous loops over cosmetic preferences.

## Spec Reviewer

Must map every assigned requirement to PASS/FAIL/UNCERTAIN and provide code/evidence references.

## Test Reviewer

Must independently execute relevant tests when possible. It verifies positive, negative, boundary, regression, important failure, concurrency, and integration behavior as applicable. Never trust only the implementer's claim that tests passed.

Test reviewer is read-only by default; missing tests become findings for the code agent.

## Code Reviewer

Check correctness, architecture boundaries, maintainability, error handling, logging, API compatibility, data consistency, transactions, concurrency, resource lifecycle, duplication, complexity, dead code, performance/security risk, and backward compatibility according to applicable project rules.

## Aggregation

Main:
1. deduplicates same-root-cause findings;
2. preserves source reviewer + rule ID + evidence;
3. sorts by severity;
4. resolves contradictory findings itself;
5. sends one correction bundle to implementation.

## Re-review

After a fix, re-run every reviewer whose dimension may have changed. Example: a code-review fix alters an API contract, so rerun Code + Spec + Test + API reviewers.

## Task PASS

Only when all mandatory/applicable reviewers PASS and unresolved BLOCKER/HIGH count is zero.
