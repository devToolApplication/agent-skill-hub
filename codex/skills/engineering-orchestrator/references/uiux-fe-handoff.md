# UI/UX -> Frontend Handoff v1

UI/UX produces `uiux-spec-v1`. Frontend implementation consumes it.

## UIUX spec MUST contain

- screen/flow identity;
- user goal and important constraints;
- information hierarchy;
- interaction behavior;
- responsive transformations;
- loading/empty/error/success states;
- accessibility behavior;
- theme/design semantic requirements;
- content/localization requirements;
- acceptance requirements with stable IDs.

## UIUX spec MUST NOT contain implementation choices

Do not put these in UIUX spec unless the user explicitly mandated them:

```text
React/Vue component filenames
hooks
state libraries
query libraries
ThemeProvider implementation
i18n library
translation key naming
CSS framework/classes
folder placement
DTO mapper implementation
API client calls
breakpoint mechanism
```

## FE mapping responsibility

The parent loads the FE architecture skill, inspects the repository, then maps each UIUX requirement ID into exact FE TaskSpec changes.

Example:

```text
UX-RSP-02: On mobile use a compact structured list.

Parent FE decision:
- reuse existing users query;
- create features/users/components/UserMobileList.tsx;
- keep UserTable for desktop;
- use existing breakpoint hook;
- no second API/query path.
```

The weak FE worker receives the parent decision, not the raw design ambiguity.
