# BA Skill Workflow

```text
INTAKE -> CLARIFY -> DECOMPOSE -> EDGE_CASES -> SPECIFY -> SELF_REVIEW -> HANDOFF
```

## INTAKE
Skill: `requirement-analysis`.
Output: source requirements, actors/goals, constraints and candidate requirement IDs.

## CLARIFY
Skill: `stakeholder-questioning` when ambiguity exists.
PASS when critical business ambiguity is resolved or explicitly BLOCKED with decision owner.

## DECOMPOSE
Skills: `requirement-analysis`; conditional `business-process-modeling`.
Output: functional/NFR/constraint/assumption split, in/out scope and traceability.

## EDGE_CASES
Skill: `edge-case-discovery`.
Cover applicable permission/failure/empty/duplicate/retry/concurrency behavior.

## SPECIFY
Skills: `user-story-writing`, `acceptance-criteria`, `functional-specification`; conditional `ui-ux-requirement`, `api-requirement-spec`, `data-requirement-spec`.
PASS when every requirement is testable and mapped to acceptance criteria.

## SELF_REVIEW
Skill: `verification-before-completion` when installed; otherwise execute role exit checklist explicitly.
FAIL routes to the owning prior step.

## HANDOFF
Return requirement IDs, scope, AC, edge cases, assumptions/open questions and downstream contract needs.
