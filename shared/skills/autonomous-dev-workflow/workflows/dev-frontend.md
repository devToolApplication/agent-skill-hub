# Frontend Developer Skill Workflow

```text
PREPARE -> IMPLEMENT(TDD) -> SELF_TEST -> SELF_UI_CODE_REVIEW -> FINAL_VERIFY -> HANDOFF
```

## PREPARE
Load assignment, contracts/mocks, approved UX/design-system guidance, `roles/dev-frontend.md`, project FE/theme/i18n rules and inspect shared components/utilities.

## IMPLEMENT
Skills: `test-driven-development`; conditional design/layout skills such as `dev-fe-design-skills`, `design-tokens`, `responsive-layout` only when needed.
Implement against locked API contracts/mocks so FE can proceed in parallel with BE.

## SELF_TEST
Skill: `verification-before-completion`.
Run affected unit/component tests, build/type checks/lint and available UI checks.
On failure use `systematic-debugging`, then repeat.

## SELF_UI_CODE_REVIEW
Skill: `self-code-review` plus role checklist.
Check shared reuse, translation, semantic theme tokens/light-dark, loading/empty/error, form states, responsive layout, keyboard/a11y, lifecycle/subscriptions and contract error handling.
Any code change -> SELF_TEST -> SELF_UI_CODE_REVIEW again.

## FINAL_VERIFY
Build/tests/current evidence PASS and no unresolved high-severity issue.

## HANDOFF / REVIEW REPAIR
Return task result evidence. Independent code/UIUX/a11y reviewers may run in parallel. Feedback routes through `receiving-code-review` then full self-gate again.
