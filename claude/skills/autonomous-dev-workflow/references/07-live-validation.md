# Local-First Integration, Live/E2E, CD Test, and UAT

## Non-negotiable validation order

All feature-level integration and live/E2E validation MUST pass on the local machine before the candidate revision is pushed for CD deployment to the shared test environment.

```text
ALL PHASES PASS
→ LOCAL INTEGRATION VERIFY
→ LOCAL FULL LIVE/E2E
→ LOCAL GATE PASS
→ COMMIT/PUSH CANDIDATE
→ CD DEPLOY TO TEST ENV
→ VERIFY DEPLOYED REVISION
→ TEST-ENV INTEGRATION VERIFY
→ TEST-ENV FULL LIVE/E2E
→ UAT
→ FINAL AUDIT
```

There is no normal path from implementation directly to CD/test-environment validation.

## Skill-aware validation agents

All validation assignments MUST resolve role-specific skills from `09-skill-routing.md` before spawn.

### Local integration verifier

```yaml
role: local_integration_verifier
model_tier: CHEAP | STANDARD
required_skills:
  - verification-before-completion
```

### Local live/E2E agent

```yaml
role: local_live_test_agent
model_tier: CHEAP
required_skills:
  - verification-before-completion
```

For browser/UI scenarios, Main MUST add the installed browser/Playwright skill explicitly to `required_skills`.

### Test-environment integration verifier

```yaml
role: test_env_integration_verifier
model_tier: CHEAP | STANDARD
required_skills:
  - verification-before-completion
```

### Test-environment live/E2E agent

```yaml
role: test_env_live_test_agent
model_tier: CHEAP
required_skills:
  - verification-before-completion
```

For browser/UI scenarios, Main MUST add the installed browser/Playwright skill explicitly.

### UAT agent

```yaml
role: uat_agent
model_tier: CHEAP
required_skills:
  - gsd-verify-work
  - verification-before-completion
```

## Stage A — Local integration verification

After all phases pass, verify feature-wide wiring on the local stack:

- cross-module/service API and event contracts;
- persistence and migrations;
- local configuration;
- startup behavior;
- serialization/deserialization;
- dependency injection/wiring;
- backward compatibility;
- authentication/authorization boundaries where applicable;
- local containers/emulators/sandboxes required by the feature.

Prefer a production-like local stack using real local processes/containers rather than mocks for feature-level validation.

Maintain integration artifacts in `03-integration/`.

## Stage B — Local full live/E2E

Every mandatory live/E2E scenario MUST be executed locally before push/CD.

Main should spawn specialized CHEAP agents, preferably in parallel when scenarios are independent:

- API Live Test Agent;
- Browser/E2E Agent;
- Workflow Scenario Agent;
- Data Validation Agent;
- External Integration Agent using an approved local/sandbox equivalent.

Local live validation should exercise:

- real application processes;
- real local HTTP/network paths;
- real routing and serialization;
- real local database/persistence;
- real browser automation for UI;
- real workflow execution;
- local containers or controlled sandboxes for infrastructure dependencies.

Mocks may support unit/component tests but MUST NOT replace the local feature-level live/E2E gate.

## Local gate

The candidate MUST NOT be pushed/deployed to the CD test environment until all are true:

- local integration verification PASS;
- every mandatory local live/E2E scenario PASS;
- relevant regression scenarios PASS;
- all mandatory validation agents report required `skills_used`;
- zero unresolved BLOCKER/HIGH findings;
- evidence is recorded;
- no code changes were made after successful local validation without re-running affected/full local validation.

If code changes after local PASS, invalidate the local gate and run it again before push.

## Candidate revision identity

After local gate passes:

1. finalize candidate commit;
2. record candidate commit SHA/version;
3. push that candidate;
4. allow CD to deploy that exact candidate.

Test-environment validation MUST verify deployed revision/version matches the candidate that passed local gate.

## Stage C — CD deploy to test environment

Only after LOCAL GATE PASS may the workflow push/deploy through CD.

CD/deployment must complete successfully before test-environment live validation begins.

If deployment fails, mark CD stage failed/blocked.

## Stage D — Test-environment verification

After successful CD deployment, rerun mandatory feature-level verification against shared test environment.

This is not only a smoke test. Re-run required integration and live/E2E scenarios to catch:

- environment configuration;
- secrets/credentials wiring;
- ingress/routing;
- service discovery;
- shared database behavior;
- deployed migrations;
- authentication/authorization integration;
- network policies;
- external integrations;
- browser behavior against deployed frontend;
- runtime/container/Kubernetes differences where applicable.

Recommended sequence:

```text
VERIFY DEPLOYED SHA/VERSION
→ TEST-ENV INTEGRATION
→ API LIVE
→ WORKFLOW LIVE
→ DATA VALIDATION
→ BROWSER/E2E
→ REQUIRED REGRESSION SUITE
```

Independent scenarios SHOULD run in parallel using Main's `dispatching-parallel-agents` capability when they do not mutate conflicting shared state.

## Scenario origin

Local and test-environment scenarios MUST originate from User Spec, AI Spec, and acceptance criteria.

Reuse the same canonical scenario IDs in both environments when possible.

## Evidence contract

```yaml
scenario: E2E-FEATURE-001
requirements:
  - REQ-001
environment: LOCAL | TEST_ENV
candidate_revision: <commit-sha-or-version>
status: PASS | FAIL | BLOCKED | SKILL_UNAVAILABLE
skills_used:
  - verification-before-completion
steps: []
expected: []
actual: []
evidence:
  - command/log/screenshot/API result reference
missing_skills: []
```

## Failure handling — local

```text
LOCAL FAILURE
→ PREMIUM main classification
→ CHEAP/STANDARD debug/research
→ if root cause unclear: STANDARD debugger + systematic-debugging
→ fix plan
→ STANDARD implementation agent + test-driven-development
→ if review findings involved: receiving-code-review
→ task reviews
→ local integration recheck
→ rerun local live/E2E
→ LOCAL GATE again
```

No CD push occurs while local gate is failing.

## Failure handling — test environment

```text
TEST-ENV FAILURE
→ capture deployed revision + evidence
→ PREMIUM main classification
→ reproduce/investigate locally
→ debugger uses systematic-debugging when needed
→ fix locally with test-driven-development
→ task reviews
→ FULL REQUIRED LOCAL GATE PASS
→ create/push new candidate revision
→ CD deploy new candidate
→ rerun test-env integration/live/E2E
```

Do NOT patch shared test environment manually to bypass local-first workflow.

Every code fix discovered in test environment MUST return through local validation before it is pushed again.

## UAT

UAT begins only after:

```text
LOCAL FULL LIVE/E2E = PASS
TEST-ENV FULL LIVE/E2E = PASS
```

Then spawn UAT using `gsd-verify-work` + `verification-before-completion`.

Any UAT gap returns to planning/implementation gates and must subsequently pass local-first validation again before CD/test-env retest.

Finally Main runs `grill-me check` against original intent before final DONE.
