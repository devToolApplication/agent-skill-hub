# Architecture Reference

## Recommended project shape

Use this as a conceptual default, not a forced migration target:

```text
src/
  app/
    bootstrap/
    config/
    layouts/
    providers/
    router/

  features/
    auth/
    user/
    order/

  shared/
    ui/
    components/
    hooks-or-composables/
    utils/
    types/
    constants/
    validators/

  core/
    http/
    storage/
    auth/
    logger/
    telemetry/
    error/
    i18n/

  assets/
```

For larger multi-application repositories:

```text
repo/
  apps/
    web/
    admin/
    portal/

  packages/
    ui/
    http/
    auth/
    validation/
    utilities/
    contracts/
    config/

  tooling/
```

Extract a package only when at least one of these is true:
- multiple applications genuinely consume it,
- it has an independent lifecycle/interface,
- it is stable infrastructure with a clear boundary.

Do not create packages merely to make the repository look modular.

## Dependency rules

Allowed default flow:

```text
app -> features
app -> shared
app -> core

features -> shared
features -> core

shared -X-> features
core   -X-> features
```

Cross-feature dependencies:
- avoid when practical,
- use public APIs only,
- never deep-import internals,
- watch for cycles.

## Ownership rule

Ask: "Which business capability would cause this code to change?"

If the answer is a feature/domain, place the code there.

Examples:
- `calculateOrderTotal` -> order feature/domain
- `formatCurrency` -> shared utility
- `httpClient` -> core infrastructure
- route composition for the entire app -> app

## Locality rule

Prefer:

```text
features/order/
  api/
  components/
  hooks/
  model/
  pages/
  services/
  store/
  validators/
```

over root-wide buckets containing hundreds of unrelated feature files.

## DTO boundary

Mapping is useful when:
- backend naming differs from application naming,
- status/value encoding needs normalization,
- backend contracts are volatile,
- multiple backends feed the same application model,
- wire-specific nullability/shape should not leak into UI.

Mapping may be unnecessary when:
- contract is stable,
- shape already matches the application,
- introducing a mapper would only copy fields with no protection value.

## State decision tree

1. Only one component subtree needs it?
   -> local state/context.

2. Represents remote/server data?
   -> query/cache/server-state mechanism.

3. Multiple unrelated areas need coordinated application state?
   -> global store.

4. Can it be derived?
   -> derive instead of storing duplicate state.

## Component boundary heuristics

Consider splitting when a component has multiple independent reasons to change.

Typical extractions:
- pure visual component,
- feature hook/composable,
- domain calculation,
- API adapter,
- validation rule.

Avoid tiny abstractions that make navigation harder without improving responsibility.
