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
→ LOCAL_INTEGRATION_VERIFY
→ LOCAL_LIVE_TESTING
→ READY_FOR_CD_TEST
→ CD_TEST_DEPLOYING
→ TEST_ENV_INTEGRATION_VERIFY
→ TEST_ENV_LIVE_TESTING
→ UAT
→ FINAL_AUDIT
→ DONE
```

Failure/intermediate states:

```text
PLAN_FIX_REQUIRED
IMPLEMENTATION_FIX_REQUIRED
PHASE_FIX_REQUIRED
LOCAL_TEST_FIX_REQUIRED
CD_DEPLOY_BLOCKED
TEST_ENV_TEST_FIX_REQUIRED
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
- final phase PASS → `LOCAL_INTEGRATION_VERIFY`.
- local integration PASS → `LOCAL_LIVE_TESTING`.
- full local live/E2E PASS → `READY_FOR_CD_TEST`.
- only `READY_FOR_CD_TEST` may create/push the candidate revision and start CD deployment.
- candidate pushed/CD started → `CD_TEST_DEPLOYING`.
- successful deployment of the expected candidate revision → `TEST_ENV_INTEGRATION_VERIFY`.
- test-environment integration PASS → `TEST_ENV_LIVE_TESTING`.
- full test-environment live/E2E PASS → `UAT`.
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

### Local validation gate

Before any candidate push/CD test deployment, require:

- local integration verification PASS;
- every mandatory local live/E2E scenario PASS;
- relevant local regression suite PASS;
- zero unresolved BLOCKER/HIGH findings;
- local evidence recorded;
- no code change after the successful local gate without re-running the required local validation.

If local validation fails, state becomes `LOCAL_TEST_FIX_REQUIRED` and the workflow returns through fix/review/local-validation. CD deployment is forbidden.

### CD deployment gate

Require:

- local validation gate PASS;
- candidate revision/commit SHA recorded;
- only that candidate is pushed/deployed;
- CD deployment reports success;
- deployed revision/version matches the candidate that passed local validation.

If deployment fails or deployed revision is wrong, state becomes `CD_DEPLOY_BLOCKED`.

### Test-environment validation gate

Require:

- test-environment integration verification PASS;
- every mandatory test-environment live/E2E scenario PASS;
- required regression suite PASS;
- zero unresolved BLOCKER/HIGH findings;
- evidence references the deployed candidate revision.

A test-environment failure MUST NOT be hot-fixed directly in the shared environment. Return to local reproduction/fix/review and re-run the complete required local gate before pushing a new candidate.

### Feature gate

Require:
- all phases PASS;
- local integration PASS;
- local full live/E2E PASS;
- CD test deployment PASS;
- test-environment integration PASS;
- test-environment full live/E2E PASS;
- UAT PASS;
- Grill final check PASS;
- traceability complete for both LOCAL and TEST_ENV where applicable;
- current-state docs updated;
- zero BLOCKER/HIGH findings.

## Conflict routes

### Scope expansion

Subagent returns `SCOPE_EXPANSION_REQUIRED` with evidence. Main chooses to reject it, extend the plan, add a new plan, change a phase, or revise requirements.

### Requirement conflict

Set `REQUIREMENT_CONFLICT`. Do not code around it. Main resolves intent, updates specs/decisions, then resumes planning.

### Architecture decision

Set `ARCHITECTURE_DECISION_REQUIRED`. Code agent must not silently introduce major architecture changes. Main owns the decision and records it.

### Local validation failure

Set `LOCAL_TEST_FIX_REQUIRED`.

Route:

```text
local failure
→ debug/research
→ fix plan/code
→ task reviews
→ local integration
→ full required local live/E2E
→ local gate
```

Do not push/CD while this state is unresolved.

### Test-environment validation failure

Set `TEST_ENV_TEST_FIX_REQUIRED`.

Route:

```text
test-env failure
→ capture deployed revision/evidence
→ reproduce/investigate locally
→ fix locally
→ task reviews
→ full required local gate PASS
→ new candidate revision
→ CD redeploy
→ test-env integration/live/E2E again
```

### Repeated failure

Escalate according to model-routing policy. If attempts are exhausted, set `BLOCKED` and create a blocking report.
