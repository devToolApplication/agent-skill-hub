# Architect Skill Workflow

```text
READ_REQUIREMENTS -> CURRENT_SYSTEM -> OPTIONS -> DESIGN -> CONTRACTS -> RISK -> ADR -> SELF_REVIEW -> HANDOFF
```

## READ_REQUIREMENTS / CURRENT_SYSTEM
Skill: `system-architecture`; inspect existing ownership, libraries and contracts.

## OPTIONS
Skills: `system-architecture`; conditional `microservice-design`, `integration-patterns`.
Document meaningful alternatives and why rejected.

## DESIGN / CONTRACTS
Conditional skills: `api-contract-design`, `event-driven-architecture`, `data-architecture`, `security-architecture`, `observability-design`, `scalability-design`.
PASS when downstream implementation can proceed without inventing major contracts.

## RISK
Skill: `technical-risk-assessment`; include compatibility, migration and rollback.

## ADR
Skill: `architecture-decision-record` for material decisions; `migration-planning` when migration exists.

## SELF_REVIEW
Check overengineering, ownership, compatibility, failure modes, observability, security, migration and rollback. FAIL routes to DESIGN/CONTRACTS.

## HANDOFF
Return ADR/design refs, stable contracts, ownership boundaries and implementation constraints.
