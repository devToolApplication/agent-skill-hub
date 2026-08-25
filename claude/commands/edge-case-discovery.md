# Edge Case Discovery

Tìm edge cases, exception flows, data boundary cases.

## Khi nào dùng
- Trước khi hoàn thiện AC/test cases
- Feature có validation/business rules
- Integration hoặc async flow

## Categories
- Empty/null/missing data
- Boundary values
- Duplicate actions
- Permission changes mid-flow
- Network/service failure
- Timeout/retry
- Race conditions
- Large data volume
- Invalid state transitions
- Timezone/date edge cases

## Output
| Case | Condition | Expected behavior | Severity |
|---|---|---|---|

## Checklist
- [ ] Empty state
- [ ] Validation failures
- [ ] Auth/permission
- [ ] Integration failure
- [ ] Concurrent actions
- [ ] Data boundary
