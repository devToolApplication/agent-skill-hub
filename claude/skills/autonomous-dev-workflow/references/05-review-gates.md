# Review Gates

## Mandatory task reviewers

Every non-trivial plan requires independent:

1. Specification Reviewer
2. Test Reviewer
3. Code Reviewer

Main SHOULD dispatch them in parallel using `dispatching-parallel-agents` when they only read shared evidence.

Each reviewer MUST receive role-specific skills from `09-skill-routing.md`.

## Mandatory reviewer skill mapping

### Specification Reviewer

```yaml
model_tier: CHEAP
required_skills:
  - verification-before-completion
```

Must map every assigned requirement to PASS/FAIL/UNCERTAIN and cite evidence.

### Test Reviewer

```yaml
model_tier: CHEAP
required_skills:
  - verification-before-completion
```

Must independently execute relevant tests when possible. Verify positive, negative, boundary, regression, important failure, concurrency, and integration behavior as applicable. Never trust only the implementer's claim that tests passed.

Test reviewer is read-only by default; missing tests become findings for the implementation agent.

### Code Reviewer

```yaml
model_tier: STANDARD
required_skills:
  - requesting-code-review
  - verification-before-completion
```

Check correctness, architecture boundaries, maintainability, error handling, logging, API compatibility, data consistency, transactions, concurrency, resource lifecycle, duplication, complexity, dead code, performance/security risk, and backward compatibility according to applicable project rules.

## Dynamic reviewers

Trigger based on changed area:

- Architecture Reviewer: new modules, dependency direction, responsibilities, major refactor.
- DB Reviewer: schema/index/query/migration/transaction semantics.
- API/Event Reviewer: contracts, DTOs, public integrations, compatibility.
- Security Reviewer: auth/authz/secrets/uploads/external URLs/tenant isolation/sensitive data.
- Performance Reviewer: realtime/high-throughput/concurrency/batching/cache/streaming.
- UI/UX Reviewer: layout, interaction, forms, navigation, accessibility, responsive behavior.

Default skills:

```yaml
architecture_reviewer:
  model_tier: STANDARD
  required_skills:
    - requesting-code-review
    - verification-before-completion

security_reviewer:
  model_tier: STANDARD
  required_skills:
    - verification-before-completion
  conditional_skills:
    phase_security_review:
      - gsd-secure-phase

uiux_reviewer:
  model_tier: CHEAP | STANDARD
  required_skills:
    - verification-before-completion
  conditional_skills:
    phase_ui_review:
      - gsd-ui-review
```

DB/API/performance reviewers MUST at least use `verification-before-completion`; attach additional installed project/domain skills when available.

## Phase-level review

After all task gates in a phase PASS, use a fresh phase reviewer:

```yaml
role: phase_deep_reviewer
model_tier: STANDARD
required_skills:
  - gsd-code-review
  - gsd-validate-phase
  - verification-before-completion
```

Add `gsd-secure-phase` for security-sensitive phases and `gsd-ui-review` for UI-heavy phases.

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
status: PASS | FAIL | UNCERTAIN | BLOCKED | SKILL_UNAVAILABLE
skills_used:
  - requesting-code-review
  - verification-before-completion
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
missing_skills: []
```

Use `assets/templates/review-result.yaml`.

## Severity

- `BLOCKER`: FAIL
- `HIGH`: FAIL
- `MEDIUM`: warning unless project policy says blocking
- `LOW`: warning

## Skill-unavailable gate

A mandatory reviewer returning `SKILL_UNAVAILABLE` cannot PASS the gate. Main must resolve/install/map the required skill or mark the workflow BLOCKED.

## Aggregation

Main:
1. deduplicates same-root-cause findings;
2. preserves source reviewer + rule ID + evidence;
3. preserves `skills_used`;
4. sorts by severity;
5. resolves contradictory findings itself;
6. sends one correction bundle to implementation.

## Repair and re-review

A clear review correction is routed to a STANDARD implementation agent with:

```yaml
required_skills:
  - test-driven-development
  - receiving-code-review
```

If root cause is unclear, first spawn a STANDARD debugger with:

```yaml
required_skills:
  - systematic-debugging
```

After a fix, re-run every reviewer whose dimension may have changed.

## Task PASS

Only when all mandatory/applicable reviewers PASS, required skills were available/used, and unresolved BLOCKER/HIGH count is zero.
