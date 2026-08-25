# State Machine v5

```text
INTAKE
  -> CLASSIFY_DOMAINS
  -> LOAD_PARENT_POLICIES

IF UX/DESIGN AFFECTED:
  -> UIUX_DISCOVER
  -> PARENT_DESIGN_DECISION
  -> CREATE_UIUX_SPEC_V1

FOR BACKEND/FRONTEND IMPLEMENTATION:
  -> DOMAIN_DISCOVER exact missing facts
  -> PARENT_ARCHITECTURE_DECISION
  -> BUILD_DAG
  -> PREPARE_TASKSPEC_V5
       missing location/behavior -> matching read worker
       missing UX direction -> parent UIUX decision/spec
       missing FE/BE architecture direction -> parent decides
       missing exact files -> matching read worker
  -> EXECUTE_WRITE_WORKERS
  -> VERIFY_COMMANDS
  -> COLLECT_FE_BE_EVIDENCE

IF UIUX_SPEC_EXISTS:
  -> UIUX_SPEC_VERIFY

  -> PARENT_JUDGE
       changes required -> create new exact bounded task
       unverifiable visual behavior -> state uncertainty, do not invent PASS
       pass -> COMPLETE
```

Workers can return BLOCKED. The parent resolves blocked conditions and redispatches; workers never broaden scope or switch role/domain themselves.
