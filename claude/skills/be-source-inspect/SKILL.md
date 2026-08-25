---
name: be-source-inspect
description: Read-only backend behavior extractor for control flow, exceptions, logs, transactions, persistence, integrations, side effects and security checks.
metadata:
  version: "8.0.0"
---

# be-source-inspect

Extract requested facts only:

- inputs/outputs/dependencies;
- calls and side effects;
- exception catch/translate/rethrow path;
- log statements and level/context;
- HTTP/message/job boundary behavior;
- transaction start/end and persistence calls;
- retry/fallback/idempotency behavior;
- authn/authz/validation checks;
- relevant tests.

Do not recommend architecture or edit code. Read `references/preflight.md`, `references/inspection-focus.md`, `references/self-check.md`.
