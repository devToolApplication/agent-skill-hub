# BPMN Skill Workflow

```text
PROCESS_REQUIREMENTS -> SEMANTIC_MODEL -> BPMN_DESIGN -> VALIDATE -> ENGINE_MAP -> SCENARIO_SIMULATION -> SELF_REVIEW -> HANDOFF
```

- PROCESS_REQUIREMENTS: identify actors, work, human decisions, async boundaries, retries/timeouts/errors and completion criteria.
- SEMANTIC_MODEL: skill `bpmn-modeler`.
- BPMN_DESIGN: skill `bpmn-design`; enforce `roles/bpmn.md`.
- VALIDATE: skill `bpmn-validator`; no deadlock, unbounded loop, missing join/correlation/timeout/error route.
- ENGINE_MAP: skills `bpmn-architect`, `bpmn-engine-mapper`; keep semantics distinct from Flowable/Camunda/Zeebe/custom implementation.
- SCENARIO_SIMULATION: walk happy, alternate, runtime-error, retry and human-recovery paths.
- SELF_REVIEW: rerun validator/checklist after any change.
- HANDOFF: BPMN artifact, engine mapping, correlation/retry/error assumptions and validation evidence.
