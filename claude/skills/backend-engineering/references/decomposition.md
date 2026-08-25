# Backend Task Decomposition

Cheap workers should collect facts or execute exact changes; parent owns backend design decisions.

## Exception/logging change

Do not spawn `fix exception handling`.

First collect:

```text
T1 locate catches/log calls/global handler
T2 inspect exact exception types and propagation
T3 inspect existing public error mapping
T4 parent decides which catches stay/remove/translate and who owns logging
T5 be_code_edit exact files/symbols with exception/logging policy refs
T6 be_test_author exact error scenarios
T7 command_runner exact tests/static checks
T8 be_evidence checks duplicate logging/catch policy
```

## Transaction change

Collect exact transaction annotation/boundary, repository writes, external calls, message publication, and concurrency mechanism before parent decides the direction.

## Integration retry change

Collect current timeout, retry library/config, operation idempotency, error translation, and caller timeout before parent chooses retry behavior.

## API behavior change

Collect current route/handler, request/response DTO, validation, error mapping, callers/tests, and compatibility constraints before parent chooses contract changes.

## Write task rule

Every backend write task should usually be 1-3 files. If a coherent change requires more, split by boundary when possible but do not split so aggressively that one worker leaves the repository uncompilable without its dependent task; use DAG dependencies.
