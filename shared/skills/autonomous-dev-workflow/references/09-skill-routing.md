# 09 - Skill Routing

This file resolves the previously implicit role-to-skill contract. Main MUST resolve the selected agent through `config/agent-registry.yaml`, then use `config/skill-routing.yaml` and that role's workflow.

## Resolution algorithm

1. Select the dedicated `agent` from task capability/ownership.
2. Load its `rules` and `workflow` paths from `config/agent-registry.yaml`.
3. Load step skills from `config/skill-routing.yaml`.
4. Resolve each required skill to an installed skill directory/`SKILL.md` before spawn when the runtime supports path resolution.
5. Add conditional skills only when their trigger is true.
6. Put the resolved role rules/workflow/skills into the child assignment.
7. Never add model/provider/model-tier selection to the assignment.

## Role matrix

| Agent | Rules | Workflow | Core gate |
|---|---|---|---|
| `ba-agent` | `roles/ba.md` | `workflows/ba.md` | requirements self-review |
| `architect-agent` | `roles/architect.md` | `workflows/architect.md` | architecture self-review |
| `dev-be-agent` | `roles/dev-backend.md` | `workflows/dev-backend.md` | self-test + self-code-review |
| `dev-fe-agent` | `roles/dev-frontend.md` | `workflows/dev-frontend.md` | self-test + self-code/UI review |
| `test-qa-agent` | `roles/qa.md` | `workflows/qa.md` | coverage self-review |
| `bpmn-agent` | `roles/bpmn.md` | `workflows/bpmn.md` | BPMN validation |
| `trade-analysis-agent` | `roles/trade-analysis.md` | `workflows/trade-analysis.md` | anti-lookahead/risk review |
| reviewer | `roles/reviewer.md` | `workflows/reviewer.md` | finding self-check |

## Conditional skill examples

- Backend API change -> `api-contract-design` plus project API rules/reviewer.
- Backend integration/message change -> `integration-patterns`; add event/API reviewer as relevant.
- Frontend visual/layout change -> `dev-fe-design-skills`, `design-tokens`, `responsive-layout` as needed.
- QA browser/E2E -> `playwright-e2e-testing`.
- QA API/integration -> `api-testing`, `integration-testing`.
- Architecture event/data/security change -> corresponding event/data/security architecture skill.

Missing required skill/path is `SKILL_UNAVAILABLE`/`SKILL_PATH_INVALID`, never PASS. Main may route to an approved equivalent only if the workflow explicitly permits substitution.
