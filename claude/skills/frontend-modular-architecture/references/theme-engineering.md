# Frontend Theme Engineering

## Ownership

UIUX defines visual semantics and required token meaning. FE owns implementation.

## Rules

- Reuse the existing theme/design-token system and provider.
- Prefer semantic tokens (`text-primary`, `surface-raised`, `action-destructive`) over raw physical colors in application components when tokens exist.
- Do not scatter `isDark ? ... : ...` branches across feature components when the theme system can resolve tokens centrally.
- Keep one source of truth for theme preference/resolved theme.
- Reuse current storage/cookie/profile abstraction for theme persistence; do not read/write storage from many components.
- Respect existing system/light/dark resolution behavior.
- In SSR/hydrated apps, preserve the established pre-paint/hydration strategy to avoid theme flash/mismatch.
- Do not add another theme library or parallel token system without explicit authorization.
- Application features consume theme semantics; they should not redefine global theme semantics locally.

## Evidence examples

```text
raw color bypassing available semantic token
feature-local duplicate dark-mode state
direct localStorage theme writes despite provider abstraction
second ThemeProvider/theme library
light/dark branch duplicated across components
SSR theme flash regression risk
```
