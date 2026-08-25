# UIUX Spec v1

Recommended JSON shape:

```json
{
  "schema": "uiux-spec-v1",
  "spec_id": "UX-USERS-01",
  "screen_or_flow": "UserManagement",
  "goal": "Administrators can find and manage users efficiently.",
  "constraints": [],
  "requirements": [
    {
      "id": "UX-LAYOUT-01",
      "category": "information_hierarchy",
      "requirement": "Search and primary create action remain visible above results.",
      "priority": "required"
    },
    {
      "id": "UX-RSP-01",
      "category": "responsive",
      "requirement": "On narrow screens replace the multi-column table with a structured record list.",
      "priority": "required"
    },
    {
      "id": "UX-A11Y-01",
      "category": "accessibility",
      "requirement": "All row actions are keyboard accessible and have accessible names.",
      "priority": "required"
    }
  ],
  "states": ["loading", "empty", "error", "ready"],
  "theme_semantics": [],
  "content_semantics": [],
  "open_questions": []
}
```

## Prohibited implementation leakage

The spec should not choose code filenames, hooks, state/query libraries, CSS classes/framework, i18n library/key names, ThemeProvider implementation, or API adapter placement unless mandated externally.
