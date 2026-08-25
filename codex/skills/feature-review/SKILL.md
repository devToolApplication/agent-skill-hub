---
name: feature-review
description: Evidence-first post-change review. BE/FE evidence workers collect bounded implementation facts, UIUX spec verifier checks approved design requirements, and the strong parent validates evidence, assigns severity, chooses fixes, and issues exact TaskSpec v5 work.
metadata:
  version: "3.0.0"
---

# Feature Review v3 — Evidence First

Use after non-trivial implementation, risky refactor, public contract change, persistence/security/concurrency change, cross-module change, or important frontend/UI behavior change.

There are no autonomous broad reviewer agents.

## 1. Establish exact review scope

Identify exact changed files and relevant acceptance/UIUX requirement IDs.

## 2. Select bounded evidence questions

Use BE/FE evidence workers for implementation-policy facts.

Good:

```text
List changed imports from feature/order that resolve to another feature's internal files.
List changed request paths where authorization was removed/bypassed.
Find new hard-coded visible strings in the i18n-enabled changed frontend scope.
Find theme values that bypass existing semantic tokens in changed FE files.
```

Bad:

```text
Review architecture.
Review security.
Review UX.
Check whether the whole feature is good.
```

BE/FE evidence uses `read-task-v5` and `worker-result-v5`.

## 3. UIUX verification is contract-based

If the change implements an approved `uiux-spec-v1`, use `uiux_spec_verify` with `uiux-verify-task-v5` for exact requirement IDs.

Do not ask `fe_evidence` to make final UX judgments. FE evidence checks implementation rules; UIUX verifier checks user-facing design-contract evidence.

## 4. Parent validates and judges

The parent:

1. verifies evidence locations/symbols;
2. discards unsupported/speculative findings;
3. merges duplicate root causes;
4. assigns category/severity using `references/severity.md`;
5. chooses a concrete fix direction for accepted blocking issues.

## 5. Fix loop

Never say `fix review issues`.

For each coherent fix, parent creates complete `write-task-v5` with exact evidence, chosen direction, exact files/symbols, per-file instructions, preserve/forbidden scope, applicable policy refs, acceptance, and verification.

## 6. Verdict

`PASS`: no justified blocking findings remain and required verification has sufficient evidence.

`CHANGES_REQUIRED`: at least one justified blocking finding remains.

`NEEDS_MANUAL/RENDERED_VERIFICATION`: a required UX property cannot be proven from available evidence; never convert uncertainty into PASS.
