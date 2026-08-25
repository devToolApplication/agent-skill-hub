# Worker Result Contract v5

Every subagent returns structured execution/evidence only.

```json
{
  "schema": "worker-result-v5",
  "task_id": "FE-EDIT-01",
  "worker": "fe_code_edit",
  "worker_skill": ".agents/skills/fe-code-edit/SKILL.md",
  "domain": "frontend",
  "status": "PASS",
  "blocked_code": null,
  "summary": "Applied only the exact parent-directed change.",
  "preflight": {
    "task_schema": "PASS",
    "worker_identity": "PASS",
    "worker_skill": "PASS",
    "scope": "PASS",
    "direction": "PASS",
    "policy_refs": "PASS"
  },
  "loaded_policy_refs": [],
  "facts": [],
  "requirement_coverage": [],
  "files_changed": [],
  "scope_check": {"status":"PASS","unexpected_files":[],"unexpected_symbols":[]},
  "policy_check": {"status":"PASS","violations":[]},
  "self_check": {"role_domain":"PASS","direction_followed":"PASS","acceptance":"PASS"},
  "commands": [],
  "uncertainties": [],
  "requested_scope": null
}
```

Valid status: `PASS`, `FAIL`, `BLOCKED`.

Standard blocked codes:

```text
INVALID_TASK_SCHEMA
WORKER_IDENTITY_MISMATCH
WORKER_SKILL_MISMATCH
MISSING_PROBLEM
MISSING_EVIDENCE
MISSING_FIX_DIRECTION
MISSING_POLICY_REFS
POLICY_UNAVAILABLE
POLICY_CONFLICT
MISSING_EXACT_SCOPE
MISSING_PER_FILE_CHANGE
MISSING_ACCEPTANCE
MISSING_VERIFICATION
MISSING_SPEC_REF
SCOPE_INSUFFICIENT
DIRECTION_CONFLICT
UNAUTHORIZED_NEW_FILE
UNAUTHORIZED_DEPENDENCY_CHANGE
UNAUTHORIZED_CONTRACT_CHANGE
DOMAIN_BOUNDARY_CONFLICT
DESIGN_CONTRACT_CONFLICT
NOT_VERIFIABLE_FROM_AVAILABLE_EVIDENCE
```

Workers never grant final engineering or UX approval.
