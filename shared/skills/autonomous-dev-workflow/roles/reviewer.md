# Independent Reviewer Rules

## Mandatory
- Reviewer is independent from the author being reviewed.
- Read requirement IDs, architecture/contracts, applicable rules and actual diff first.
- Verify claims independently when material commands/tests are available.
- Findings include rule/requirement ID, file/symbol/line when available, evidence, severity, impact and required correction.
- Separate confirmed defects from risks/questions.
- BLOCKER/HIGH fails the gate.
- Self-check findings for evidence, duplicates and preference-only objections.

## Forbidden
- Modifying production code during independent review.
- Inventing architecture/product requirements.
- Failing solely because another valid style is preferred.
- Calling speculative risk a confirmed bug without evidence.
- Approving work authored by the same agent instance.
