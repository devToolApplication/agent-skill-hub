# Documentation Layout

## Canonical root

```text
docs/
├── 00-governance/
│   ├── documentation-standard.md
│   ├── naming-convention.md
│   └── templates/
├── 01-product/
│   └── features/<feature>/user-spec.md
├── 02-ai-spec/
│   └── features/<feature>/ai-spec.md
├── 03-architecture/
│   ├── system-overview.md
│   ├── service-map.md
│   ├── adr/
│   └── standards/
├── 04-services/
│   └── <service>/
├── 05-features/
│   └── <YYYYMMDD-feature-name>/
├── 06-plans/
├── 07-testing/
├── 08-operations/
└── 99-archive/
```

## Ownership rule

- `01-product`: human/business WHAT.
- `02-ai-spec`: precise, machine-verifiable WHAT.
- `03-architecture`: cross-project architecture, ADRs, engineering/review rules.
- `04-services`: CURRENT system state for each service/submodule.
- `05-features`: temporary-to-historical change workspace for one feature.
- `06-plans`: repository/project-wide plans not owned by one feature.
- `07-testing`: reusable test infrastructure/strategy.
- `08-operations`: deployment/runbook/observability.

## Feature workspace

```text
docs/05-features/<feature>/
├── README.md
├── traceability.md
├── 00-discovery/
│   ├── rough-plan.md
│   ├── grill-me.md
│   └── open-questions.md
├── 01-design/
│   ├── technical-design.md
│   ├── architecture-impact.md
│   ├── data-flow.md
│   └── decisions.md
├── 02-phases/
│   └── phase-NN-name/
│       ├── README.md
│       ├── phase-spec.md
│       ├── implementation/
│       ├── reviews/
│       ├── gaps/
│       └── verification.md
├── 03-integration/
│   ├── service-impact.md
│   ├── api-contracts.md
│   ├── event-contracts.md
│   └── migration.md
├── 04-testing/
│   ├── test-strategy.md
│   ├── integration-scenarios.md
│   ├── e2e-scenarios.md
│   ├── live-test.md
│   └── results/
└── 05-release/
    ├── rollout.md
    ├── rollback.md
    └── completion-report.md
```

## Feature README

Feature `README.md` is the orchestrator entry point and state index. Keep a concise machine-readable state section and links to canonical specs/design/phase artifacts. Use `assets/templates/feature-readme.md`.

## Traceability

Every meaningful requirement ID must eventually map to phase, implementation plan, tests, review outcome, live scenario where applicable, and final status. Use `assets/templates/traceability.md`.

## GSD native artifacts

Do not force GSD to abandon its native `.planning/` structure. Let GSD operate normally, then index or copy the approved implementation intent into the feature workspace when needed for long-term traceability.

Treat:

```text
.planning/ = execution-engine state

docs/05-features/ = project-visible feature record
```

Avoid duplicating every transient GSD artifact.

## End-of-feature sync

After final acceptance, update affected `docs/04-services/<service>/` files and any required ADRs. The feature workspace remains the history of the change, but service docs become the source of truth for current architecture.
