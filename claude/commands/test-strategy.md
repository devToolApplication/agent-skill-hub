# Test Strategy

Lập strategy: unit, integration, e2e, manual, regression.

## Khi nào dùng
- Feature mới cần test plan
- Release/regression planning
- Risk-based testing

## Test Pyramid
- Unit: business logic, validation, pure functions
- Integration: DB, service calls, Kafka, auth
- E2E: critical user flows only
- Manual exploratory: UX, edge cases, visual

## Output
- Scope under test
- Risk areas
- Test levels
- Test environments
- Entry/exit criteria
- Regression scope

## Checklist
- [ ] Critical flows covered
- [ ] High-risk areas prioritized
- [ ] Test data plan exists
- [ ] Automation vs manual split clear
- [ ] Exit criteria defined
