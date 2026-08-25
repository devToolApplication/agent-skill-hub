# Reviewer Matrix

## architecture_reviewer
Check business ownership, dependency direction, public contracts, DB ownership, cycles, unnecessary abstraction, and future extensibility.

For `shared/`, distinguish valid focused technical reuse from actual misuse:

```text
StringUtil / TimeUtil / JsonUtil with narrow generic behavior -> valid
CommonUtil / CommonService / mixed business helpers          -> architectural smell
OrderUtil in global shared                                  -> wrong ownership
PaymentUtil.charge()                                        -> hidden service/integration
```

## correctness_reviewer
Check requested/existing behavior, state transitions, edge cases, null/empty semantics, errors, data mapping/calculation, side effects, compatibility, and caller assumptions.

## maintainability_reviewer
Check naming, function/file responsibility, nesting/complexity, magic values, duplication, wrong abstraction, comments/TODO/dead code, type weakening, discoverability, and surprising side effects.

Do **not** flag `StringUtil`, `TimeUtil`, `DateUtil`, `CollectionUtil`, `JsonUtil`, etc. merely because they use the `Util` suffix. Flag them only when they become broad dumping grounds, duplicate standard-library behavior without adding semantics, hide dependencies/I/O, or contain business-specific behavior.

## test_reviewer
Check regression coverage, business invariant coverage, important failure paths, persistence/contracts, retry/idempotency/concurrency tests, nondeterminism, over-mocking, and implementation-coupled tests.

## security_reviewer
Check authn/authz, tenant/resource ownership, injection, secrets, SSRF, JWT/webhook validation, file/path handling, sensitive errors/logs, unsafe crypto/defaults.

## reliability_performance_reviewer
Check timeout, retry, idempotency, transaction scope, lost/duplicate work, concurrency, resource leaks, graceful shutdown, N+1, unbounded memory/query/task behavior, cache consistency, and broker semantics.
