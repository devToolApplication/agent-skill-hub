# Local-First Integration, Live/E2E, CD Test, and UAT

## Non-negotiable validation order

All feature-level integration and live/E2E validation MUST pass on the developer/local machine before the candidate revision is pushed for CD deployment to the shared test environment.

Canonical order:

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

## Stage A — Local integration verification

After all phases pass, first verify feature-wide wiring on the local stack:

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

Spawn specialized CHEAP live agents, preferably in parallel by independent scenario/domain:

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

The candidate MUST NOT be pushed/deployed to the CD test environment until all of the following are true:

- local integration verification PASS;
- every mandatory local live/E2E scenario PASS;
- relevant regression scenarios PASS;
- zero unresolved BLOCKER/HIGH findings;
- evidence is recorded;
- the candidate working tree contains no code changes made after the successful local validation without re-running the affected/full local gate.

If code changes after local PASS, invalidate the local gate and run it again before push.

## Candidate revision identity

After the local gate passes:

1. finalize the candidate commit;
2. record the candidate commit SHA/version;
3. push that candidate;
4. allow CD to deploy that exact candidate to the test environment.

Test-environment validation MUST verify the deployed revision/version matches the candidate that passed the local gate.

## Stage C — CD deploy to test environment

Only after LOCAL GATE PASS may the workflow push/deploy through CD.

CD/deployment must complete successfully before test-environment live validation begins.

If deployment fails, mark the CD stage failed/blocked. Do not treat a deployment failure as an application live-test PASS.

## Stage D — Test-environment verification

After successful CD deployment, rerun the mandatory feature-level verification against the shared test environment.

This is not only a smoke test. Re-run the required integration and live/E2E scenarios to catch environment-specific differences such as:

- environment configuration;
- secrets/credentials wiring;
- ingress/routing;
- service discovery;
- shared database behavior;
- real deployed migrations;
- authentication/authorization integration;
- network policies;
- external integrations;
- browser behavior against the deployed frontend;
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

Independent scenarios SHOULD run in parallel when they do not mutate conflicting shared state.

## Scenario origin

Local and test-environment scenarios MUST originate from User Spec, AI Spec, and acceptance criteria.

The same canonical scenario IDs SHOULD be reused in both environments so evidence is directly comparable.

Example:

```text
E2E-FEATURE-001
  local: PASS
  test-env: PASS
```

## Evidence contract

Each environment/scenario records:

```yaml
scenario: E2E-FEATURE-001
requirements:
  - REQ-001
environment: LOCAL | TEST_ENV
candidate_revision: <commit-sha-or-version>
status: PASS | FAIL | BLOCKED
steps: []
expected: []
actual: []
evidence:
  - command/log/screenshot/API result reference
```

## Failure handling — local

A local live agent captures evidence and stops. It does not patch production code.

```text
LOCAL FAILURE
→ PREMIUM main classification
→ CHEAP/STANDARD debug/research
→ fix plan
→ STANDARD code agent
→ task reviews
→ local integration recheck
→ rerun local live/E2E
→ LOCAL GATE again
```

No CD push occurs while the local gate is failing.

## Failure handling — test environment

If a scenario fails after CD deployment:

```text
TEST-ENV FAILURE
→ capture deployed revision + evidence
→ PREMIUM main classification
→ reproduce/investigate locally
→ fix locally
→ task reviews
→ FULL REQUIRED LOCAL GATE PASS
→ create/push new candidate revision
→ CD deploy new candidate
→ rerun test-env integration/live/E2E
```

Do NOT patch the shared test environment manually to bypass the local-first workflow.

Every code fix discovered in the test environment MUST return through local validation before it is pushed again.

## UAT

UAT begins only after BOTH gates pass:

```text
LOCAL FULL LIVE/E2E = PASS
TEST-ENV FULL LIVE/E2E = PASS
```

Then run the existing GSD acceptance-oriented `verify-work` capability. Any gap returns to normal planning/implementation gates and must subsequently pass local-first validation again before CD/test-environment retest.

Finally run `grill-me check` against original intent before final DONE.
