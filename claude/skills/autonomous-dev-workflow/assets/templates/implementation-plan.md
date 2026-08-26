# <Plan ID> - <Plan Name>

## Metadata

- Phase: <phase>
- Requirement IDs: <REQ-...>
- Dependencies: <plan IDs or none>
- Agent role: implementation_agent
- Model tier: STANDARD

## Required Skills

```yaml
required_skills:
  - test-driven-development
conditional_skills:
  on_debug:
    - systematic-debugging
  on_review_fix:
    - receiving-code-review
```

## Objective

<one coherent result>

## Why

<requirement/design reason>

## Context to Read

- <specific doc sections>

## Relevant Existing Files

- `<path>` - <why>

## Files Expected to Change

- `<path>` - <expected change>

## Files Expected to Be Created

- `<path>` - <purpose>

## Interfaces / Contracts

<signatures, DTOs, schemas, events, invariants>

## Detailed Implementation Steps

1. <small deterministic step>
2. <step>
3. <step>

## Testing Requirements

- <failing test first where applicable>
- <positive case>
- <negative/boundary/regression cases>

## Acceptance Criteria

- [ ] <observable outcome>
- [ ] <observable outcome>

## Verification Commands

```bash
<command>
```

## Engineering Standards to Load

- `<standard path>`

## Things NOT to Change

- <scope boundary>

## Expected Agent Output

- status
- skills_used
- files changed
- tests added/changed
- commands and results
- deviations
- risks
- uncertainties
- missing_skills if any
