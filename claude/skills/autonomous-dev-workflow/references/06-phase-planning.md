# Phase Planning

## Planning skill

Phase planning MUST use the canonical GSD planning capability:

```text
gsd-plan-phase
```

Default role routing:

```yaml
gsd_researcher:
  model_tier: CHEAP
  required_skills:
    - gsd-plan-phase

gsd_planner:
  model_tier: STANDARD
  required_skills:
    - gsd-plan-phase

plan_checker:
  model_tier: CHEAP
  required_skills:
    - gsd-plan-phase
```

If `gsd-plan-phase` is unavailable, planning MUST return `SKILL_UNAVAILABLE`; do not silently replace it with ad-hoc planning when this workflow requires GSD semantics.

## Phase properties

A phase should:
- represent one coherent technical milestone;
- have explicit requirement IDs;
- have known dependencies;
- create independently verifiable progress;
- avoid combining unrelated subsystems;
- end in an observable phase-level acceptance state.

## Phase spec

Use `assets/templates/phase-spec.md`.

Minimum sections:
- goal;
- requirement IDs;
- dependencies;
- expected deliverables;
- architecture/integration boundaries;
- out of scope;
- phase acceptance criteria;
- risks.

## Implementation plan size

A plan should be small enough for one fresh STANDARD code agent with narrow context.

Bad:

```text
Implement the entire workflow engine.
```

Better:

```text
01-create-rule-context
02-create-rule-result-contract
03-create-rule-chain
04-add-stop-policies
05-wire-runtime-executor
```

## Implementation plan content

Every plan includes:
- Plan ID / Phase / Requirement IDs;
- dependencies;
- objective + why;
- required skills + conditional skills;
- context to read;
- existing files to inspect;
- expected files to create/modify;
- interfaces/contracts;
- detailed implementation steps;
- tests required;
- acceptance criteria;
- verification commands;
- engineering standards to load;
- things not to change;
- expected structured output.

Implementation plans use `assets/templates/implementation-plan.md` and therefore default implementation skill routing to:

```yaml
required_skills:
  - test-driven-development
conditional_skills:
  on_debug:
    - systematic-debugging
  on_review_fix:
    - receiving-code-review
```

## Plan gate

No code until:
- all requirement mappings exist;
- dependencies are valid;
- required skills are resolvable;
- steps are specific enough for a fresh agent;
- testing is explicit;
- verification commands are explicit;
- scope is bounded;
- plan checker = PASS.

## Gap planning

Phase-level issues become explicit gap documents/plans. Do not patch them directly from reviewer context.

Gap plans return through:

```text
gsd-plan-phase
→ implementation + test-driven-development
→ independent review
→ phase verification
```
