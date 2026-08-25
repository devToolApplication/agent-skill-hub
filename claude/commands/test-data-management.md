# Test Data Management

Chuẩn bị test data, fixtures, seed/reset strategy.

## Khi nào dùng
- Test cần data setup phức tạp
- E2E/integration test cần repeatability
- Regression suite cần stable fixtures

## Principles
- Deterministic data
- Isolated per test run
- Easy cleanup/reset
- Avoid using production data
- Mask/anonymize sensitive data

## Output
- Required entities
- Fixture data
- Setup method
- Cleanup method
- Data ownership
- Edge/boundary data set

## Checklist
- [ ] Test data deterministic
- [ ] Cleanup/reset defined
- [ ] No sensitive real data
- [ ] Boundary values included
- [ ] Roles/permissions data included
- [ ] Reusable fixtures documented
