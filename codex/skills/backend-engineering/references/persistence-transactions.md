# Backend Persistence and Transaction Policy

## Ownership

A module owns its persistence model/repository. Other modules should call stable public/application contracts rather than directly mutating another module's tables/repositories.

## Repository responsibility

Repositories hide ORM/database mechanics and express application/domain intent. Avoid leaking ORM query builders/entities throughout business code when the project already has repository/adapter boundaries.

## Transaction boundaries

Prefer a transaction around one coherent persistence use case, normally owned by the application/use-case layer or established project mechanism.

Keep transactions narrow:

```text
load required state
validate invariant
perform required persistence changes
commit
```

Avoid network calls, long CPU work, user interaction, sleeps, or uncontrolled retries inside database transactions unless the design explicitly requires and accounts for them.

## Failure semantics

Do not swallow persistence errors and continue as if committed. Translate low-level errors when callers need stable semantics (for example unique constraint -> conflict error).

## Concurrency

When concurrent updates are possible, explicitly consider existing project mechanisms:

```text
optimistic locking/version
pessimistic lock
unique constraint
atomic update
idempotency key
compare-and-set
```

Do not invent locking without evidence of a concurrency requirement.

## Messaging after persistence

For state change + message/event publication, do not pretend two independent systems are one atomic transaction. Follow the project's established outbox/eventing strategy. If none exists and atomicity matters, parent must decide the design before dispatching a worker.

## Query performance

Watch for N+1, unbounded result sets, missing pagination, and unnecessary relation loading. Do not prematurely rewrite queries without evidence/measurement.
