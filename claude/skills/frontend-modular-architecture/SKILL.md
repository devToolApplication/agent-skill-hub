---
name: frontend-modular-architecture
description: Parent-side frontend implementation architecture skill. Owns code organization, state/query/API/i18n/theme/accessibility implementation and maps approved UIUX specs into exact FE TaskSpecs. Does not own UX/product design decisions.
metadata:
  version: "3.0.0"
  architecture: "feature-first-modular"
---

# Frontend Modular Architecture v3

Frontend is the **implementation owner** for all browser/application code.

## Owns

- feature/module ownership and public boundaries;
- component boundaries/composition;
- route implementation;
- local/server/global state placement;
- query/cache/mutation architecture;
- API clients/adapters and DTO mapping;
- async/cancellation/race handling;
- i18n architecture and locale formatting;
- theme provider/token consumption/persistence/hydration;
- responsive implementation mechanism;
- accessibility implementation (semantic HTML, ARIA, focus/keyboard wiring);
- form state/validation integration;
- frontend tests and verification.

## Does NOT own

- table vs card/list design choice;
- dialog vs drawer/page choice;
- information hierarchy;
- field order/grouping as a product decision;
- primary action hierarchy;
- responsive UX transformation;
- theme visual semantics;
- copy meaning/tone;
- accessibility experience requirement.

Those come from user/product requirements or `uiux-spec-v1`.

## UIUX contract rule

When `uiux-spec-v1` exists, treat it as the design contract. The parent maps requirement IDs into exact implementation decisions before dispatching FE workers.

FE workers must not reinterpret the design contract. If it conflicts with repository constraints or requires scope outside the TaskSpec, return BLOCKED to the parent.

## Required references

Read as relevant:

- `references/architecture.md`
- `references/conventions.md`
- `references/decomposition.md`
- `references/evidence-rules.md`
- `references/i18n-localization.md`
- `references/theme-engineering.md`
- `references/accessibility-engineering.md`
- `references/responsive-engineering.md`

## Parent workflow

1. Use FE read workers to locate current feature architecture and mechanisms.
2. If design is affected, require an approved UIUX spec first.
3. Parent decides exact FE architecture and maps requirement IDs to files/symbols.
4. Create write-task-v5 with exact files, direction, policies, acceptance, verification.
5. FE workers execute only that direction.
6. FE evidence worker scans relevant architecture/i18n/theme/a11y rules.
7. UIUX spec verifier checks user-facing requirements when a spec exists.
8. Parent judges final result.
