# User Story Writing

Viết Epic/Story/Sub-task theo chuẩn để Dev/Test triển khai.

## Khi nào dùng
- Tạo Jira ticket
- Chia feature thành stories
- Convert requirement thành backlog items

## Story Template
```md
## User Story
As a [actor], I want [capability], so that [business value].

## Context
...

## Acceptance Criteria
- Given/When/Then...

## Business Rules
...

## Dependencies
...

## Out of Scope
...
```

## Splitting Rules
- Story phải deliver user-visible value
- Không split theo technical layer nếu mất business value
- Sub-task dùng cho implementation steps
- Story đủ nhỏ để test độc lập

## Checklist
- [ ] Actor rõ
- [ ] Business value rõ
- [ ] AC testable
- [ ] Dependencies listed
- [ ] Out-of-scope specified
