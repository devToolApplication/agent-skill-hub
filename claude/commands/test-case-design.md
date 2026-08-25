# Test Case Design

Viết test cases logic + UI/UX theo requirement.

## Khi nào dùng
- Tạo test cases từ AC
- Chuẩn bị QA checklist
- Review coverage

## Test Case Template
```md
## TC-ID: Title
Precondition:
Steps:
Expected result:
Test data:
Priority:
Type: Positive/Negative/Boundary
```

## Categories
- Happy path
- Negative path
- Boundary values
- Permission/auth
- Empty/loading/error states
- Integration failure
- Regression

## Checklist
- [ ] AC mapped to test cases
- [ ] Negative cases included
- [ ] Boundary cases included
- [ ] Test data specified
