# Security, Reliability, and Performance

# 101. Performance

Do not optimize by intuition alone.

Use:

```text
measurement
profiling
metrics
query plans
load tests
```

when performance matters.

Do not trade away maintainability for theoretical micro-optimizations.

---

# 102. Performance Comments

If code is intentionally unusual for performance, comment the reason.

Good:

```text
// Stream rows instead of materializing the full result.
// Production reports can exceed 500k records and previously consumed >1 GB RAM.
```

Bad:

```text
// optimized
```

---

# 103. Concurrency

When adding concurrency:

```text
define ownership
avoid shared mutable state
define cancellation
bound parallelism
handle partial failure
preserve ordering if required
```

Do not use unbounded parallel execution.

---

# 104. Async Code

Async operations should be propagated correctly.

Do not:

```text
fire-and-forget critical business operations
block async event loops
ignore rejected promises/tasks
```

Fire-and-forget is allowed only when intentionally designed and observable.

---

# 105. Resource Management

Close resources correctly:

```text
files
streams
connections
transactions
HTTP bodies
locks
```

Use language-native constructs:

```text
try-with-resources
with
defer
using
RAII
```

---

# 106. Date and Time

Prefer explicit time zones.

Store timestamps consistently, commonly UTC.

Use injected `Clock` for business logic that depends on time when testability matters.

Avoid scattering:

```text
now()
new Date()
datetime.now()
```

through domain logic if deterministic tests are needed.

---

# 107. Money

Do not use binary floating point for money when precision matters.

Use:

```text
decimal
BigDecimal
integer minor units
Money value object
```

Define currency explicitly when multiple currencies are possible.

---

# 108. IDs

Use meaningful ID types when useful:

```text
UserId
OrderId
PaymentId
```

instead of passing arbitrary strings everywhere in strongly typed systems.

Do not over-engineer trivial internal scripts.

---

# 109. Enums

Use enums/domain constants for closed state sets.

Avoid string literals:

```text
"APPROVED"
"03"
"ACTIVE"
```

repeated across code.

Serialization values may differ from internal enum names; map explicitly where necessary.

---

# 110. Mappers

Mapping logic should be located consistently.

Typical:

```text
Request DTO -> Command
Persistence Entity <-> Domain
Domain -> Response DTO
```

Avoid mapping scattered across unrelated services.

Do not create giant generic reflection mappers if explicit mapping is safer and clearer.

---

# 111. Repository Boundaries

Repository interfaces should reflect domain/application needs.

Prefer:

```text
findById
findPendingForCustomer
save
existsByExternalReference
```

over exposing a raw generic ORM query object to upper layers.

---

# 112. Services

A service must have a clear responsibility.

Bad:

```text
CommonService
```

with 80 unrelated methods.

Better:

```text
OrderPricingService
PaymentAuthorizationService
DocumentStorageService
```

If a service grows continuously, inspect whether it hides multiple capabilities.

---

# 113. Utilities

Utility functions are acceptable when:

```text
pure
generic
small
stable
business-neutral
```

Example:

```text
parseIsoDate
clamp
base64Encode
```

Do not move business logic into utilities just to avoid dependency rules.

---

# 114. Security Errors

Do not leak authorization details unnecessarily.

For example, sometimes:

```text
404
```

may be preferable to revealing that a protected resource exists.

Follow project security policy.

---

# 115. Secret Comparison

Use timing-safe comparison for secrets/tokens where applicable.

Do not implement cryptography manually.

Use maintained libraries and platform primitives.

---

# 116. SQL

Always use parameterized queries.

Do not concatenate untrusted input into SQL.

Bad:

```text
"SELECT ... WHERE id = " + userInput
```

Use parameter binding.

---

# 117. Dynamic Queries

Whitelist allowed sort/filter fields.

Do not directly interpolate user-provided:

```text
column name
order by clause
table name
```

without validation.

---
