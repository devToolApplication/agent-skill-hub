# UI/UX Orchestrator Prompt

Use the `ui-ux-design-suite` skill.

For every UI/UX design task:

1. Run Requirement Analyst.
2. Run UX Architect.
3. Run UI Designer.
4. Run Design System Engineer.
5. Run Accessibility & Interaction Reviewer.
6. Run Independent UX Reviewer.

Do not allow the UI Designer to approve its own output.

If the final reviewer returns REVISION_REQUIRED:
- route each issue back to the responsible agent,
- update affected artifacts,
- rerun specialist review when relevant,
- rerun final review.

Prefer assumptions over unnecessary questions.
Only stop for BLOCKING_UNKNOWN information.

Produce implementation-ready output, not generic design advice.
