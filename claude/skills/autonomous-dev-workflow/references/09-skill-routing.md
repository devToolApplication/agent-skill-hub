# Subagent Skill Routing

## Purpose

Model routing and skill routing are separate concerns.

```text
ROLE
├─ model_tier -> model profile -> physical model
└─ canonical skill IDs -> concrete installed skill paths -> execution method
```

The Main Orchestrator MUST resolve both before every spawn.

## Mandatory skill preflight

Before delegating workflow work, Main MUST discover the skill installation available in the current Codex runtime/workspace and build a session skill index.

Do NOT assume one fixed global directory. Skill locations may differ by machine, workspace, plugin installation, or runtime configuration.

Main MUST:

1. discover the actual skill roots available to the current Codex session;
2. locate candidate `SKILL.md` files under those roots;
3. resolve each canonical workflow skill ID to the concrete installed skill;
4. verify the resolved path exists and is readable;
5. verify the skill identity/name or configured alias matches the requested canonical ID;
6. record both the skill directory and exact `SKILL.md` path;
7. cache the resolution for the current orchestration session;
8. revalidate the path before spawn if the filesystem/runtime may have changed.

Conceptual session index:

```yaml
skill_index:
  test-driven-development:
    resolved_as: test-driven-development
    skill_dir: /actual/installed/path/test-driven-development
    skill_file: /actual/installed/path/test-driven-development/SKILL.md
    verified: true

  verification-before-completion:
    resolved_as: verification-before-completion
    skill_dir: /actual/installed/path/verification-before-completion
    skill_file: /actual/installed/path/verification-before-completion/SKILL.md
    verified: true
```

Paths shown above are examples only. Main MUST provide paths discovered from the current runtime, never invented paths.

## Resolution precedence

When multiple installed skills could satisfy the same canonical ID, prefer in this order unless project policy explicitly says otherwise:

1. explicit project/workspace alias or skill mapping;
2. project/workspace-local installed skill;
3. user/global Codex-installed skill;
4. plugin-provided installed skill;
5. another explicitly configured skill root.

If two candidates at the same precedence level conflict, Main MUST resolve the ambiguity before spawn. Do not let the subagent guess.

## Hard rules

### SKILL-001 — Resolve before spawn

Every spawned assignment MUST declare `required_skills` explicitly and every required skill MUST have a verified concrete path.

### SKILL-002 — Pass exact path to subagent

For each required or activated conditional skill, Main MUST include:

```yaml
- id: <canonical-skill-id>
  resolved_as: <installed-skill-name>
  skill_dir: <concrete-directory>
  skill_file: <concrete-directory>/SKILL.md
```

The subagent prompt MUST explicitly instruct:

```text
Before doing the assignment, read and follow the supplied SKILL.md files.
Use the supplied paths; do not independently choose a different skill implementation.
```

### SKILL-003 — Required means required

A subagent MUST read/use every skill listed in `required_skills` before performing the assignment.

If a required skill cannot be resolved before spawn, Main MUST NOT spawn that worker normally.

Return/record:

```yaml
status: SKILL_UNAVAILABLE
missing_skills:
  - <skill-id>
```

### SKILL-004 — Invalid path handling

If a supplied path is missing, unreadable, or no longer contains the expected skill, the subagent MUST stop and return:

```yaml
status: SKILL_PATH_INVALID
invalid_skills:
  - id: <skill-id>
    skill_file: <supplied-path>
```

The subagent MUST NOT search for or silently substitute another implementation. Main owns re-resolution.

### SKILL-005 — Conditional skills

`conditional_skills` are activated only when their trigger becomes true. Main should resolve likely conditional skills before spawn when practical; otherwise resolve and supply their concrete path before the subagent uses them.

Example:

```yaml
conditional_skills:
  on_debug:
    - id: systematic-debugging
      resolved_as: systematic-debugging
      skill_dir: <resolved-directory>
      skill_file: <resolved-directory>/SKILL.md

  on_review_fix:
    - id: receiving-code-review
      resolved_as: receiving-code-review
      skill_dir: <resolved-directory>
      skill_file: <resolved-directory>/SKILL.md
```

### SKILL-006 — Minimal skill context

Do not load unrelated skills. Main provides only the concrete skills required for the role/task and active trigger.

### SKILL-007 — Orchestration skills stay with main

Skills that coordinate user intent, global workflow, or parallel dispatch are normally owned by PREMIUM Main and MUST NOT be delegated as decision authority.

### SKILL-008 — Main owns resolution

Subagents do not discover their own workflow skills. Main resolves and supplies them. This keeps behavior deterministic and avoids every child spending time scanning the filesystem.

## Prompt requirement

Every subagent prompt MUST contain a section equivalent to:

```text
REQUIRED SKILLS — READ BEFORE WORK

1. test-driven-development
   Directory: <resolved directory>
   SKILL.md: <resolved directory>/SKILL.md

2. verification-before-completion
   Directory: <resolved directory>
   SKILL.md: <resolved directory>/SKILL.md

You MUST read and follow each SKILL.md above before doing the assignment.
Do not search for alternative skill implementations.
If any supplied path is invalid, return SKILL_PATH_INVALID immediately.
```

The structured assignment and human-readable prompt MUST agree.

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

Main keeps final requirement, architecture, conflict, gate, and routing authority. Main also resolves its own stage-specific skill paths before using them.

### Repository / source researcher

```yaml
role: repository_researcher
model_tier: CHEAP
required_skills: []
```

If a project-specific repository/domain skill exists, Main SHOULD resolve it and attach its concrete path explicitly.

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

If the feature is UI/browser based, Main MUST resolve and attach the available browser/Playwright skill path as an additional required skill when such a skill is required by project policy.

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

Attach project documentation/architecture skills when available by resolving and passing their concrete paths.

## Parallel review dispatch

The decision to dispatch independent reviewers in parallel belongs to Main.

Main resolves and uses the concrete path for:

```text
dispatching-parallel-agents
```

Then each reviewer receives its own role-specific skill paths.

Example:

```text
PREMIUM Main + dispatching-parallel-agents
    ├─ CHEAP Spec Reviewer + verification-before-completion path
    ├─ CHEAP Test Reviewer + verification-before-completion path
    ├─ STANDARD Code Reviewer + requesting-code-review path + verification-before-completion path
    └─ STANDARD Security Reviewer + verification-before-completion path
```

## Repair routing

```text
review finding is clear
-> resolve receiving-code-review + test-driven-development paths
-> STANDARD implementation agent
-> read supplied skills
-> fix

root cause unclear
-> resolve systematic-debugging path
-> STANDARD debugger
-> return root-cause evidence
-> resolve implementation skill paths
-> STANDARD implementation agent
```

## Availability and alias resolution

Skill IDs above are canonical workflow IDs. Main/runtime MUST resolve each one against the current Codex installation before spawn.

If the installed skill uses a namespace/alias, preserve all identities:

```yaml
required_skills:
  - id: verification-before-completion
    resolved_as: superpowers/verification-before-completion
    skill_dir: <concrete-installed-directory>
    skill_file: <concrete-installed-directory>/SKILL.md
```

Do not silently treat an unrelated generic prompt as equivalent to a missing mandatory skill.
