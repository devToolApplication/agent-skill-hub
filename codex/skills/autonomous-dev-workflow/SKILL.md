---
name: autonomous-dev-workflow
description: Orchestrate end-to-end multi-agent software delivery via dedicated domain agents (BA, Architect, Dev BE, Dev FE, QA, BPMN, Trade Analyst). Main Orchestrator handles requirement intake, agent dispatch, gating, and synthesis.
---

# Autonomous Dev Workflow

## Purpose

End-to-end multi-agent lifecycle where Main Orchestrator coordinates dedicated domain agents:

```text
receive → decompose → dispatch dedicated agent → synthesize → decide → gate
```

Main does not write code, test, or review directly. Work is dispatched to dedicated agents configured with their own tools, skills, and MCP servers.

## Dedicated Domain Agents

| Agent | Scope | Key Skills |
|---|---|---|
| `ba-agent` | Requirement analysis, user stories, AC, functional specs | `requirement-analysis`, `user-story-writing`, `acceptance-criteria` |
| `architect-agent` | System design, microservices, API contracts, ADR | `system-architecture`, `microservice-design`, `api-contract-design` |
| `dev-be-agent` | Backend development (Spring Boot 3.5, Java 21, MongoDB MCP, Kafka) | `test-driven-development`, `systematic-debugging`, `integration-patterns` |
| `dev-fe-agent` | Frontend development (Angular 21, Tailwind, Design Tokens) | `dev-fe-design-skills`, `tailwind-design-system`, `responsive-layout` |
| `test-qa-agent` | QA & Testing (Playwright E2E, API testing, regression) | `test-strategy`, `test-case-design`, `playwright-e2e-testing`, `api-testing` |
| `bpmn-agent` | BPMN 2.0 process modeling & validation | `bpmn-modeler`, `bpmn-validator`, `bpmn-design` |
| `trade-analysis-agent` | Trade strategies, indicators, risk management, rule engine | `requirement-analysis`, `data-requirement-spec`, `technical-risk-assessment` |

## Workflow Stages

```text
1. DISCOVERY        → ba-agent (spec & acceptance criteria)
2. ARCHITECTURE     → architect-agent (ADR, API contracts, DB schema)
   └─ (Optional)    → bpmn-agent (if business workflow / process feature)
3. PLANNING         → gsd-planner / phase decomposition
4. IMPLEMENTATION   → dev-be-agent / dev-fe-agent (TDD execution)
5. REVIEW & QA      → test-qa-agent (E2E, API, regression) + code reviewer
6. GATE & SYNC      → Main validates evidence, syncs docs, marks DONE
```

## References

- [01-workflow.md](references/01-workflow.md) — Lifecycle states and transitions.
- [04-agent-contracts.md](references/04-agent-contracts.md) — Dedicated agent dispatch contracts.
- [05-review-gates.md](references/05-review-gates.md) — Review and quality gates.
- [06-phase-planning.md](references/06-phase-planning.md) — Phase planning rules.
- [07-live-validation.md](references/07-live-validation.md) — Local and environment verification.
- [08-rule-routing.md](references/08-rule-routing.md) — Engineering rule routing.
