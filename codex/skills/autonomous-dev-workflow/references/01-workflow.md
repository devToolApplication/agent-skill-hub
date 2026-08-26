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
SKILL_PATH_INVALID
REQUIREMENT_CONFLICT
ARCHITECTURE_DECISION_REQUIRED
BLOCKED
```

## Global skill preflight gate

Before normal delegation begins, Main MUST discover the actual skill roots available to the current Codex runtime/workspace and build a verified session skill index.

For every canonical skill used by a child, Main MUST resolve:

```yaml
id: <canonical-id>
resolved_as: <installed-name-or-alias>
skill_dir: <actual-installed-directory>
skill_file: <actual-installed-directory>/SKILL.md
verified: true
```

Do not invent paths or assume one fixed global root.

## Global skill gate

Before any spawned assignment begins, Main MUST:

1. resolve the role through `09-skill-routing.md`;
2. resolve all required canonical skills to concrete installed paths;
3. verify each supplied `SKILL.md` exists/is readable;
4. include those exact paths in the structured assignment;
5. include those same paths in the actual subagent prompt;
6. explicitly instruct the child to read/follow them before work.

If Main cannot resolve a mandatory skill:

```text
assignment
→ SKILL_UNAVAILABLE
→ return missing skill IDs to Main
→ resolve/install/map skill or BLOCK
```

If the child finds a supplied path invalid:

```text
assignment
→ SKILL_PATH_INVALID
→ return invalid skill/path to Main
→ Main re-resolves path
→ rebuild prompt
→ respawn/retry
```

A child MUST NOT search for an alternate workflow skill by itself.

Neither `SKILL_UNAVAILABLE` nor `SKILL_PATH_INVALID` can ever be treated as PASS.

Every mandatory agent result SHOULD record `skills_used`, including the `skill_file` actually read.

## Transition rules

- `DRAFT → DISCOVERY`: feature workspace initialized and required Main-stage skills can be resolved as needed.
- `DISCOVERY → REQUIREMENTS_LOCKED`: critical requirements, scope, acceptance criteria, and business-visible constraints are explicit.
- `REQUIREMENTS_LOCKED → DESIGNING`: AI spec has stable requirement IDs.
- `DESIGNING → DESIGN_READY`: architecture decisions and phase boundaries are approved.
- `DESIGN_READY → PHASE_PLANNING`: next phase selected.
- `PHASE_PLANNING → IMPLEMENTING`: GSD plan/check agents received valid concrete skill paths, used required skills, and plans pass plan checker.
- `IMPLEMENTING → PHASE_REVIEW`: every plan in phase passes mandatory task reviews with skill/path evidence.
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

Never advance across a hard gate when mandatory evidence, required-skill evidence, or concrete skill-path evidence is missing.

### Requirement gate

Require:
- stable requirement IDs;
- explicit scope/out-of-scope;
- acceptance criteria;
- known critical constraints;
- unresolved critical question count = 0.

### Plan gate

Require:
- `gsd-plan-phase` resolved to a valid concrete `SKILL.md` path for required planning roles;
- planners received/read the supplied skill file;
- requirement mappings exist;
- dependencies valid;
- tests and verification explicit;
- plan checker PASS.

### Task gate

Require:
- implementation result COMPLETE;
- implementation agent received/read the resolved `test-driven-development/SKILL.md`;
- `systematic-debugging` concrete path was supplied/read when debugging trigger occurred;
- `receiving-code-review` concrete path was supplied/read when review-fix trigger occurred;
- tests executed;
- Spec Reviewer PASS with resolved/read `verification-before-completion`;
- Test Reviewer PASS with resolved/read `verification-before-completion`;
- Code Reviewer PASS with resolved/read `requesting-code-review` + `verification-before-completion`;
- all triggered dynamic reviewers PASS with required skills/paths;
- zero unresolved BLOCKER/HIGH findings;
- zero `SKILL_UNAVAILABLE` / `SKILL_PATH_INVALID` results.

### Phase gate

Require:
- all task gates PASS;
- phase reviewer received/read concrete paths for `gsd-code-review`, `gsd-validate-phase`, and `verification-before-completion`;
- phase-level verification PASS;
- phase acceptance criteria PASS;
- no unresolved phase gap.

### Local validation gate

Before any candidate push/CD test deployment, require:

- local verification agents received/read all required concrete skill files;
- local integration verification PASS;
- every mandatory local live/E2E scenario PASS;
- relevant local regression suite PASS;
- zero unresolved BLOCKER/HIGH findings;
- zero unresolved skill/path errors;
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

- test-env agents received/read required concrete skill files;
- test-environment integration verification PASS;
- every mandatory test-environment live/E2E scenario PASS;
- required regression suite PASS;
- zero unresolved BLOCKER/HIGH findings;
- zero unresolved skill/path errors;
- evidence references the deployed candidate revision.

A test-environment failure MUST NOT be hot-fixed directly in the shared environment. Return to local reproduction/fix/review and re-run the complete required local gate before pushing a new candidate.

### UAT gate

Require:
- UAT agent received/read concrete paths for `gsd-verify-work` and `verification-before-completion`;
- UAT PASS;
- no skill/path resolution error.

### Feature gate

Require:
- all phases PASS;
- local integration PASS;
- local full live/E2E PASS;
- CD test deployment PASS;
- test-environment integration PASS;
- test-environment full live/E2E PASS;
- UAT PASS;
- Grill final check PASS using Main's resolved Grill Me skill;
- traceability complete for both LOCAL and TEST_ENV where applicable;
- current-state docs updated;
- zero BLOCKER/HIGH findings;
- zero unresolved `SKILL_UNAVAILABLE` / `SKILL_PATH_INVALID`.

## Conflict routes

### Scope expansion

Subagent returns `SCOPE_EXPANSION_REQUIRED` with evidence. Main chooses to reject it, extend the plan, add a new plan, change a phase, or revise requirements.

### Requirement conflict

Set `REQUIREMENT_CONFLICT`. Do not code around it. Main resolves intent, updates specs/decisions, then resumes planning.

### Architecture decision

Set `ARCHITECTURE_DECISION_REQUIRED`. Code agent must not silently introduce major architecture changes. Main owns the decision and records it.

### Skill unavailable

Set `SKILL_UNAVAILABLE` for the affected assignment. Main locates/maps/installs the expected skill or marks the workflow BLOCKED. Do not ask the child to improvise.

### Skill path invalid

Set `SKILL_PATH_INVALID` for the affected assignment. Main re-runs skill resolution, verifies the corrected `SKILL.md`, rebuilds the child prompt with the corrected path, then retries the bounded assignment.

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
