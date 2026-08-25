# Workflow State Machine

## States

Normal lifecycle:

```text
DRAFT
→ DISCOVERY
→ REQUIREMENTS_LOCKED
→ DESIGNING
→ DESIGN_READY
→ PHASE_PLANNING
→ IMPLEMENTING
→ PHASE_REVIEW
→ INTEGRATION_VERIFY
→ LIVE_TESTING
→ UAT
→ FINAL_AUDIT
→ DONE
```

Failure/intermediate states:

```text
PLAN_FIX_REQUIRED
IMPLEMENTATION_FIX_REQUIRED
PHASE_FIX_REQUIRED
INTEGRATION_FIX_REQUIRED
LIVE_TEST_FIX_REQUIRED
REQUIREMENT_CONFLICT
ARCHITECTURE_DECISION_REQUIRED
BLOCKED
```

## Transition rules

- `DRAFT → DISCOVERY`: feature workspace initialized.
- `DISCOVERY → REQUIREMENTS_LOCKED`: critical requirements, scope, acceptance criteria, and business-visible constraints are explicit.
- `REQUIREMENTS_LOCKED → DESIGNING`: AI spec has stable requirement IDs.
- `DESIGNING → DESIGN_READY`: architecture decisions and phase boundaries are approved.
- `DESIGN_READY → PHASE_PLANNING`: next phase selected.
- `PHASE_PLANNING → IMPLEMENTING`: implementation plans pass plan checker.
- `IMPLEMENTING → PHASE_REVIEW`: every plan in phase passes mandatory task reviews.
- `PHASE_REVIEW → PHASE_PLANNING`: phase gap found; create gap plans.
- `PHASE_REVIEW → IMPLEMENTING`: another planned phase exists after phase gate PASS.
- final phase PASS → `INTEGRATION_VERIFY`.
- integration PASS → `LIVE_TESTING`.
- live/E2E PASS → `UAT`.
- UAT PASS → `FINAL_AUDIT`.
- final audit PASS → `DONE`.

## Hard gates

Never advance across a hard gate when mandatory evidence is missing.

### Requirement gate

Require:
- stable requirement IDs;
- explicit scope/out-of-scope;
- acceptance criteria;
- known critical constraints;
- unresolved critical question count = 0.

### Task gate

Require:
- implementation result COMPLETE;
- tests executed;
- Spec Reviewer PASS;
- Test Reviewer PASS;
- Code Reviewer PASS;
- all triggered dynamic reviewers PASS;
- zero unresolved BLOCKER/HIGH findings.

### Phase gate

Require:
- all task gates PASS;
- phase-level verification PASS;
- phase acceptance criteria PASS;
- no unresolved phase gap.

### Feature gate

Require:
- all phases PASS;
- integration PASS;
- live/E2E PASS;
- UAT PASS;
- Grill final check PASS;
- traceability complete;
- current-state docs updated;
- zero BLOCKER/HIGH findings.

## Conflict routes

### Scope expansion

Subagent returns `SCOPE_EXPANSION_REQUIRED` with evidence. Main chooses to reject it, extend the plan, add a new plan, change a phase, or revise requirements.

### Requirement conflict

Set `REQUIREMENT_CONFLICT`. Do not code around it. Main resolves intent, updates specs/decisions, then resumes planning.

### Architecture decision

Set `ARCHITECTURE_DECISION_REQUIRED`. Code agent must not silently introduce major architecture changes. Main owns the decision and records it.

### Repeated failure

Escalate according to model-routing policy. If attempts are exhausted, set `BLOCKED` and create a blocking report.
