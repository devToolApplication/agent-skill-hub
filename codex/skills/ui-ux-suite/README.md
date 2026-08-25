# UI/UX Design Suite

Portable multi-agent UI/UX skill package.

## Agents

- Requirement Analyst
- UX Architect
- UI Designer
- Design System Engineer
- Accessibility & Interaction Reviewer
- Independent UX Reviewer

## Recommended workflow

```text
User Request
    ↓
Requirement Analyst
    ↓
UX Architect
    ↓
UI Designer
    ↓
Design System Engineer
    ↓
Accessibility Reviewer
    ↓
Independent UX Reviewer
    ↓
PASS ─────────────→ Implementation
  │
  └ REVISION_REQUIRED
            ↓
      Responsible Agent
            ↓
        Re-review
```

## Why this split exists

The suite separates:
- understanding the problem,
- choosing UX patterns,
- visual design,
- system consistency,
- accessibility,
- final approval.

This reduces the common failure mode where one model invents a design and then validates its own assumptions.

## Suggested installation

Copy the whole `ui-ux-design-suite` folder into the skill directory used by your AI tool.

If the tool supports subagents, map each file in `/agents` to a dedicated subagent.

If the tool only supports one agent, the orchestrator should execute each agent prompt sequentially and preserve the handoff artifacts.

## Output convention

For a design task, create:

```text
ui-ux-output/
├── 01-requirement-analysis.md
├── 02-ux-architecture.md
├── 03-screen-spec.md
├── 04-design-system-review.md
├── 05-accessibility-review.md
├── 06-final-ux-review.md
└── 07-implementation-handoff.md
```

## Recommended inputs

Provide, when available:
- business requirement
- screenshot
- existing UI
- user role
- API/data model
- component library
- brand colors
- desktop/mobile target
- accessibility requirements

Missing non-blocking details should be inferred and recorded as assumptions instead of stopping the workflow.
