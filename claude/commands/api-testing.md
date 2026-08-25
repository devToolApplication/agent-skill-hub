# API Testing

Test REST API: status, schema, validation, auth, error cases.

## Khi nào dùng
- Backend endpoint mới/sửa
- API contract validation
- Integration regression

## Coverage
- Status codes
- Response schema
- Validation errors
- Auth/permission
- Not found/conflict
- Idempotency
- Pagination/filter/sort

## Test Case Matrix
| Case | Request | Expected status | Expected body |
|---|---|---|---|

## Checklist
- [ ] Happy path
- [ ] Invalid input
- [ ] Missing auth
- [ ] Forbidden role
- [ ] Not found
- [ ] Conflict/duplicate
- [ ] Schema matches contract
