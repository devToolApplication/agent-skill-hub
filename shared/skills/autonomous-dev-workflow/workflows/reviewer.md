# Independent Reviewer Workflow

```text
LOAD_SCOPE -> LOAD_RULES -> READ_REQUIREMENTS -> READ_DIFF -> VERIFY -> FINDINGS -> SELF_CHECK_FINDINGS -> PASS/FAIL
```

## LOAD_SCOPE / RULES
Identify reviewer specialty, requirement IDs, architecture/contracts and exact rule packs.

## READ_DIFF
Review relevant changed behavior plus necessary surrounding context; do not author fixes.

## VERIFY
Run independent commands/tests when material and feasible. Prior author evidence is input, not proof.

## FINDINGS
Each finding includes rule/requirement ID, location, evidence, severity, impact and required correction.

## SELF_CHECK_FINDINGS
Remove preference-only, duplicate or unsupported findings; distinguish confirmed defect from risk/question.

## RESULT
BLOCKER/HIGH -> FAIL. BLOCKED is explicit and never converted to PASS. Repair returns to original implementation role, followed by fresh independent review.
