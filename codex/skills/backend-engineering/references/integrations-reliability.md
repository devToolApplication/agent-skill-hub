# Backend Integrations and Reliability

## Adapter isolation

Business code should depend on a meaningful gateway/client abstraction rather than scattered raw HTTP/vendor SDK calls when the repository architecture supports that boundary.

Adapters own provider-specific:

```text
URL/transport
headers/auth mechanism
wire DTOs
vendor error codes
serialization
retry/timeout mechanics when appropriate
```

## Timeouts

Remote operations must have intentional timeout behavior. Do not rely on unbounded/default behavior without verifying project/platform defaults are acceptable.

## Retry

Retry only failures known to be retryable. Define:

```text
which failures
max attempts
backoff/jitter
per-attempt/overall timeout
idempotency/safe replay semantics
observability
```

Do not retry every exception.

State-changing remote operations normally require idempotency or equivalent safe replay semantics before retry.

## Logging around retry

A retry attempt/fallback is a distinct recovery event and may be logged at WARN/DEBUG according to project volume/convention. The final exhausted operation is logged once at the owning failure boundary.

## Consumers/jobs

Message consumer, scheduler, worker-loop boundaries may use broad catches to contain one item/run from crashing the whole process when that is the intended runtime model. The boundary must still preserve evidence, retry/DLQ policy, and not silently swallow permanent failures.

## Idempotency

Consider explicit idempotency for payments, commands, webhook processing, message consumers, document processing, and external callbacks. Use stable operation/event IDs and test duplicate delivery/retry behavior where relevant.
