---
name: autonomous-dev-workflow
description: Agent-first autonomous software delivery. Main orchestrates a dependency DAG, dispatches dedicated agents in parallel, enforces role-specific skill workflows and rules, requires implementation self-test/self-review, independent review, integration verification and final gates. Task definitions never select models.
---

# Autonomous Development Workflow

## Non-negotiable invariants

1. **Main orchestrates; subagents execute.** Main does not implement production code, write tests for an implementation task, or approve its own work.
2. **Dispatch by agent only.** Assignments contain `agent: <agent-name>`. `model`, `model_tier`, `provider` and equivalent runtime-selection fields are forbidden.
3. **Plan as a DAG.** Planning MUST express real dependencies and split independent work so BE, FE, QA preparation, reviewers, and multiple instances of the same role can run concurrently.
4. **Parallel-first, safety-first.** A task may run when design dependencies pass, required contracts are stable, capacity exists, and its write ownership does not overlap another active writer.
5. **Rolling scheduling.** Main dispatches a newly unblocked task immediately; it does not wait for an entire batch/phase to finish.
6. **Every agent follows its role workflow.** Loading a list of skills is not sufficient; skills are used at defined workflow steps with pass/fail routes.
7. **Implementation self-gate.** Dev agents MUST perform `SELF_TEST -> SELF_REVIEW -> FINAL_VERIFY` before handoff. A self-review failure routes back to implementation/fix and then repeats test and review.
8. **Independent review remains mandatory.** Self-review cannot satisfy an independent code/test/spec/specialist review gate.
9. **Evidence is fresh.** Any code change invalidates affected prior test/review evidence; affected checks must be rerun.
10. **No self-approval.** The agent that creates a change cannot be the independent reviewer that approves it.

## Required loading order

Main MUST read:

1. `config/orchestration.yaml`
2. `config/agent-registry.yaml`
3. `orchestration/main-workflow.md`
4. `orchestration/parallel-execution.md`
5. `contracts/task-assignment.md`
6. `contracts/task-result.md`
7. `references/09-skill-routing.md`
8. the selected role rule file and workflow file before spawning that role.

## Delivery lifecycle

```text
DISCOVERY
  -> REQUIREMENTS_LOCKED
  -> ARCHITECTURE / CONTRACT_LOCK
  -> DAG_PLANNING
  -> DYNAMIC_PARALLEL_EXECUTION
       -> per-task SELF GATE
       -> rolling INDEPENDENT REVIEW
       -> repair/re-review when needed
  -> FAN-IN / INTEGRATION
  -> INTEGRATION VERIFY
  -> E2E / QA
  -> PHASE REVIEW
  -> FINAL FEATURE GATE
```

## Planning rule

A plan is invalid if it is only a sequential checklist when two or more tasks could safely execute independently. For each task record design dependencies, runtime/test dependencies, write ownership, required agent, workflow, acceptance criteria, verification and reviewers.

## Agent instance rule

Agent definitions are capabilities, not singletons. Main may spawn multiple concurrent instances of `dev-be-agent`, `dev-fe-agent`, or another agent when the scheduler allows it. Main never creates synthetic agent names such as `dev-be-agent-2` and never chooses the underlying model.

## Rule precedence

`explicit user requirement > locked product/AI spec > approved architecture/ADR > project engineering rules > phase/task plan > repository convention > generic best practice > reviewer preference`.

On conflict, stop the affected task and route to the owner of the higher-level decision instead of silently choosing.
