---
name: self-code-review
description: Mandatory author-side review of the complete implementation diff before handoff. Used by implementation agents after tests pass; it never replaces independent review.
---

# Self Code Review

Use after implementation and SELF_TEST, before FINAL_VERIFY/HANDOFF.

## Procedure

1. Read the complete diff produced by the current task, not only the last edited file.
2. Re-read assigned requirement IDs, acceptance criteria, approved architecture/contracts, role rules and applicable project rules.
3. Check requirement completeness and scope creep.
4. Check correctness, edge/failure behavior and backward compatibility.
5. Check reuse/duplication and unnecessary abstraction.
6. Check architecture/layer ownership and contract drift.
7. Check error handling, logging and sensitive-data exposure.
8. Check data/concurrency/idempotency when relevant.
9. Check security/performance risks introduced by the diff.
10. Check tests for missing negative/boundary/regression coverage.
11. For frontend also check i18n, semantic theme tokens, loading/empty/error/form states, responsive behavior, keyboard/a11y and lifecycle cleanup.
12. Record findings with rule/requirement ID, location, severity and correction.

## Result

```yaml
status: PASS | FIX_REQUIRED
findings:
  - rule_id: BE-ERR-001
    location: path:symbol
    severity: HIGH
    issue: ...
    correction: ...
```

If any finding requires a code change:

```text
FIX -> SELF_TEST -> SELF_CODE_REVIEW again
```

Do not hand off with unresolved BLOCKER/HIGH findings. A PASS here only means the author-side gate passed; independent reviewer approval is still required.
