# Backend Exception Strategy

## Goal

Exceptions/failures should be handled at the layer that can add meaningful behavior. Do not scatter identical try/catch/log code across controller, service, and repository layers.

## Preferred flow

```text
transport/controller
    ↓
application/use case
    ↓
domain / repository / integration adapter
    ↓
typed failure propagates or is translated at a meaningful boundary
    ↓
central transport/process error boundary
    ├─ maps to public error/status
    ├─ logs final unexpected/failed operation once when appropriate
    └─ returns/sends safe response
```

## Catch decision rule

A catch block is justified only when it does at least one of:

```text
RECOVER      produce a valid alternative result
RETRY        own an explicit retry policy
TRANSLATE    convert lower-level/vendor error to stable application/domain error
COMPENSATE   execute defined compensation for a failed operation
CLEANUP      perform required cleanup not better handled by language/framework constructs
BOUNDARY     map/contain failure at HTTP, consumer, scheduler, worker-loop, CLI boundary
```

If none apply, prefer natural propagation.

## Forbidden default patterns

Do not add:

```text
catch (Exception e) { log.error(...); throw e; }
catch (...) { return null; }
catch (...) { return false; }
catch (...) { throw new RuntimeException("failed"); }
```

unless the exact semantics are explicitly required and justified.

Do not catch broad `Exception`/`Throwable` throughout business code. Broad catches belong only at true process/transport boundaries where containment is required.

## Translation

Translate when a lower-layer error is unstable or inappropriate for callers.

```text
SQL unique violation -> EmailAlreadyExists
provider timeout     -> PaymentProviderTimeout
vendor 404           -> RemoteCustomerNotFound (only if that is meaningful to application semantics)
```

When translating:

- preserve the original cause for diagnostics;
- use a stable error type/code;
- do not leak SQL/vendor/internal class names into public responses;
- do not log merely because translation occurs if a higher boundary owns final logging.

## HTTP boundary

Business/application layers must not return `ResponseEntity`, status codes, Express responses, or equivalent transport objects merely to handle exceptions.

Typical central mechanisms:

```text
Spring Boot  -> @RestControllerAdvice / @ExceptionHandler
Express      -> throw/next(error) -> final error middleware
NestJS       -> exception filter / global filter
ASP.NET Core -> exception middleware/filter
```

Use the project's established mechanism rather than creating a competing one.

## Expected vs unexpected failures

Expected business errors such as validation, not-found, conflict, or forbidden actions may map to normal client-facing error responses. They are not automatically operational ERROR events.

Unexpected failures, exhausted dependency failures, invariant violations, or process-boundary failures normally require error observability at the owning boundary.

## Worker rules when editing exception code

A `be_code_edit` task touching exception behavior must preserve:

```text
stable error semantics
root cause when translating
transport/domain separation
single owning handling/logging boundary
existing public error shape unless explicitly authorized
```

If the requested direction requires controller-local business exception catches or repeated log-and-rethrow without a stated boundary/recovery reason, return `BLOCKED: POLICY_CONFLICT`.
