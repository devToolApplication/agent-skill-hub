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
SKILL_UNAVAILABLE
REQUIREMENT_CONFLICT
ARCHITECTURE_DECISION_REQUIRED
BLOCKED
```

## Global skill gate

Before any spawned assignment begins, Main MUST resolve the role through `09-skill-routing.md` and ensure all `required_skills` are available.

If a mandatory skill cannot be resolved:

```text
assignment
→ SKILL_UNAVAILABLE
→ return missing skill IDs to Main
→ resolve/install/map skill or BLOCK
```

A `SKILL_UNAVAILABLE` result can never be treated as PASS.

Every mandatory agent result SHOULD record `skills_used`.

## Transition rules

- `DRAFT → DISCOVERY`: feature workspace initialized.
- `DISCOVERY → REQUIREMENTS_LOCKED`: critical requirements, scope, acceptance criteria, and business-visible constraints are explicit.
- `REQUIREMENTS_LOCKED → DESIGNING`: AI spec has stable requirement IDs.
- `DESIGNING → DESIGN_READY`: architecture decisions and phase boundaries are approved.
- `DESIGN_READY → PHASE_PLANNING`: next phase selected.
- `PHASE_PLANNING → IMPLEMENTING`: GSD plan/check agents used required skills and plans pass plan checker.
- `IMPLEMENTING → PHASE_REVIEW`: every plan in phase passes mandatory task reviews with skill evidence.
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

Never advance across a hard gate when mandatory evidence or required-skill evidence is missing.

### Requirement gate

Require:
- stable requirement IDs;
- explicit scope/out-of-scope;
- acceptance criteria;
- known critical constraints;
- unresolved critical question count = 0.

### Plan gate

Require:
- `gsd-plan-phase` resolved and used by required planning roles;
- requirement mappings exist;
- dependencies valid;
- tests and verification explicit;
- plan checker PASS.

### Task gate

Require:
- implementation result COMPLETE;
- implementation agent used `test-driven-development`;
- `systematic-debugging` used when debugging trigger occurred;
- `receiving-code-review` used when review-fix trigger occurred;
- tests executed;
- Spec Reviewer PASS with `verification-before-completion`;
- Test Reviewer PASS with `verification-before-completion`;
- Code Reviewer PASS with `requesting-code-review` + `verification-before-completion`;
- all triggered dynamic reviewers PASS with required skills;
- zero unresolved BLOCKER/HIGH findings.

### Phase gate

Require:
- all task gates PASS;
- phase reviewer used `gsd-code-review`, `gsd-validate-phase`, and `verification-before-completion`;
- conditional `gsd-secure-phase` / `gsd-ui-review` used when triggered;
- phase-level verification PASS;
- phase acceptance criteria PASS;
- no unresolved phase gap.

### Local validation gate

Before any candidate push/CD test deployment, require:

- local integration verifier used `verification-before-completion` and PASS;
- every mandatory local live/E2E scenario PASS using required validation skills;
- browser/UI scenarios used the configured browser/Playwright skill when applicable;
- relevant local regression suite PASS;
- zero unresolved BLOCKER/HIGH findings;
- local evidence recorded;
- no code change after successful local gate without re-running required local validation.

If local validation fails, state becomes `LOCAL_TEST_FIX_REQUIRED` and workflow returns through fix/review/local-validation. CD deployment is forbidden.

### CD deployment gate

Require:

- local validation gate PASS;
- candidate revision/commit SHA recorded;
- only that candidate pushed/deployed;
- CD deployment success;
- deployed revision/version matches candidate that passed local validation.

If deployment fails or revision is wrong, state becomes `CD_DEPLOY_BLOCKED`.

### Test-environment validation gate

Require:

- test-environment integration verifier used required verification skill and PASS;
- every mandatory test-environment live/E2E scenario PASS using required skills;
- browser/UI scenarios used configured browser/Playwright skill where applicable;
- required regression suite PASS;
- zero unresolved BLOCKER/HIGH findings;
- evidence references deployed candidate revision.

A test-environment failure MUST NOT be hot-fixed directly in shared environment. Return to local reproduction/fix/review and re-run complete required local gate before pushing a new candidate.

### UAT gate

Require:
- `gsd-verify-work` available and used;
- `verification-before-completion` used;
- UAT PASS.

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
- traceability complete for LOCAL and TEST_ENV where applicable;
- current-state docs updated;
- zero unresolved BLOCKER/HIGH findings;
- no unresolved `SKILL_UNAVAILABLE`.

## Conflict routes

### Skill unavailable

Set `SKILL_UNAVAILABLE` for the assignment.

Main may:
- resolve an installed alias/equivalent and record `resolved_as`;
- install/configure the required skill outside this workflow when supported;
- choose an explicitly approved equivalent skill;
- BLOCK the workflow.

Main MUST NOT silently drop the required skill.

### Scope expansion

Subagent returns `SCOPE_EXPANSION_REQUIRED` with evidence. Main chooses to reject it, extend plan, add a new plan, change a phase, or revise requirements.

### Requirement conflict

Set `REQUIREMENT_CONFLICT`. Do not code around it. Main resolves intent, updates specs/decisions, then resumes planning.

### Architecture decision

Set `ARCHITECTURE_DECISION_REQUIRED`. Code agent must not silently introduce major architecture changes. Main owns decision and records it.

### Local validation failure

Set `LOCAL_TEST_FIX_REQUIRED`.

```text
local failure
→ debug/research with required skills
→ fix plan/code
→ task reviews
→ local integration
→ full required local live/E2E
→ local gate
```

Do not push/CD while unresolved.

### Test-environment validation failure

Set `TEST_ENV_TEST_FIX_REQUIRED`.

```text
test-env failure
→ capture deployed revision/evidence
→ reproduce/investigate locally
→ fix locally using required implementation/debug skills
→ task reviews
→ full required local gate PASS
→ new candidate revision
→ CD redeploy
→ test-env integration/live/E2E again
```

### Repeated failure

Escalate according to model-routing policy. If attempts are exhausted, set `BLOCKED` and create a blocking report.
