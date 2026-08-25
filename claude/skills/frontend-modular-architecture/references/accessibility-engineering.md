# Frontend Accessibility Engineering

UIUX defines accessibility behavior; FE implements it.

- Prefer semantic HTML/control primitives before ARIA patches.
- Preserve accessible names for icon-only actions.
- Associate form labels, descriptions, and errors programmatically.
- Implement keyboard access and focus behavior required by the UIUX spec using existing accessible primitives where possible.
- Do not remove focus visibility for visual convenience.
- Do not rely on color alone for required status/error meaning.
- Preserve reading/DOM order compatible with required interaction.
- Reuse accessible dialog/menu/listbox/table primitives already present in the project.
- Accessibility implementation must not create a parallel interaction model different from the UIUX contract.
