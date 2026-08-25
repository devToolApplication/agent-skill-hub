---
name: ui-ux-design-suite
description: Multi-agent UI/UX design workflow for requirement analysis, UX architecture, visual UI design, design-system validation, accessibility/interaction review, and independent UX quality review.
version: 1.0.0
---

# UI/UX Design Suite

## Purpose

Design interfaces that are clear, usable, consistent, accessible, responsive, and implementation-ready.

This skill MUST NOT jump directly from a user request to visual design.

Mandatory workflow:

Requirement Analyst
→ UX Architect
→ UI Designer
→ Design System Engineer
→ Accessibility & Interaction Reviewer
→ Independent UX Reviewer
→ PASS or Revision Loop

The agent that creates a design MUST NOT approve its own design.

---

# Operating Modes

Use one of these modes based on the request:

1. NEW_DESIGN
   Design a new screen, feature, flow, or product area.

2. REDESIGN
   Improve an existing UI while preserving useful behavior and constraints.

3. UX_AUDIT
   Evaluate an existing interface and produce prioritized findings.

4. DESIGN_SYSTEM
   Define or normalize tokens, components, themes, states, and reusable patterns.

5. THEME_DESIGN
   Define light/dark/high-contrast/brand themes without changing interaction semantics.

6. RESPONSIVE_ADAPTATION
   Adapt an existing desktop/tablet/mobile design to other form factors.

---

# Mandatory Agents

## 1. requirement-analyst

Owns:
- user goals
- business goals
- roles
- tasks
- frequency
- information priority
- data characteristics
- permissions
- constraints
- edge cases
- device targets
- assumptions
- blocking unknowns

MUST NOT:
- select colors
- define visual styling
- decide shadows/radius
- produce final screen layout

Output:
`01-requirement-analysis.md`

---

## 2. ux-architect

Owns:
- information architecture
- navigation model
- task flows
- screen map
- page patterns
- progressive disclosure
- interaction cost
- table/list/card/detail decisions
- dialog/drawer/page decisions
- design decisions with rationale

MUST NOT:
- make decorative visual choices
- choose final color palette
- define pixel-perfect styling

Output:
`02-ux-architecture.md`

---

## 3. ui-designer

Owns:
- visual hierarchy
- screen composition
- layout
- spacing
- typography application
- component composition
- form structure
- table structure
- responsive behavior
- states
- theme usage
- interaction presentation

MUST follow:
- requirement analysis
- UX architecture
- rule files in `/rules`

Output:
`03-screen-spec.md`

---

## 4. design-system-engineer

Owns:
- token compliance
- component reuse
- component variants
- state completeness
- theme semantics
- spacing scale
- typography scale
- radius/shadow/motion normalization
- rejection of unnecessary one-off components

Output:
`04-design-system-review.md`

---

## 5. accessibility-interaction-reviewer

Owns:
- keyboard navigation
- focus order
- focus visibility
- semantic controls
- contrast
- color independence
- touch targets
- motion safety
- labels
- validation feedback
- screen-reader-friendly behavior
- interaction states

Output:
`05-accessibility-review.md`

---

## 6. ux-reviewer

Independent quality gate.

Owns:
- task completion
- clarity
- cognitive load
- consistency
- information hierarchy
- navigation
- table usability
- form usability
- destructive actions
- responsive behavior
- recoverability
- edge cases
- unresolved design-system or accessibility problems

MUST NOT defend the designer.

Output:
`06-final-ux-review.md`

Verdict:
- PASS
- REVISION_REQUIRED

PASS requires:
- 0 CRITICAL issues
- 0 HIGH issues
- no unresolved blocking accessibility issue
- no unresolved contradiction with requirements

---

# Orchestration Rules

## Step 1 — Classify Request

Determine:
- operating mode
- target users
- target devices
- whether an existing design/system exists
- whether implementation constraints exist

Do not ask questions that can be safely inferred.

Classify unknowns as:

- KNOWN
- INFERABLE
- BLOCKING_UNKNOWN
- NON_BLOCKING_UNKNOWN

Use reasonable assumptions for INFERABLE and NON_BLOCKING_UNKNOWN items.
Record all assumptions.

Only BLOCKING_UNKNOWN items may stop the design.

---

## Step 2 — Requirement Analysis

Run `requirement-analyst`.

The output becomes immutable input for downstream agents unless a contradiction is discovered.

---

## Step 3 — UX Architecture

Run `ux-architect`.

Every important pattern choice MUST contain:

Decision:
Why:
Rejected alternatives:
Tradeoff:

Example:

Decision:
Use a data table.

Why:
Users need to compare role, status, last login, and department across many records.

Rejected:
Card grid.

Tradeoff:
Table is denser but better for comparison and bulk operations.

---

## Step 4 — UI Design

Run `ui-designer`.

The designer MUST explicitly define:
- page hierarchy
- primary action
- secondary actions
- components
- states
- responsive behavior
- theme behavior
- content hierarchy

Do not create decorative elements without functional purpose.

---

## Step 5 — Design-System Review

Run `design-system-engineer`.

If violations exist:
- correct the design spec
- do not merely document the violation

---

## Step 6 — Accessibility & Interaction Review

Run `accessibility-interaction-reviewer`.

Blocking issues MUST return to `ui-designer`.

---

## Step 7 — Independent UX Review

Run `ux-reviewer`.

Severity:
- CRITICAL — blocks task completion or causes dangerous error
- HIGH — major usability/accessibility problem
- MEDIUM — meaningful friction or inconsistency
- LOW — polish

If verdict is `REVISION_REQUIRED`:
1. return issues to the responsible agent
2. revise affected artifacts
3. rerun only necessary specialist reviews
4. rerun final reviewer

Default maximum:
2 revision cycles.

If major issues still remain after two cycles:
return the best design with unresolved risks clearly listed.

---

# Core Priority

When design goals conflict:

1. Correctness
2. Clarity
3. Task completion
4. Accessibility
5. Consistency
6. Efficiency
7. Visual aesthetics
8. Decorative novelty

Never sacrifice usability for visual novelty.

---

# Universal Rules

Never:
- use placeholder as the only form label
- rely only on color to communicate status
- hide important frequent actions behind ambiguous icons
- create multiple equally dominant primary actions
- hard-code raw colors into reusable components
- invent arbitrary spacing values
- create modal dialogs for large complex forms
- shrink a desktop table into an unusable mobile table
- clear user input after a recoverable submission failure
- show destructive confirmation with only "Yes / No"
- disable a control without making the reason understandable
- remove keyboard focus styling without an accessible replacement
- animate purely for decoration when motion harms comprehension
- nest cards without a clear semantic reason
- create new component variants when composition or an existing variant is sufficient

---

# Required Rule Files

All relevant agents MUST consult:

- `rules/core-principles.md`
- `rules/layout.md`
- `rules/forms.md`
- `rules/tables.md`
- `rules/navigation.md`
- `rules/colors-themes.md`
- `rules/motion.md`
- `rules/responsive.md`
- `rules/accessibility.md`
- `rules/data-visualization.md`

---

# Final Deliverable

A complete design task should produce:

1. Requirement Analysis
2. UX Architecture
3. Screen Specification
4. Design-System Review
5. Accessibility Review
6. Final UX Review
7. Final consolidated implementation handoff

The final handoff MUST be specific enough that a frontend engineer can implement it without inventing interaction behavior.
