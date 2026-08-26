# <Feature Name>

```yaml
feature_id: <FEATURE-ID>
feature_name: <Feature Name>
status: DRAFT
current_phase: null
current_plan: null

requirements:
  user_spec: docs/01-product/features/<feature>/user-spec.md
  ai_spec: docs/02-ai-spec/features/<feature>/ai-spec.md
  status: DRAFT

design:
  status: PENDING

phases: {}

local_validation:
  integration: PENDING
  live_e2e: PENDING
  regression: PENDING
  gate: PENDING
  validated_revision: null

cd_test:
  candidate_revision: null
  push_status: PENDING
  deploy_status: PENDING
  deployed_revision: null

test_environment_validation:
  integration: PENDING
  live_e2e: PENDING
  regression: PENDING
  gate: PENDING

uat:
  status: PENDING

final_audit:
  status: PENDING
```

## Links

- Rough plan: `00-discovery/rough-plan.md`
- Grill Me: `00-discovery/grill-me.md`
- Technical design: `01-design/technical-design.md`
- Decisions: `01-design/decisions.md`
- Traceability: `traceability.md`
- Live/E2E evidence: `04-testing/live-test.md`

## Validation rule

`cd_test` MUST remain `PENDING` until `local_validation.gate = PASS`.

Any code change after a local PASS invalidates the local gate and requires local re-validation before the next push/CD deployment.

## Current blockers

None.
