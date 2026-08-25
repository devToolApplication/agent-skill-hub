---
name: ui-ux-design
description: Parent-side UI/UX specification and judgment skill. Owns user-facing behavior, information hierarchy, responsive transformation, accessibility behavior, theme semantics, and content semantics. Does not own frontend code architecture or code edits.
metadata:
  version: "3.0.0"
---

# UI/UX Design v3

UI/UX is the **specification owner**, not a frontend implementation owner.

## Owns

- user goal and task flow;
- information hierarchy;
- table/list/card/detail choice;
- drawer/dialog/page/tabs/stepper behavior;
- form grouping/order/presentation;
- action hierarchy;
- loading/empty/error/success behavior;
- responsive transformation;
- keyboard/focus/accessibility behavior expectations;
- theme visual semantics and semantic-token needs;
- copy meaning, labels/message intent, localization requirements;
- final UX judgment against the approved spec.

## Does NOT own

- React/Vue/Angular component filenames/folders;
- hooks, stores, query/cache implementation;
- API client/DTO mapping;
- routing implementation;
- i18n library, key namespace, resource loading;
- ThemeProvider/CSS variables/persistence/hydration implementation;
- CSS framework or class implementation;
- frontend test architecture.

Those belong to `frontend-modular-architecture` and FE workers.

## Weak UIUX workers

Use only for bounded facts:

```text
uiux_context_inspect        current screen/flow/state inventory
uiux_design_system_inspect  existing tokens/primitives/pattern inventory
uiux_spec_verify            compare implementation evidence to approved spec
```

They do not make broad design decisions and never edit application code.

## Required output for implementation work

The strong parent creates `uiux-spec-v1` using `references/uiux-spec-v1.md`.

Every requirement has a stable ID so FE TaskSpecs can map code changes back to design requirements.

## Theme split

UIUX owns semantic intent:

```text
surface-primary
text-secondary
action-destructive
focus-visible
status-warning
```

FE owns how those semantics are wired into the project's theme/provider/token system.

## Translation split

UIUX owns message meaning/tone and what must be localizable. FE owns translation keys, namespaces, libraries, pluralization/interpolation implementation, locale loading, and locale-sensitive formatting.

## Responsive split

UIUX owns the transformation (e.g. desktop table -> mobile structured list). FE owns the breakpoint/container-query/component implementation.

Read relevant files under `references/rules/`, plus `references/uiux-spec-v1.md` and `references/ownership-boundary.md`.
