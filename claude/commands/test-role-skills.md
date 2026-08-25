# Test Role — Skills Reference

Bản đồ chọn skills phụ khi `test-role` đang active.

## Khi nào invoke skill nào

| Tình huống | Invoke skill |
|---|---|
| Lập test plan/strategy | `/test-strategy` |
| Viết test case chi tiết | `/test-case-design` |
| E2E web automation | `/playwright-e2e-testing` |
| Test REST API | `/api-testing` |
| Test liên service/Kafka/DB | `/integration-testing` |
| Regression sau fix/refactor | `/regression-testing` |
| Test UI/UX/responsive/states | `/ui-ux-testing` |
| Test WCAG/keyboard/contrast | `/accessibility-testing` |
| Test performance/API latency/CWV | `/performance-testing` |
| Test auth/permission/token/input abuse | `/security-testing` |
| Viết bug report chuẩn | `/bug-report-writing` |
| Chuẩn bị fixtures/seed/reset data | `/test-data-management` |

## Workflow khi Test Role active

1. Đọc BA/Dev output và AC.
2. Xác định test scope + risk.
3. Invoke 1-4 skills phụ theo loại test.
4. Output gồm: Test Scope, Test Cases, Execution Result/Expected, Bugs, Next Role.

## Quick decision tree

```
Test task?
├── Need plan → /test-strategy
├── Need cases → /test-case-design
├── FE e2e → /playwright-e2e-testing
├── API → /api-testing
├── Multi-service → /integration-testing
├── UI/UX → /ui-ux-testing + /accessibility-testing
├── Performance → /performance-testing
├── Security/auth → /security-testing
├── Regression → /regression-testing
├── Test data → /test-data-management
└── Found bug → /bug-report-writing
```
