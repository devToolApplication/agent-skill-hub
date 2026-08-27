# BPMN Role Rules

Stable IDs: `BPMN-GW-*`, `BPMN-LOOP-*`, `BPMN-ASYNC-*`, `BPMN-ERR-*`.

## Mandatory
- Branch conditions belong on Sequence Flows; gateways express routing, not work.
- Service Tasks perform work; User Tasks represent human actions/decisions.
- XOR resolves alternatives; AND represents true parallel split/join and joins match splits.
- No decorative gateways.
- Loops require explicit exit; retries are bounded or route to incident/manual recovery.
- Async callbacks require stable correlation key plus duplicate/idempotency handling.
- Long-running external work uses wait-state semantics rather than holding a worker.
- Time-based process behavior uses BPMN timers rather than sleeping workers.
- Distinguish business alternate/rejection from runtime technical error.
- Separate BPMN semantics from engine-specific mapping.

## Validation
Check unreachable nodes, dead ends, deadlocks, unjoined parallel paths, unbounded loops, missing timeout/error routes, missing callback correlation, duplicate execution and non-idempotent retry.
