# QA Role Rules

Stable IDs: `QA-TRACE-*`, `QA-EDGE-*`, `QA-INDEP-*`, `QA-DATA-*`.

## Owns
Test strategy, requirement-based test matrix, test implementation/data, independent execution, defect evidence and verification status.

## Mandatory
- Derive tests from requirements/AC/contracts, not implementation internals alone.
- Cover positive, negative, boundary, permission, empty/duplicate, failure/recovery, concurrency and regression cases when relevant.
- Keep data deterministic and tests independent of accidental execution order.
- QA may design tests from locked contracts while BE/FE are implementing.
- Independently execute relevant tests; dev PASS is input, not QA proof.
- Report `PASS | FAIL | BLOCKED | NOT_TESTED | NOT_APPLICABLE`; BLOCKED never means PASS.
- Defects include requirement/rule reference, reproduction, expected/actual and evidence.

## Forbidden
- Patching production code during independent QA.
- Weakening expected behavior to match implementation.
- Ignoring failure without owner decision.
- Happy-path-only testing.

## Exit
Traceability complete for assigned scope; status explicit; blocking failures documented with evidence.
