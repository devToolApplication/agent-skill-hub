---
name: bpmn-engine-mapper
description: Map a validated vendor-neutral BPMN 2.0 model onto a project's workflow engine/runtime/domain model without changing process semantics. Use only after bpmn-validator PASS. Owns BPMN-to-engine construct mapping, edge conditions, execution state, workers, timers, errors, joins, persistence, and unsupported-feature analysis; escalates any engine limitation that would alter business behavior.
---

# BPMN Engine Mapper

## Purpose

Translate validated BPMN semantics into an implementation contract for the project's workflow engine.

This skill does not redesign the business process. It defines how the runtime will preserve the already validated BPMN behavior.

## Preconditions

Required inputs:

- approved `01-process-design.md` or equivalent;
- validated `process.bpmn`;
- `bpmn-validator` result = `PASS`;
- target engine/runtime/domain model and constraints, when available.

If validation is not PASS, stop. Engine mapping is not a substitute for BPMN correction.

## Fundamental invariant

```text
BPMN semantics are the contract.
Engine structures are the implementation.
```

If the current engine cannot preserve a required BPMN semantic, report the gap. Do not silently approximate it.

## Mandatory separation

Keep node work and edge routing distinct.

Preferred conceptual domain:

```json
{
  "nodes": [
    { "id": "evaluate", "type": "AI_TASK" },
    { "id": "candidateType", "type": "INCLUSIVE_GATEWAY" }
  ],
  "edges": [
    {
      "source": "candidateType",
      "target": "parentFlow",
      "condition": "candidate.isParent == true"
    },
    {
      "source": "candidateType",
      "target": "sellerFlow",
      "condition": "candidate.isSeller == true"
    }
  ]
}
```

Do not regress to:

```json
{
  "node": {
    "type": "AI_GATE",
    "criteria": "is parent"
  }
}
```

when that node combines evaluation and BPMN routing semantics.

## Mapping checklist

For each BPMN construct define:

```text
runtime representation
execution behavior
persisted state
input/output variables
failure behavior
resume/recovery behavior
observability/audit data
unsupported limitations
```

At minimum cover all constructs present in the model.

Typical mappings:

```text
StartEvent              → process instance creation/activation
EndEvent                → path/process completion semantics
ServiceTask             → worker/task executor
UserTask                → human task/wait state
ReceiveTask             → external-event wait/subscription
ExclusiveGateway        → XOR route evaluation
InclusiveGateway        → evaluate all conditions + activate matching routes
ParallelGateway split   → activate all outgoing routes
ParallelGateway join    → token/barrier synchronization
EventBasedGateway       → competing event subscriptions
SequenceFlow.condition  → edge expression
Default SequenceFlow    → fallback route
BoundaryTimer           → timer subscription/timeout transition
BoundaryError           → error transition
Intermediate Catch      → persisted wait/subscription
SubProcess              → nested execution scope
Multi-instance          → controlled repeated/concurrent instances
CallActivity            → referenced process invocation
```

## Hard rules

### MAP-001 — Preserve gateway behavior

Do not implement all gateways with a generic `if/else` executor.

XOR, OR, AND, and event-based semantics differ and must remain distinct.

### MAP-002 — Conditions stay on edges

The runtime's canonical process definition should preserve `SequenceFlow.condition` as an edge/transition concern.

An expression service may evaluate conditions, but the condition remains associated with the flow being selected.

### MAP-003 — Token/synchronization semantics are explicit

For parallel/inclusive joins define how the runtime determines which incoming executions must arrive before continuation.

Do not use a simple incoming-count barrier when BPMN semantics require awareness of activated branches.

### MAP-004 — Wait states must survive restart

Timers, human tasks, receive tasks, event subscriptions, and other long-running waits must have a persistence/resume model when the engine is expected to survive process restarts/pod restarts.

### MAP-005 — Retry is not BPMN routing

Technical worker retries belong to execution policy unless the BPMN explicitly models a business loop/retry path.

### MAP-006 — Errors are observable process transitions

When BPMN models a boundary/error path, worker exceptions must be classified/mapped so the runtime can take the modeled transition instead of merely logging/failing the worker.

### MAP-007 — Unsupported semantics are explicit

For every unsupported BPMN construct state:

```yaml
construct: <BPMN element>
status: UNSUPPORTED | PARTIAL
current_engine_behavior: <behavior>
semantic_gap: <difference>
impact: <business/runtime impact>
required_engine_change: <needed capability>
```

If the workaround changes business semantics, return to architect/Main for a design decision and revalidation.

## Execution-state design

Document the minimum runtime concepts needed to execute the model, for example:

```text
ProcessDefinition
ProcessInstance
Execution/Token
Node/ActivityInstance
SequenceFlow/Transition
VariableScope
Job/WorkerTask
EventSubscription
Timer
Incident/Error
JoinState
AuditEvent
```

Use project terminology where established; do not force these names.

## Required output

Produce `03-engine-mapping.md` containing:

```markdown
# BPMN Engine Mapping

## Target Engine / Runtime
## Mapping Principles
## BPMN Element Mapping Table
## Node vs Edge Model
## Expression / Condition Evaluation
## Token and Gateway Execution
## Join / Synchronization
## Variables and Scope
## Task Workers / AI Tasks / Human Tasks
## Events / Timers / External Signals
## Retry / Error / Incident Handling
## Persistence / Resume / Idempotency
## Observability / Audit
## Unsupported / Partial BPMN Features
## Required Engine Changes
## Implementation Constraints
## Test Scenarios Derived from BPMN
```

## Test-scenario handoff

Derive implementation tests from BPMN semantics, including applicable cases such as:

- XOR selects exactly one route;
- XOR no-match uses default flow;
- OR activates multiple matching flows;
- OR join synchronizes only activated paths;
- parallel split activates all paths;
- parallel join waits correctly;
- event race continues only through winning event;
- timer boundary behavior;
- error boundary behavior;
- persisted wait resumes after restart;
- variable scope across subprocesses;
- no routing condition is hidden inside a task executor.

## Completion gate

Mapping is complete only when every BPMN construct used by the process is either:

- fully mapped with semantics preserved; or
- explicitly reported as a blocking engine capability gap.

Do not release a semantically degraded mapping as DONE.
