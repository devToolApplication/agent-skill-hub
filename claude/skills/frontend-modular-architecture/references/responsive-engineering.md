# Frontend Responsive Engineering

UIUX defines the responsive transformation. FE implements it.

- Reuse existing breakpoint/container-query conventions.
- Do not invent a different mobile UX from the approved UIUX spec.
- Prefer a single data/query source across desktop/mobile presentations.
- Avoid duplicated business state/API calls solely because there are separate responsive presentations.
- Preserve semantic/keyboard behavior across responsive variants.
- Avoid arbitrary breakpoint values when the design system already defines responsive tokens.
- If the UIUX requirement cannot be implemented within declared scope or conflicts with existing architecture, BLOCK and return exact evidence; do not silently degrade the design.
