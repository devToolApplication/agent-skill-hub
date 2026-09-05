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

| Agent | Scope | Key Skills & Capabilities |
|---|---|---|
| `ba-agent` | Requirement analysis, user stories, AC, functional specs | `requirement-analysis`, `stakeholder-questioning`, `edge-case-discovery`, `user-story-writing`, `acceptance-criteria`, `functional-specification`, `verification-before-completion` |
| `architect-agent` | System design, microservices, API contracts, module folder architecture, ADR | `system-architecture`, `api-contract-design`, `microservice-design`, `technical-risk-assessment`, `architecture-decision-record`, `migration-planning`, `integration-patterns` |
| `dev-be-agent` | Backend development, APIs, database access, clean code, SRP | `test-driven-development`, `systematic-debugging`, `self-code-review`, `receiving-code-review`, `api-contract-design`, `integration-patterns`, `verification-before-completion` |
| `dev-fe-agent` | Frontend development, UI components, state management, styling | `test-driven-development`, `systematic-debugging`, `self-code-review`, `receiving-code-review`, `ui-ux-design`, `design-tokens`, `responsive-layout`, `verification-before-completion` |
| `test-qa-agent` | QA & Testing (Parallel test prep, Local Live Test, Pre-CD Gate, Playwright E2E) | `test-strategy`, `test-case-design`, `playwright-e2e-testing`, `api-testing`, `integration-testing`, `regression-testing`, `bug-report-writing`, `test-data-management`, `verification-before-completion` |
| `bpmn-agent` | BPMN 2.0 process modeling & validation | `bpmn-modeler`, `bpmn-design`, `bpmn-validator`, `bpmn-architect`, `bpmn-engine-mapper` |
| `trade-analysis-agent` | Trade strategies, indicators, risk management, rule engine | `requirement-analysis`, `data-requirement-spec`, `technical-risk-assessment`, `trading-strategy-analysis` |
| `reviewer` | Independent Code & Spec Reviewer | `code-review-standards`, `verification-before-completion` |

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
