# Errors, Observability, Integrations, and Configuration

# 48. Error Semantics

Errors should be meaningful and stable.

Bad:

```text
Exception("Error")
RuntimeException("Failed")
```

Good:

```text
UserNotFoundError
OrderAlreadyApprovedError
PaymentTimeoutError
```

or stable codes:

```text
USER_NOT_FOUND
ORDER_ALREADY_APPROVED
PAYMENT_TIMEOUT
```

Error codes should be:

```text
stable
searchable
machine-readable
documentable
```

---

# 49. Error Translation by Layer

Infrastructure errors should not leak randomly into API contracts.

Example:

```text
Postgres unique constraint
    ↓
UserEmailAlreadyExists
    ↓
HTTP 409
```

Example:

```text
Provider timeout
    ↓
PaymentProviderUnavailable
    ↓
appropriate application/API response
```

Translate errors at meaningful boundaries.

---

# 50. Exception Handling

Never swallow exceptions silently.

Bad:

```text
try:
    process()
except:
    pass
```

Bad:

```text
catch (Exception e) {
    return null;
}
```

Catch only to:

```text
recover
retry
translate
enrich context
cleanup
convert at a boundary
```

---

# 51. Broad Catch Rules

Avoid catching overly broad exceptions throughout business code.

A broad catch may be acceptable at process boundaries:

```text
HTTP global error handler
message consumer boundary
worker loop boundary
scheduler boundary
CLI main
```

There it should:

```text
log safely
map/handle
avoid leaking secrets
preserve observability
```

---

# 52. Logging Once

Do not log the same error at every layer.

Bad:

```text
Repository logs error
Service logs same error
Controller logs same error
Global handler logs same error
```

Result: duplicate noise.

Prefer:

```text
lower layer adds context and rethrows
final handling boundary logs once
```

Log earlier only when the earlier layer genuinely owns an event or recovery decision.

---

# 53. Structured Logging

Prefer structured fields:

```text
traceId
requestId
userId
module
operation
resourceId
durationMs
errorCode
```

Bad:

```text
"Failed order " + orderId + " for " + userId
```

Better:

```text
message = "Failed to create order"
orderId = ...
userId = ...
traceId = ...
errorCode = ...
```

---

# 54. Logging Levels

Use levels intentionally.

Typical meaning:

```text
DEBUG  detailed diagnostic data
INFO   important normal lifecycle/business event
WARN   abnormal but recoverable situation
ERROR  failed operation requiring attention
```

Do not use ERROR for expected validation failures unless project policy requires it.

Do not flood INFO with high-volume low-value details.

---

# 55. Sensitive Logging

Never log:

```text
password
access token
refresh token
private key
OTP
full authorization header
payment secrets
session secret
encryption secret
```

Mask sensitive personal information when logging is necessary.

---

# 56. External API Isolation

Raw provider calls should not be scattered through business services.

Bad:

```text
OrderService
    axios.post(providerUrl, ...)
```

Good:

```text
OrderApplication
    ↓
PaymentGateway
    ↓
PaymentHttpClient
```

Business code should not know:

```text
provider URL
HTTP headers
provider JSON shape
retry mechanics
vendor error codes
```

The adapter translates them.

---

# 57. Timeouts

All remote/external operations should have intentional timeout behavior.

Includes:

```text
HTTP
RPC
database
Redis
object storage
message broker publish
third-party SDKs
```

Do not rely on unbounded defaults.

Timeout value should reflect:

```text
operation importance
expected latency
upstream SLA
caller timeout
retry policy
```

---

# 58. Retry

Retry only when the failure is retryable.

Retry policy should define:

```text
retryable errors
max attempts
backoff
jitter when useful
timeout
metrics/logging
```

Do not retry blindly.

Bad:

```text
retry all exceptions 5 times
```

Especially dangerous for:

```text
payment
order creation
external state changes
```

unless idempotency exists.

---

# 59. Idempotency

Consider idempotency for:

```text
payments
transaction creation
webhook processing
message consumers
document processing
workflow commands
external callbacks
```

Possible keys:

```text
idempotencyKey
eventId
transactionId
requestId
businessOperationId
```

Idempotency behavior should be explicit and tested.

---

# 60. Transaction Boundaries

Keep DB transactions narrow.

Bad:

```text
BEGIN
update rows
call remote payment API for 5 seconds
send email
publish broker message
COMMIT
```

Problems:

```text
locks
long transactions
higher contention
hard rollback semantics
distributed inconsistency
```

Prefer:

```text
BEGIN
database changes
outbox insert if needed
COMMIT

then asynchronous external processing
```

Use outbox/inbox/saga patterns when the complexity is justified.

---

# 61. Unit of Work

A use case should have a clear transaction owner.

Avoid repositories independently committing arbitrary fragments of one use case unless the framework pattern requires it and behavior is clear.

Example:

```text
CreateOrder
    begin
    save order
    save items
    commit
```

Transaction ownership must be understandable.

---

# 62. Configuration

Do not scatter environment access:

```text
process.env.X
os.getenv(...)
System.getenv(...)
```

through business code.

Prefer:

```text
Environment
    ↓
Config Loader
    ↓
Typed Config
    ↓
Dependency Injection
```

Examples:

```text
DatabaseConfig
RedisConfig
KafkaConfig
StorageConfig
SecurityConfig
ProviderConfig
```

Validate configuration at startup.

Fail early for missing mandatory values.

---

# 63. Configuration Secrets

Secrets should come from proper secret sources appropriate to deployment.

Do not commit secrets to source.

Do not print them during startup.

Separate:

```text
configuration
secret material
runtime credentials
```

---
