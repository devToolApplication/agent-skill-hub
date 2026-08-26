---
name: bpmn-modeler
description: Translate an approved BPMN process design into standards-compliant BPMN 2.0 XML/model without changing business semantics. Use after bpmn-architect and before independent validation. Owns BPMN element selection, IDs, sequence flows, conditions, events, scopes, and model structure; never invents missing business rules.
---

# BPMN Modeler

## Purpose

Convert `01-process-design.md` or an equivalent approved logical process specification into a machine-readable BPMN 2.0 model.

The modeler implements process semantics in BPMN. It does not decide new business semantics.

## Hard rules

### MODEL-001 — Preserve architecture

Do not change gateway type, branch meaning, error behavior, participant boundaries, or end-state semantics just because another model is easier to draw.

If the architecture cannot be represented unambiguously, stop and return a modeling/blocking finding.

### MODEL-002 — Conditions belong to Sequence Flow

Represent branch conditions on `bpmn:sequenceFlow` condition expressions where BPMN semantics allow them.

Do not encode conditional routing inside a gateway node or pseudo-task config.

Conceptual example:

```xml
<bpmn:exclusiveGateway id="Gateway_CandidateType" default="Flow_Default" />

<bpmn:sequenceFlow id="Flow_Parent"
                   sourceRef="Gateway_CandidateType"
                   targetRef="Task_ParentFlow">
  <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression">
    ${candidate.isParent == true}
  </bpmn:conditionExpression>
</bpmn:sequenceFlow>
```

Expression syntax is illustrative. Use the target engine expression syntax only when the project has explicitly selected it; otherwise keep expression intent vendor-neutral/documented.

### MODEL-003 — Parallel gateway is not a decision gateway

Do not put data-based branch conditions on outgoing paths from a parallel gateway as a substitute for XOR/OR logic.

### MODEL-004 — Explicit default behavior

When architecture defines a default/no-match route, encode it explicitly using BPMN default flow semantics where supported.

### MODEL-005 — IDs are stable and meaningful

Use deterministic, readable IDs suitable for review/diffing. Do not regenerate every ID arbitrarily on each edit.

Recommended patterns:

```text
StartEvent_<Name>
Task_<Name>
Gateway_<Name>
Flow_<Source>_<Target>
BoundaryEvent_<Name>
SubProcess_<Name>
EndEvent_<Name>
```

### MODEL-006 — Events have correct attachment/scope

Ensure boundary events, intermediate catch/throw events, timers, messages, signals, errors, and escalation semantics match the approved process design.

### MODEL-007 — Vendor extensions are isolated

Prefer standards-compliant BPMN 2.0 elements. Add Camunda/Flowable/custom extensions only when required by the approved engine mapping or project convention.

Never let a vendor extension silently replace missing BPMN semantics.

### MODEL-008 — BPMN DI should not redefine logic

Diagram layout/coordinates are presentation. Logical BPMN elements and sequence flows are the source of execution semantics.

When producing a diagram-viewable `.bpmn`, include valid BPMN DI when practical/required by the project, but never change logic merely for layout.

## Modeling procedure

1. Read the entire approved process design.
2. Create process/collaboration boundaries and participants where applicable.
3. Add start/end events.
4. Add tasks/subprocesses/events in logical order.
5. Add gateways with architecture-approved types.
6. Add every sequence flow.
7. Put approved conditions/default-flow semantics on the correct flows.
8. Add boundary/intermediate events, loops, multi-instance, and subprocess scopes where specified.
9. Add data/input-output metadata only when it improves execution/traceability and matches project conventions.
10. Validate internal references/IDs locally before handoff.
11. Produce a concise model summary noting any assumptions or unsupported constructs.

## Required output

Primary artifact:

```text
process.bpmn
```

The BPMN model should be valid XML and target BPMN 2.0 namespaces.

Optionally provide a short companion summary containing:

```text
process id
participants
start/end events
gateway list
default flows
error/timer events
subprocesses
vendor extensions used
known assumptions
```

## Forbidden transformations

Do not convert:

```text
Evaluate → Gateway → conditioned flows
```

into:

```text
AI_GATE(condition)
```

Do not collapse multiple semantically distinct tasks/events into one node if that makes retry, error, wait, audit, or ownership behavior invisible.

Do not invent an XOR priority order when conditions overlap unless architecture explicitly defines one.

## Handoff contract

Hand the finished model to an independent `bpmn-validator`.

A modeler MUST NOT self-certify semantic PASS. It may perform preflight checks, but independent validation owns the gate.
