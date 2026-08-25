# Domain Routing v5

## Backend

Controller/service/domain/repository/database/migration/consumer/scheduler/queue/integration/logging/exception/transaction/security validation -> parent loads `backend-engineering` and dispatches only `be_*` workers.

## Frontend implementation

Browser feature/module/route/component/hook/store/query/cache/API adapter/DTO mapper/i18n/theme implementation/responsive mechanism/accessibility implementation -> parent loads `frontend-modular-architecture` and dispatches only `fe_*` workers for code work.

## UI/UX specification

User flow, visual/information hierarchy, forms/tables/navigation UX, responsive transformation, design-system semantics, accessibility behavior, theme semantics, content meaning -> parent loads `ui-ux-design`; UIUX workers are read-only discovery/verification helpers.

## Overlap rule

A UI request commonly activates both UIUX and FE:

1. UIUX determines **what** the user should experience (`uiux-spec-v1`).
2. FE determines **how** the existing frontend architecture implements it.
3. FE workers write code.
4. UIUX verifier checks implementation evidence against the design contract.
