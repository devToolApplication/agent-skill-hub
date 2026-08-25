# Technical Risk Assessment

Phân tích risk, trade-off, migration risk, dependency risk.

## Khi nào dùng
- Trước khi implement change lớn
- Review architecture/design
- Planning migration/refactor
- Production-impacting decisions

## Risk Categories
- Functional risk
- Data loss/corruption risk
- Security/privacy risk
- Performance/scalability risk
- Operational/deployment risk
- Compatibility/regression risk
- Dependency/vendor risk

## Output
| Risk | Impact | Likelihood | Mitigation | Owner |
|---|---|---|---|---|

## Checklist
- [ ] Worst-case failure mode identified
- [ ] Rollback path exists
- [ ] Data migration reversible/validated
- [ ] Observability added for new risk
- [ ] Feature flag/staged rollout considered
