# Frontend i18n / Localization Engineering

## Ownership

UIUX/product defines message meaning and localization requirements. FE owns translation mechanics.

## Rules

- Reuse the project's existing i18n mechanism; do not add a second library without explicit authorization.
- Do not introduce hard-coded user-facing strings when the application uses i18n.
- User-facing labels, buttons, placeholders, validation messages, loading/empty/error text, tooltips, and accessible names should use translation resources where applicable.
- Keep translation at the presentation/application boundary. Domain/model logic should return semantic codes/values, not call `t()` or equivalent.
- Prefer stable backend/application error codes mapped to local translation keys; do not make raw backend prose the UI contract.
- Use interpolation and pluralization facilities; do not concatenate translated sentence fragments.
- Use locale-aware date/number/currency formatting through the established abstraction or `Intl` APIs.
- Reuse current namespaces/resource ownership conventions. Keep feature-specific keys feature-scoped; do not dump domain-specific copy into generic `common` without reason.
- Locale switching/loading/persistence must have one source of truth consistent with the project architecture.

## Evidence examples

```text
hard-coded visible text in an i18n-enabled feature
raw backend error message rendered directly
translation call inside domain/model calculation
manual pluralization
non-localized date/currency formatting
duplicate i18n initialization
```
