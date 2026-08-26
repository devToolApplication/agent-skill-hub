---
name: bpmn-validator
description: Independently validate BPMN 2.0 models for syntax, graph integrity, gateway semantics, condition correctness, split/join behavior, event/error/timer semantics, variable availability, reachability, dead ends, and process soundness. Use after bpmn-modeler and after every BPMN fix; owns PASS/FAIL but never changes business policy silently.
---

# BPMN Validator

## Purpose

Provide an independent quality gate for BPMN designs before engine mapping and implementation planning.

The validator reviews both the logical process design and the BPMN model when available.

## Independence rule

The same agent/context that created the BPMN model should not be the sole validator for non-trivial workflows.

The validator may suggest fixes but MUST NOT redefine missing business policy just to make the model pass.

## Validation layers

### 1. XML / structural validity

Check:

- well-formed XML;
- BPMN 2.0 namespace usage;
- unique IDs;
- valid `sourceRef` / `targetRef` references;
- valid event attachments;
- process/collaboration references;
- BPMN DI references when DI exists;
- engine/vendor extensions do not break model structure.

### 2. Graph integrity

Check:

- start event(s) can reach intended end states;
- no orphan/unreachable executable nodes;
- no unintended dead-end path;
- no accidental disconnected component;
- loop paths have a termination condition or an explicitly accepted unbounded behavior;
- subprocess boundaries/scopes are consistent.

### 3. Gateway semantics

For every gateway verify:

#### Exclusive Gateway

- conditions are mutually exclusive, or explicit priority behavior exists;
- default/no-match behavior is defined when conditions are not provably exhaustive;
- merge use does not accidentally imply synchronization.

#### Inclusive Gateway

- multiple outgoing branches are allowed by requirement;
- condition coverage is understood;
- any inclusive join waits only for branches that can actually be active under the modeled semantics;
- no join deadlock is introduced by structurally impossible/ambiguous activation.

#### Parallel Gateway

- all outgoing branches intentionally activate;
- outgoing conditional expressions are not used as decision logic;
- join cardinality/synchronization matches the split behavior;
- a branch that can terminate/cancel early does not leave an unintended permanent wait.

#### Event-Based Gateway

- outgoing paths are triggered by valid catching events/receive tasks as required by BPMN semantics;
- no data condition is masquerading as an event race;
- cancellation behavior for competing event subscriptions is understood.

### 4. Sequence Flow conditions

Check:

- business routing conditions are on flows rather than pseudo decision nodes;
- expressions reference data available at that point;
- overlap is intentional;
- gaps/no-match are intentional;
- default flow behavior is explicit;
- expression language/vendor syntax is compatible with the selected engine if an engine is already fixed.

Flag pseudo-gates such as:

```text
AI_GATE
CODE_GATE
DECISION_TASK
CHECK_CONDITION_NODE
```

when they encode BPMN routing semantics that should live in gateways/flows.

### 5. Events, errors, retries, timers

Check:

- boundary events attach to valid activities;
- interrupting vs non-interrupting behavior matches requirement;
- timer semantics are explicit;
- retry is not incorrectly modeled as a business loop;
- business error paths are not hidden inside worker code;
- cancellation/termination behavior is intentional;
- compensation is used only for business undo semantics, not generic technical retry.

### 6. Data / variable availability

For every routing expression or task input verify:

- producer exists;
- producer executes before consumer on every relevant path;
- scope is valid across subprocess boundaries;
- parallel branches do not create unsafe/undefined write races;
- joins do not assume data from a branch that may never activate.

### 7. Requirement traceability

Check that important requirements map to visible BPMN constructs or explicit process notes.

Flag:

- behavior in BPMN with no requirement justification;
- requirement behavior missing from BPMN;
- implementation-specific behavior that changes process semantics but is absent from BPMN.

## Finding classification

Each finding MUST contain:

```yaml
id: BPMN-VAL-001
severity: BLOCKER | HIGH | MEDIUM | LOW
category: BUSINESS_SEMANTIC | BPMN_SYNTAX | BPMN_SEMANTIC | MODEL_STRUCTURE | DATA_FLOW | ENGINE_COMPATIBILITY
location: <element/flow/id>
problem: <what is wrong>
impact: <runtime/business consequence>
recommended_owner: bpmn-architect | bpmn-modeler | bpmn-engine-mapper
recommended_fix: <bounded correction>
```

## Routing findings

```text
BUSINESS_SEMANTIC
→ bpmn-architect

BPMN_SYNTAX
BPMN_SEMANTIC
MODEL_STRUCTURE
DATA_FLOW caused by model structure
→ bpmn-modeler

ENGINE_COMPATIBILITY
→ bpmn-engine-mapper
→ if correction changes business semantics, escalate to bpmn-architect/Main
```

## PASS rules

Return `PASS` only when:

- zero BLOCKER findings;
- zero HIGH findings;
- no unresolved business ambiguity required for execution correctness;
- routing semantics are explicit;
- no known deadlock/unreachable/dead-end defect remains;
- no model/engine mismatch is being hidden as an implementation detail.

Medium/low findings may remain only if documented and explicitly non-blocking.

## Required output

Produce `02-bpmn-validation.md` with:

```markdown
# BPMN Validation

## Result
PASS | FAIL

## Inputs Reviewed
## Structural Checks
## Graph Checks
## Gateway Checks
## Sequence Flow / Conditions
## Events / Error / Timer Checks
## Variable / Data Checks
## Requirement Traceability
## Findings
## Revalidation Notes
```

Also expose a machine-readable summary when useful:

```yaml
status: PASS | FAIL
blocking_findings: 0
high_findings: 0
medium_findings: 0
low_findings: 0
```

## Revalidation rule

After any BPMN correction that could affect execution semantics, rerun all impacted checks. Never mark a previous FAIL as PASS based only on a proposed fix.
