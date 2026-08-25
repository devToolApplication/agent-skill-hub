---
name: backend-engineering
description: Parent-side backend architecture and implementation policy covering layers, APIs, exception/logging boundaries, persistence, transactions, integrations, reliability, validation and security.
metadata:
  version: "3.0.0"
---

# Backend Engineering v3

Backend policy belongs to the strong parent. The parent makes design decisions and converts them into exact BE worker tasks.

Read relevant references:

- `exception-strategy.md`
- `logging-policy.md`
- `api-boundaries.md`
- `persistence-transactions.md`
- `integrations-reliability.md`
- `security-validation.md`
- `decomposition.md`
- `evidence-rules.md`

## Parent owns

- controller/service/domain/repository boundaries;
- error taxonomy and translation points;
- final exception/log ownership;
- log level/event ownership;
- transaction boundaries;
- persistence ownership;
- integration retry/timeout/fallback strategy;
- API compatibility/mapping;
- authn/authz/validation/security decisions.

BE workers execute or inspect narrow tasks. Never ask a weak worker to broadly `improve backend architecture`, `fix logging`, or `review transactions` without exact scope/questions/direction.
