# Integration, Live/E2E, and UAT

## Integration verification

After all phases pass, verify feature-wide wiring:
- cross-service API/event contracts;
- persistence and migrations;
- configuration;
- startup behavior;
- serialization/deserialization;
- dependency injection/wiring;
- backward compatibility;
- authentication/authorization boundaries where applicable.

Maintain integration artifacts in `03-integration/`.

## Scenario origin

Live/E2E scenarios must originate from User Spec, AI Spec, and acceptance criteria. Do not wait until coding ends to invent only happy-path scenarios.

## Live agent behavior

Prefer production-like behavior in an appropriate test environment:
- real application process;
- real HTTP;
- real routing/serialization;
- real test DB/persistence;
- real browser automation for UI;
- real workflow execution;
- controlled external integration sandbox when available.

Mocks are acceptable for lower-level tests but do not substitute for feature-level live acceptance.

## Default roles

- API Live Test Agent — CHEAP
- Browser/E2E Agent — CHEAP
- Workflow Scenario Agent — CHEAP
- Data Validation Agent — CHEAP
- External Integration Agent — CHEAP initially

Escalate uncertain diagnosis to STANDARD/PREMIUM according to model routing.

## Evidence contract

Each scenario records:

```yaml
scenario: E2E-FEATURE-001
requirements:
  - REQ-001
status: PASS | FAIL | BLOCKED
steps: []
expected: []
actual: []
evidence:
  - command/log/screenshot/API result reference
```

## Live failure

Live agent captures evidence and stops. It does not patch production code.

Route:

```text
live failure
→ main classification
→ debug/research if needed
→ fix plan
→ code agent
→ task reviews
→ integration recheck if affected
→ rerun failed scenario
→ rerun relevant regressions
```

## UAT

After automated live/E2E passes, run the existing GSD acceptance-oriented `verify-work` capability. Any gap returns to normal planning/implementation gates.

Then run `grill-me check` against original intent before final DONE.
