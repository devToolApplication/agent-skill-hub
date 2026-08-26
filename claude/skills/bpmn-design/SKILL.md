---
name: bpmn-design
description: Orchestrate BPMN 2.0 process design from approved requirements through architecture, modeling, independent validation, and project-engine mapping before implementation planning. Use for workflow, process, routing, approval, state-transition, branching, parallel, retry, timeout, or long-running business-process features.
---

# BPMN Design Orchestrator

Coordinate BPMN work in this order:

```text
approved requirements
→ bpmn-architect
→ bpmn-modeler
→ bpmn-validator
→ bpmn-engine-mapper
→ implementation planning
```

## Hard gate

Do not start implementation planning or code until `bpmn-validator` returns `PASS` and the engine mapping preserves the validated BPMN semantics.

## Mandatory rules

- Routing conditions belong on BPMN `SequenceFlow`, not pseudo decision nodes.
- A task may calculate data; a gateway routes based on data/events.
- Choose gateway semantics intentionally: XOR, OR, AND, or event-based.
- Explicitly define split/join behavior, default/no-match behavior, errors, retries, timers, and cancellation where applicable.
- Model vendor-neutral BPMN 2.0 semantics first; map project/engine extensions afterward.
- Never invent missing business policy to make the diagram executable.

## Required skills

Resolve and use these skills:

```text
bpmn-architect
bpmn-modeler
bpmn-validator
bpmn-engine-mapper
```

If any mandatory skill is unavailable, return `SKILL_UNAVAILABLE`.

## Workflow

### 1. Architecture

Run `bpmn-architect` against approved requirements/technical design.

Produce:

```text
01-process-design.md
```

### 2. Modeling

Run `bpmn-modeler` using the approved process design.

Produce:

```text
process.bpmn
```

The modeler must not change business semantics.

### 3. Independent validation

Run `bpmn-validator` independently. Validate syntax, graph reachability, gateway semantics, split/join behavior, condition coverage/overlap, default flows, event/error/timeout behavior, variable availability, dead ends, loops, and extension leakage.

Produce:

```text
02-bpmn-validation.md
```

Result is `PASS` or `FAIL`.

Route failures:

```text
business ambiguity → bpmn-architect
model/syntax/semantic defect → bpmn-modeler
engine limitation → bpmn-engine-mapper; if behavior changes, escalate back to architect/Main
```

After every fix, rerun validation.

### 4. Engine mapping

Only after validation PASS, run `bpmn-engine-mapper`.

Produce:

```text
03-engine-mapping.md
```

Typical mapping boundary:

```text
ServiceTask             → executable task/worker
UserTask                → human task
ExclusiveGateway        → XOR routing
InclusiveGateway        → OR routing
ParallelGateway         → fork/join synchronization
SequenceFlow.condition  → edge condition/expression
BoundaryTimer           → timeout/timer subscription
BoundaryError           → error transition
SubProcess              → nested process/scope
```

### 5. Release gate

Implementation planning may begin only when:

```yaml
architect: DONE
modeler: DONE
validator: PASS
engine_mapper: DONE
blocking_ambiguities: 0
```

## Recommended artifacts

```text
<feature-docs>/02-design/bpmn/
├── 01-process-design.md
├── process.bpmn
├── 02-bpmn-validation.md
└── 03-engine-mapping.md
```

## Core anti-pattern

Do not model business routing as nodes such as `AI_GATE`, `CODE_GATE`, `DECISION_TASK`, or `CHECK_CONDITION_NODE`. Keep evaluation/work separate from BPMN routing and place branch conditions on flows.
