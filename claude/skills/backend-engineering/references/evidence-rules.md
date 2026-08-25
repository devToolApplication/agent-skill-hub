# Backend Evidence Rules

Evidence workers report facts only. Parent decides severity/fix.

## Exceptions

### BE-ERR-001 — redundant log-and-rethrow
Question: Does a changed catch block log an exception and rethrow the same/translated failure while a higher boundary also logs the failed operation?

Collect: file/symbol, catch type, log level/event, throw behavior, higher boundary evidence.

### BE-ERR-002 — broad catch in business code
Question: Does changed business/application code catch Exception/Throwable without a concrete recover/retry/translate/compensate/cleanup reason?

### BE-ERR-003 — swallowed failure
Question: Does a changed catch return null/false/default/success or otherwise hide a failure without explicit semantics?

### BE-ERR-004 — transport concern leaked into service/domain
Question: Does service/domain code create HTTP status/response objects or transport-specific exceptions contrary to established project boundary?

## Logging

### BE-LOG-001 — duplicate failure logging
Collect all log sites on the same propagation path for the changed failure.

### BE-LOG-002 — noisy method traffic
Question: Did the diff add routine method entry/exit/repository-call INFO logs without a meaningful event?

### BE-LOG-003 — wrong level
Collect event semantics and configured level; do not assign final severity.

### BE-LOG-004 — sensitive data risk
Collect exact logged fields/arguments that may contain tokens, credentials, authorization headers, secrets, or sensitive payloads.

## Transactions/persistence

### BE-TX-001 — external call inside DB transaction
Collect transaction boundary and remote/network call evidence.

### BE-TX-002 — cross-module persistence mutation
Collect source module, target repository/entity/table ownership, and call path.

### BE-TX-003 — state change retry without safe replay evidence
Collect retry behavior, state-changing operation, and idempotency mechanism if any.

## API/security

### BE-API-001 — service owns HTTP mapping
Collect service/domain transport-specific response/status usage.

### BE-SEC-001 — missing boundary validation on newly untrusted input
Collect input source and validation path.

### BE-SEC-002 — secret/sensitive logging
Collect exact log argument and source; never reproduce secret values in evidence output.
