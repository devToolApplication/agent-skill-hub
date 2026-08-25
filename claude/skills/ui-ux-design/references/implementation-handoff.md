# UIUX Implementation Handoff

UIUX does not dispatch code workers directly.

1. Parent creates `uiux-spec-v1`.
2. Parent loads frontend architecture policy and inspects current FE implementation.
3. Parent maps UIUX requirement IDs to exact FE implementation decisions.
4. Parent dispatches `fe_code_edit` / `fe_test_author` using write-task-v5.
5. `uiux_spec_verify` checks the implementation evidence against the original requirement IDs.

See engineering orchestrator `references/uiux-fe-handoff.md`.
