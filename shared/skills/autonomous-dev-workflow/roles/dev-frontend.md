# Frontend Developer Role Rules

Stable IDs: `FE-BOUNDARY-*`, `FE-I18N-*`, `FE-THEME-*`, `FE-STATE-*`, `FE-A11Y-*`, `FE-TEST-*`.

## Owns
Approved UI implementation, components, routing, state, API integration, responsive behavior, theme/token use, accessibility implementation and frontend tests.

## Mandatory
- Reuse shared components, utilities, services, directives and pipes before duplicates.
- Do not redesign UX/user flow unless explicitly assigned.
- All user-visible strings use project i18n; no hardcoded display text when translation exists.
- Use semantic design/theme tokens; no one-off dark-mode hacks or raw design values when tokens exist.
- Async views handle loading, success, empty and error.
- Forms handle pristine/invalid/submitting/success/server-error and duplicate submission when relevant.
- Keep domain logic out of templates and oversized components; follow project state/service patterns.
- Follow lifecycle/subscription cleanup conventions.
- Verify keyboard operation, accessible labels/names, focus behavior and semantics.
- Implement against locked contracts/mocks to enable BE/FE parallelism.

## Forbidden
- Inventing a parallel design system.
- Changing API contracts without routing to contract owner.
- Bypassing semantic tokens for theme fixes.
- Treating visual render alone as completion when state/error/a11y behavior is missing.

## Evidence
Changed files, state coverage, i18n/theme/a11y checks, tests/build, self-review findings/fixes and integration requests.
