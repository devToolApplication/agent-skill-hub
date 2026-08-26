# Subagent Skill Routing

## Purpose

Model routing and skill routing are separate concerns.

```text
ROLE
├─ model_tier -> model profile -> physical model
└─ required_skills / conditional_skills -> agent execution method
```

The Main Orchestrator MUST resolve both before every spawn.

## Hard rules

### SKILL-001 — Resolve before spawn

Every spawned assignment MUST declare `required_skills` explicitly.

### SKILL-002 — Required means required

A subagent MUST load/use every skill listed in `required_skills` before performing the assignment.

If any required skill is unavailable, the agent MUST return:

```yaml
status: SKILL_UNAVAILABLE
missing_skills:
  - <skill-id>
```

It MUST NOT silently substitute a different process.

### SKILL-003 — Conditional skills

`conditional_skills` are activated only when their trigger becomes true.

Example:

```yaml
conditional_skills:
  on_debug:
    - systematic-debugging
  on_review_fix:
    - receiving-code-review
```

### SKILL-004 — Minimal skill context

Do not load unrelated skills. Main should provide only skills required for the role/task and applicable trigger.

### SKILL-005 — Orchestration skills stay with main

Skills that coordinate user intent, global workflow, or parallel dispatch are normally owned by PREMIUM Main and MUST NOT be delegated as decision authority.

## Canonical role routing

### Main Orchestrator

```yaml
role: main_orchestrator
model_tier: PREMIUM
required_skills:
  - autonomous-dev-workflow
conditional_skills:
  requirement_discovery:
    - grill-me
  technical_design:
    - brainstorming
  parallel_dispatch:
    - dispatching-parallel-agents
  final_requirement_check:
    - grill-me
```

Main keeps final requirement, architecture, conflict, gate, and routing authority.

### Repository / source researcher

```yaml
role: repository_researcher
model_tier: CHEAP
required_skills: []
```

If a project-specific repository/domain skill exists, Main SHOULD attach it explicitly.

### Technical research / option researcher

```yaml
role: technical_researcher
model_tier: CHEAP
required_skills: []
```

Researchers return evidence/options/tradeoffs. They do not decide architecture.

### GSD phase researcher

```yaml
role: gsd_researcher
model_tier: CHEAP
required_skills:
  - gsd-plan-phase
```

### GSD planner

```yaml
role: gsd_planner
model_tier: STANDARD
required_skills:
  - gsd-plan-phase
```

### Plan checker

```yaml
role: plan_checker
model_tier: CHEAP
required_skills:
  - gsd-plan-phase
```

The GSD planning capability owns research -> planning -> plan checking semantics.

### Implementation agent

```yaml
role: implementation_agent
model_tier: STANDARD
required_skills:
  - test-driven-development
conditional_skills:
  on_debug:
    - systematic-debugging
  on_review_fix:
    - receiving-code-review
```

Implementation must stay within the assigned plan and must not approve itself.

### Debugging agent

```yaml
role: debugger
model_tier: STANDARD
required_skills:
  - systematic-debugging
```

### Specification Reviewer

```yaml
role: specification_reviewer
model_tier: CHEAP
required_skills:
  - verification-before-completion
```

### Test Reviewer

```yaml
role: test_reviewer
model_tier: CHEAP
required_skills:
  - verification-before-completion
```

Must independently execute relevant tests when possible.

### Code Reviewer

```yaml
role: code_reviewer
model_tier: STANDARD
required_skills:
  - requesting-code-review
  - verification-before-completion
```

### Architecture Reviewer

```yaml
role: architecture_reviewer
model_tier: STANDARD
required_skills:
  - requesting-code-review
  - verification-before-completion
```

Attach project architecture standards through `standards`, not by inventing another generic workflow skill.

### Security Reviewer

```yaml
role: security_reviewer
model_tier: STANDARD
required_skills:
  - verification-before-completion
conditional_skills:
  phase_security_review:
    - gsd-secure-phase
```

### UI/UX Reviewer

```yaml
role: uiux_reviewer
model_tier: CHEAP | STANDARD
required_skills:
  - verification-before-completion
conditional_skills:
  phase_ui_review:
    - gsd-ui-review
```

### Phase deep reviewer

```yaml
role: phase_deep_reviewer
model_tier: STANDARD
required_skills:
  - gsd-code-review
  - gsd-validate-phase
  - verification-before-completion
```

### Local integration verifier

```yaml
role: local_integration_verifier
model_tier: CHEAP | STANDARD
required_skills:
  - verification-before-completion
```

### Local live/E2E agent

```yaml
role: local_live_test_agent
model_tier: CHEAP
required_skills:
  - verification-before-completion
```

If the feature is UI/browser based, attach the available browser/Playwright skill explicitly as an additional required skill.

### Test-environment integration verifier

```yaml
role: test_env_integration_verifier
model_tier: CHEAP | STANDARD
required_skills:
  - verification-before-completion
```

### Test-environment live/E2E agent

```yaml
role: test_env_live_test_agent
model_tier: CHEAP
required_skills:
  - verification-before-completion
```

### UAT agent

```yaml
role: uat_agent
model_tier: CHEAP
required_skills:
  - gsd-verify-work
  - verification-before-completion
```

### Documentation sync agent

```yaml
role: documentation_agent
model_tier: CHEAP
required_skills: []
```

Attach project documentation/architecture skills when available.

## Parallel review dispatch

The decision to dispatch independent reviewers in parallel belongs to Main.

Main uses:

```text
dispatching-parallel-agents
```

Then each reviewer receives its own role-specific required skills.

Example:

```text
PREMIUM Main + dispatching-parallel-agents
    ├─ CHEAP Spec Reviewer + verification-before-completion
    ├─ CHEAP Test Reviewer + verification-before-completion
    ├─ STANDARD Code Reviewer + requesting-code-review + verification-before-completion
    └─ STANDARD Security Reviewer + verification-before-completion
```

## Repair routing

```text
review finding is clear
-> STANDARD implementation agent
-> receiving-code-review
-> test-driven-development

root cause unclear
-> STANDARD debugger
-> systematic-debugging
-> return root-cause evidence
-> STANDARD implementation agent
-> test-driven-development
```

## Availability resolution

Skill IDs above are canonical workflow IDs. Before spawn, Main/runtime MUST resolve that the skill exists in the current Codex installation.

If a repository uses a namespaced/aliased equivalent, record both:

```yaml
required_skills:
  - id: verification-before-completion
    resolved_as: <installed-skill-name>
```

Do not silently treat an unrelated generic prompt as equivalent to a missing mandatory skill.
