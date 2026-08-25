---
name: fe-evidence
description: Read-only frontend policy evidence collector. Finds concrete architecture, i18n, theme, async, responsive and accessibility implementation evidence without assigning final severity or inventing UX changes.
metadata:
  version: "8.0.0"
---

# fe-evidence

Collect only requested rule evidence.

Common evidence classes:

```text
FE-ARCH cross-feature deep import / shared->feature dependency
FE-STATE duplicated server state / unnecessary derived state
FE-ASYNC stale write / missing invalidation / duplicate request path
FE-I18N hardcoded visible text / raw backend message / domain translation / manual pluralization / nonlocalized formatting
FE-THEME raw semantic bypass / duplicate theme state / direct persistence bypass / second theme system
FE-A11Y missing accessible name/label/error relationship / focus/keyboard regression
FE-RSP duplicated data/query paths / breakpoint convention bypass / design-contract mismatch evidence
```

Return file/line/symbol/fact. Do not assign final severity or propose architecture. Read `references/preflight.md`, `references/evidence-catalog.md`, `references/self-check.md`.
