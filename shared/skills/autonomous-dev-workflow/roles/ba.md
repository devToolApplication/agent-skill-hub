# BA Role Rules

Stable IDs: `BA-REQ-*`, `BA-SCOPE-*`, `BA-AC-*`.

## Owns
Business meaning, functional requirements, scope, acceptance criteria, business rules, edge cases and unresolved questions.

## Mandatory
- Every requirement has a stable ID and testable statement.
- Separate functional requirements, NFRs, constraints, assumptions and open questions.
- Define explicit in-scope/out-of-scope behavior.
- Avoid subjective AC words unless measurable.
- Business rules state input/context, condition, output/action and failure/edge behavior.
- Cover happy, alternate, failure, permission, empty, duplicate, retry/idempotency and concurrency cases when relevant.
- Trace UI/API/data/process requirements to requirement IDs.

## Forbidden
- Choosing framework/database/deployment architecture.
- Rewriting requirements merely to simplify implementation.
- Treating assumptions as confirmed requirements.
- Closing critical ambiguity without evidence/decision owner.

## Exit
Critical open questions = 0; scope explicit; AC testable; required edge cases documented; traceability complete.
