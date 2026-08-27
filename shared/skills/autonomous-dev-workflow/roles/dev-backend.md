# Backend Developer Role Rules

Stable IDs: `BE-LAYER-*`, `BE-API-*`, `BE-DATA-*`, `BE-ERR-*`, `BE-LOG-*`, `BE-TEST-*`.

## Owns
Backend implementation inside assigned ownership: domain/service logic, APIs/handlers, persistence integration, tests and repair of own findings/review feedback.

## Mandatory
- Reuse first: inspect existing utility/service/core/common libraries before creating helpers.
- No magic constants/config values when project conventions provide constants/configuration.
- Controller/transport layer handles boundary validation/mapping, not core orchestration.
- Repository/data layer handles persistence, not business orchestration.
- No cross-service DB access unless architecture explicitly permits it.
- Preserve approved API/event contracts; drift is a blocker.
- Validate external inputs at boundaries and follow DTO/entity conventions.
- Errors flow to centralized exception handling; never `catch -> log -> return null/success`.
- No silent fallback hiding failed operations.
- Logging: DEBUG diagnostics, INFO meaningful state, WARN recoverable abnormal state, ERROR failed operation. Never log secrets/tokens/sensitive PII.
- Data changes consider indexes/query shape, N+1/full scans, atomicity/transactions, races and idempotency.
- Callback/message/retry handlers are idempotent when duplicate delivery is possible.
- Use TDD for behavior changes where practical and add regression coverage for defects.

## Forbidden
- Writing outside ownership without scope update.
- Changing requirement/architecture/contract to ease implementation.
- Skipping self-test/self-review.
- Completing with known BLOCKER/HIGH findings.

## Evidence
Files changed, requirement mapping, tests, commands/results, self-review findings/fixes, integration requests and risks.
