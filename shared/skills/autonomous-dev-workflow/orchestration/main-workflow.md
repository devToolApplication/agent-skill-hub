# Main Orchestrator Workflow

Main owns delivery state, dependency scheduling, assignment quality, fan-out/fan-in and gates. Main does not own implementation.

## 1. INTAKE

- Establish `feature_id`, scope and source requirements.
- Route ambiguity/business conflicts to `ba-agent`.
- Do not proceed with critical unresolved requirements.

## 2. DESIGN / CONTRACT LOCK

- Spawn `architect-agent` for architecture/cross-service/API/data decisions as needed.
- Spawn `bpmn-agent` when process semantics are material.
- Stabilize contracts that allow downstream work to proceed independently.

## 3. DAG PLANNING

The plan MUST:

- create small bounded tasks with stable IDs;
- declare `agent`, never a model;
- record design/runtime dependencies and write conflicts separately;
- split BE/FE/QA-preparation work that can run from a stable contract;
- split large same-role work into independent ownership scopes;
- identify shared files and move those writes into a later integration/fan-in task when practical;
- identify independent reviewers per task.

Reject plans that serialize independent work without a dependency reason.

## 4. DYNAMIC SCHEDULER LOOP

Repeat until all required nodes are terminal:

1. Recalculate task states.
2. Find tasks whose design dependencies are PASS.
3. Exclude tasks blocked by write conflict or agent concurrency capacity.
4. Prioritize critical-path/unblocker tasks.
5. Acquire ownership/write locks.
6. Spawn all safe READY tasks concurrently using their configured `agent`.
7. Collect completed results continuously.
8. Start rolling independent review as soon as a task self-gate passes.
9. On review failure, route feedback to the original implementation role and require its repair workflow.
10. Release locks and immediately dispatch newly unblocked work; do not wait for the rest of the old batch.

## 5. FAN-IN / INTEGRATION

After dependent implementation nodes pass:

- create an integration task for shared registration/routes/module exports/contracts where required;
- prohibit the integration task from redesigning approved behavior;
- run affected build/integration/contract checks;
- re-review integration-only changes when material.

## 6. QA / E2E / PHASE GATE

- Execute integration and E2E tests after runtime dependencies are available.
- Independent phase review checks traceability, integration and unresolved findings.
- BLOCKER/HIGH findings fail the gate.

## 7. FINAL GATE

Feature is complete only when requirements, implementation nodes, independent reviews, integration verification, QA/E2E and required documentation are PASS with current evidence.
