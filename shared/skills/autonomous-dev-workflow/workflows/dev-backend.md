# Backend Developer Skill Workflow

```text
PREPARE -> IMPLEMENT(TDD) -> SELF_TEST -> SELF_REVIEW -> FINAL_VERIFY -> HANDOFF
                   ^             |            |
                   |             +-- FIX -----+
                   +---- DEBUG <--- test failure
```

## PREPARE
Read assignment, requirement IDs, role rules, architecture/contracts and project rules. Inspect existing implementation and reusable core/common helpers. Confirm write ownership.

PASS output: reusable components, intended write set, affected contracts and risks.

## IMPLEMENT
Required skill: `test-driven-development` for behavior changes.
Use RED -> GREEN -> REFACTOR where practical. Stay inside ownership and approved contracts.

## SELF_TEST
Required skill: `verification-before-completion`.
Run relevant unit/integration/module tests, build/compile and lint/static checks available for affected scope.

On failure: use `systematic-debugging`, fix root cause, rerun affected tests.

## SELF_REVIEW
Required skill: `self-code-review`.
Review the complete diff against requirements, architecture and `roles/dev-backend.md`. Check layering, duplication, contracts, errors, logging, data/races/idempotency, security/performance and test gaps.

Any finding requiring code change -> FIX -> SELF_TEST -> SELF_REVIEW again.

## FINAL_VERIFY
Required skill: `verification-before-completion`.
PASS only if evidence is current, self-review passes, no unresolved BLOCKER/HIGH finding, requirements are mapped and deviations explained.

## HANDOFF
Return `contracts/task-result.md` evidence plus integration requests. Independent reviewer runs after handoff.

## REVIEW REPAIR
On independent feedback use `receiving-code-review` -> FIX -> SELF_TEST -> SELF_REVIEW -> FINAL_VERIFY -> independent re-review.
