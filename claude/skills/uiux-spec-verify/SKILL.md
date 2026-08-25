---
name: uiux-spec-verify
description: Read-only UI/UX contract verifier. Compares exact implementation evidence against uiux-spec-v1 requirement IDs without editing code or choosing frontend architecture.
metadata:
  version: "8.0.0"
---

# uiux-spec-verify

Accept only `uiux-verify-task-v5` with exact `spec_ref`, requirement IDs, implementation files/evidence, and matching worker skill.

For each requirement ID return one of:

```text
SATISFIED
VIOLATED
NOT_VERIFIABLE
```

Include exact evidence for SATISFIED/VIOLATED.

## Critical honesty rule

Source code alone may not prove visual hierarchy, pixel layout, rendered contrast, truncation, or actual focus movement. If the available evidence cannot prove the requirement, return `NOT_VERIFIABLE_FROM_AVAILABLE_EVIDENCE`; do not hallucinate a PASS.

## Must not

- edit files;
- propose component/state/query architecture;
- invent a different UX;
- assign engineering severity;
- treat a plausible implementation as observed behavior.

Return worker-result-v5 only. Read `references/preflight.md`, `references/verification-method.md`, `references/self-check.md`.
