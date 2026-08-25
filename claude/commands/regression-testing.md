# Regression Testing

Regression checklist theo feature/module.

## Khi nào dùng
- Sau bug fix
- Trước release
- Sau refactor/migration
- Cross-service contract change

## Workflow
1. Identify impacted modules.
2. Map changed files to features.
3. Select critical flows.
4. Add historical bug scenarios.
5. Run smoke + targeted regression.

## Output
- Impacted areas
- Smoke tests
- Targeted regression cases
- Historical bug checks
- Pass/fail summary

## Checklist
- [ ] Adjacent features covered
- [ ] Historical bugs included
- [ ] Core happy paths pass
- [ ] Edge cases from fix tested
