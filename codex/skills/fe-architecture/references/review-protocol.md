# Mandatory Review Protocol

Independent review is required for non-trivial code changes.

A change is non-trivial when it does one or more of:
- changes business behavior,
- adds/modifies a feature,
- changes API/data mapping,
- changes state management,
- changes routing/permissions,
- touches shared/core infrastructure,
- refactors multiple modules,
- fixes a regression-prone bug.

Tiny comment/text-only edits can skip subagents.

## Reviewer set

Run these reviewers independently, preferably in parallel:

1. Architecture Reviewer
   - prompt: `agents/architecture-reviewer.md`

2. Code Quality Reviewer
   - prompt: `agents/code-quality-reviewer.md`

3. Test & Regression Reviewer
   - prompt: `agents/test-reviewer.md`

The implementation agent provides each reviewer:
- user request,
- relevant architecture context,
- changed files/diff,
- tests already run if any.

Reviewers MUST NOT edit code unless the primary agent explicitly delegates a fix.
Their default job is read-only review.

## Required reviewer output

Each reviewer returns:

```text
STATUS: PASS | FAIL

FINDINGS:
- [SEVERITY] file:line-or-symbol — issue
  Why: ...
  Fix: ...

VERIFICATION:
- What was inspected
- Any commands/tests run

RESIDUAL_RISKS:
- ...
```

If no findings:

```text
STATUS: PASS
FINDINGS:
- None
```

## Severity

BLOCKER:
- security vulnerability
- data loss
- broken build/runtime
- dependency cycle or boundary violation with serious impact
- implementation contradicts the requested behavior

HIGH:
- likely regression
- incorrect state/data flow
- serious maintainability/coupling issue
- critical missing validation/test
- feature bypasses stable project abstraction

MEDIUM:
- meaningful design/test/readability issue
- acceptable short-term but should be considered

LOW:
- minor simplification
- naming/polish
- low-risk consistency issue

## Gate

The primary agent MUST:
1. collect all reviewer results,
2. deduplicate overlapping findings,
3. verify findings against the code,
4. fix every valid BLOCKER/HIGH,
5. run focused checks,
6. re-run only the reviewers affected by fixes.

Normally stop after at most two review rounds.

Do not blindly implement incorrect reviewer suggestions.
If rejecting a BLOCKER/HIGH finding, explain why it is a false positive using code evidence.

Final completion requires:
- 0 unresolved BLOCKER,
- 0 unresolved HIGH.

MEDIUM/LOW may remain if explicitly reported and reasonable.

## Specialized reviewer

Add an extra subagent when the task is unusually risky:
- security/auth -> security reviewer
- performance/rendering -> performance reviewer
- accessibility -> accessibility reviewer
- migration/large refactor -> compatibility reviewer

Do not spawn extra reviewers mechanically for every small task.
