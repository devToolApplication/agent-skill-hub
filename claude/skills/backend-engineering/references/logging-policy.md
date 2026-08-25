# Backend Logging Policy

## Principle: log owned events, not method traffic

Logging exists for operational diagnosis, business/audit traceability where required, and security observability. It is not a transcript of every function call.

Do not add `start/end`, `enter/exit`, or success logs to every controller/service/repository method by default.

## One failure, one owning log

Do not log the same propagated exception at repository -> service -> controller -> global handler.

Prefer:

```text
lower layer translates/adds semantic context without logging
final owning boundary logs failed operation once
```

Log earlier only when that layer owns a distinct event such as retry attempt, fallback choice, circuit-breaker change, compensation failure, or DLQ transition.

## Log + throw

Default rule:

```text
catch -> log.error -> throw same error
```

is forbidden because it commonly duplicates the boundary log.

It is allowed only when the current layer owns a separate meaningful event that would otherwise be lost. The event must be distinct from the final propagated failure.

## Level semantics

### DEBUG
Detailed diagnostic facts useful for troubleshooting and normally safe to omit at normal production verbosity.

Examples:

```text
branch/rule chosen
cache hit/miss
retry delay calculation
normalized non-sensitive metadata
state transition details
```

### INFO
Meaningful normal business/system lifecycle events. Use selectively.

Examples:

```text
important business state transition when operationally useful
job/consumer lifecycle result
configuration reload
explicit workflow completion
```

Do not use INFO for every method call or repository query.

### WARN
Abnormal but handled/recoverable conditions.

Examples:

```text
retry attempt
fallback selected
duplicate idempotent request handled
rate/capacity threshold warning
dependency transient failure that will be retried
circuit breaker state transition
```

### ERROR
An operation actually failed and requires attention/diagnosis at the owning boundary.

Examples:

```text
unexpected request failure
retry exhausted
consumer permanently failed / sent to DLQ
scheduled job failed
invariant/data-integrity failure
unrecoverable dependency failure
```

Expected validation/not-found/conflict/authorization outcomes are not automatically ERROR.

## Placement matrix

| Location/event | Default logging |
|---|---|
| every controller method | no |
| every service method | no |
| every repository call | no |
| central unexpected request failure boundary | ERROR |
| retry attempt | WARN or DEBUG per project/volume |
| retry exhausted | ERROR at owning operation boundary |
| fallback used | WARN when operationally meaningful |
| circuit breaker state change | WARN/INFO per project convention |
| scheduled job/consumer final failure | ERROR |
| scheduled job normal completion | INFO only when useful |
| important business state transition | INFO or audit, depending purpose |
| ordinary validation failure | usually no app error log |
| auth/security-sensitive event | security/audit policy |

## Structured logging

Prefer structured fields over string concatenation. Typical fields:

```text
traceId
requestId
correlationId
operation
module
resourceId
actorId (only when appropriate)
durationMs
attempt
errorCode
dependency
```

Use low-cardinality stable event names where the logging/metrics platform benefits from them.

## Sensitive data

Never log:

```text
password
access/refresh token
Authorization header
OTP
private key
session secret
encryption secret
full payment credential
raw secret-bearing payload
```

Minimize or mask personal/sensitive data according to project policy.

## Application vs audit vs security logs

Do not treat them as interchangeable.

Application logs: diagnose runtime behavior/failures.

Audit records: who did what to which resource, when, result, and before/after where required. Audit durability/retention may differ from app logs.

Security events: authentication abuse, sensitive authorization failure patterns, credential/config changes, suspicious activity. Never include secret material.

## Worker logging self-check

When a write task adds/changes a log, verify:

```text
this layer owns the event
level matches semantics
same failure is not logged elsewhere in propagation chain
fields are structured where project supports it
no secrets/sensitive payloads are introduced
message/event name is stable and useful
high-volume paths will not create avoidable noise
```
