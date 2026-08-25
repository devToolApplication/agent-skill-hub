# Worker Routing v5

Choose **decision domain first**, then role.

## Backend

| Need | Worker |
|---|---|
| locate backend files/symbols/patterns | `be_repo_search` |
| inspect exact control flow/data/error/transaction behavior | `be_source_inspect` |
| apply parent-decided production change | `be_code_edit` |
| add exact backend tests | `be_test_author` |
| collect policy/review evidence | `be_evidence` |

## Frontend

| Need | Worker |
|---|---|
| locate feature/components/state/query/i18n/theme implementation | `fe_repo_search` |
| inspect exact frontend behavior/data flow | `fe_source_inspect` |
| implement parent-decided frontend change | `fe_code_edit` |
| add exact frontend tests | `fe_test_author` |
| collect FE architecture/i18n/theme/a11y evidence | `fe_evidence` |

## UI/UX (read-only)

| Need | Worker |
|---|---|
| inventory current screen/flow/fields/actions/states | `uiux_context_inspect` |
| inventory design tokens/primitives/patterns | `uiux_design_system_inspect` |
| compare implementation evidence against uiux-spec-v1 | `uiux_spec_verify` |

## Shared

Use `command_runner` only for exact commands chosen by the parent.

## Critical separation

Never ask a UIUX worker to modify React/Vue/Angular/CSS code.
Never ask an FE worker to invent interaction design.
Never ask a BE worker to decide frontend behavior.

A design change to `.tsx` is still implemented by FE after UIUX specification is approved.
