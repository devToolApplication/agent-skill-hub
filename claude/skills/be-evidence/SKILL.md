---
name: be-evidence
description: Read-only backend policy evidence collector for layering, exception/logging, transactions, persistence, integration reliability, validation and security.
metadata:
  version: "8.0.0"
---

# be-evidence

Collect concrete file/line/symbol evidence for requested backend rules only.

Examples:

```text
BE-ERR catch-log-rethrow
BE-ERR duplicated final failure logs
BE-ERR transport mapping inside service
BE-LOG INFO method noise / sensitive logging
BE-TX transaction boundary widening / remote call inside transaction
BE-PERSIST cross-module repository access
BE-INT missing error translation / retry pattern divergence
BE-SEC removed/weak authz or validation
```

Do not assign severity or redesign. Return worker-result-v5 only. Read `references/preflight.md`, `references/evidence-catalog.md`, `references/self-check.md`.
