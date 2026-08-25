# API, Data, Messaging, and Workers

# 64. API Resource Naming

For REST, prefer nouns:

```text
/users
/orders
/documents
/payments
```

Avoid:

```text
/getUsers
/createOrder
/deleteDocument
```

Use HTTP verbs for common CRUD semantics.

---

# 65. Business Action Endpoints

Explicit business commands may use action endpoints:

```text
POST /orders/{id}/approve
POST /orders/{id}/cancel
POST /documents/{id}/archive
```

This can be clearer than forcing business transitions into generic CRUD updates.

---

# 66. API Versioning

When versioning is required:

```text
/api/v1/...
```

Do not silently introduce breaking contract changes.

Breaking changes include:

```text
renaming required fields
changing field meaning
removing fields
changing type
changing status/error semantics
```

---

# 67. API Success Shape

Keep response shape consistent.

Example:

```json
{
  "data": {}
}
```

If the existing project returns direct resources consistently, do not introduce a wrapper purely for style.

Consistency matters more than forcing a universal wrapper.

---

# 68. API Error Shape

Example:

```json
{
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order not found"
  },
  "requestId": "..."
}
```

Prefer stable error code plus human-readable message.

Do not expose:

```text
stack traces
SQL
internal class names
secret values
raw upstream sensitive payloads
```

---

# 69. Pagination

Use one pagination convention per API.

Example:

```json
{
  "data": [],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "total": 100
  }
}
```

For very large/real-time datasets, cursor pagination may be more appropriate.

Do not mix page-based and cursor-based pagination randomly.

---

# 70. API Request Limits

Bound expensive inputs.

Examples:

```text
pageSize max
file size max
query length max
batch size max
date range max when appropriate
```

Prevent accidental or abusive resource exhaustion.

---

# 71. Security Boundary

Treat these as untrusted until validated/verified:

```text
HTTP request
headers
cookies
JWT claims
queue payload
webhook payload
uploaded files
external API response
user-provided URLs
```

Boundary validation is mandatory where relevant.

---

# 72. Authentication vs Authorization

Do not mix concepts.

Authentication:

```text
Who is the caller?
```

Authorization:

```text
May this caller perform this action?
```

Avoid scattered checks:

```text
if role == "admin"
```

across dozens of services.

Prefer:

```text
permissionService.canApproveOrder(...)
OrderApprovalPolicy
authorization policy
```

---

# 73. Audit Logging

Sensitive business actions may need audit records:

```text
who
what
when
target
result
before/after when appropriate
```

Examples:

```text
approve
reject
delete
permission change
security change
payment
manual override
```

Audit log is not the same as application diagnostic logging.

---

# 74. File Upload Safety

When handling uploads:

```text
validate size
validate allowed type
do not trust filename extension alone
sanitize generated storage names
avoid path traversal
scan if required
limit processing resources
```

Do not use user-provided filesystem paths directly.

---

# 75. Query and Persistence Rules

Repository methods should communicate intent.

Prefer:

```text
findById()
findActiveByEmail()
save()
existsByExternalId()
```

Avoid giant generic repositories with vague methods if domain-specific queries are clearer.

Do not leak ORM query constructs throughout application code.

---

# 76. N+1 and Query Awareness

When accessing collections or relations:

```text
consider N+1 queries
bound result size
use proper indexes
avoid loading unneeded columns/relations
```

Do not prematurely hand-optimize every query.

Optimize when query patterns and measurements justify it.

---

# 77. Cache Rules

Cache is an optimization, not the source of business truth unless explicitly designed otherwise.

Define:

```text
key
TTL
invalidation rule
failure behavior
consistency expectation
```

Do not add caching without deciding how stale data behaves.

---

# 78. Messaging Rules

Events should represent facts:

```text
OrderCreated
PaymentCompleted
UserDisabled
```

Commands represent intent:

```text
CreateOrder
ProcessPayment
DisableUser
```

Do not call everything `Event`.

Messages should have stable contracts where multiple components consume them.

---

# 79. Consumer Rules

Message consumers should consider:

```text
idempotency
retry
poison messages
dead-letter behavior
ordering
duplicate delivery
observability
```

Do not assume exactly-once delivery unless the infrastructure guarantees it and the design actually uses that guarantee.

---

# 80. Event Contract Evolution

Avoid breaking existing consumers.

Prefer additive changes:

```text
new optional fields
new event version when necessary
```

Document breaking event changes.

---

# 81. Scheduler and Worker Rules

Background jobs should be:

```text
idempotent when practical
bounded
observable
retry-aware
cancellable/shutdown-aware
```

Avoid infinite loops without:

```text
sleep/backoff
shutdown handling
error boundary
metrics/logging
```

---

# 82. Graceful Shutdown

Long-running services should handle graceful shutdown where applicable.

Typical:

```text
stop accepting new work
finish/abort bounded in-flight work
close DB pool
close messaging clients
flush telemetry if required
exit
```

---
