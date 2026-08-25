# UIUX Ownership Boundary

UIUX answers **what experience is required**.
Frontend answers **how code realizes it**.

Examples:

- `Use a drawer for edit because context should remain visible` -> UIUX.
- `Reuse existing Drawer primitive and keep form state in UserEditForm` -> FE.
- `Mobile list shows identity + status, secondary actions in overflow` -> UIUX.
- `Use existing md breakpoint and UserMobileList component` -> FE.
- `Error must be associated with the field and announced` -> UIUX.
- `Use aria-describedby and current form-library setError mapping` -> FE.

If a UIUX worker starts naming hooks/stores/query libraries/component folder placement as a proposed architecture, it has crossed its role boundary.
