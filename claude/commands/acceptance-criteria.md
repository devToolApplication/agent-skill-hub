# Acceptance Criteria

Given/When/Then, business rules, validation cases.

## Khi nào dùng
- Viết AC cho Story
- Làm rõ expected behavior
- Chuẩn bị input cho Test role

## Format
```gherkin
Scenario: [short name]
Given [initial context]
When [action]
Then [expected outcome]
And [additional assertion]
```

## AC Types
- Happy path
- Validation errors
- Permission/auth errors
- Empty states
- Boundary values
- Concurrency/duplicate actions
- Integration failures

## Rules
- Testable, observable outcome
- Không viết implementation detail
- Cover negative cases
- Include data conditions

## Checklist
- [ ] Happy path covered
- [ ] Error paths covered
- [ ] Permissions covered
- [ ] Boundary data covered
- [ ] UI states covered if applicable
