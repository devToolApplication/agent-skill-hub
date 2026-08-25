---
name: fe-source-inspect
description: Read-only frontend behavior extractor. Reports exact component/data/state/query/i18n/theme/responsive/accessibility behavior and side effects without redesigning it.
metadata:
  version: "8.0.0"
---

# fe-source-inspect

Extract only requested facts such as:

- props/inputs/outputs;
- state declarations, readers, writers, derivations;
- query/cache/mutation ownership and invalidation;
- API/DTO mapping path;
- async effects/cancellation/state writes;
- translation calls, hard-coded visible strings, locale formatting;
- theme source, token usage, raw colors, persistence;
- responsive branches/data duplication;
- semantic controls, accessible names, labels/errors, focus/keyboard behavior;
- relevant test coverage.

Do not decide whether the UX is good, choose a replacement architecture, or edit code. Return evidence/unknowns only.

Read `references/preflight.md`, `references/inspection-focus.md`, `references/self-check.md`.
