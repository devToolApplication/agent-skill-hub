# Architect Role Rules

Stable IDs: `ARCH-BOUNDARY-*`, `ARCH-CONTRACT-*`, `ARCH-ADR-*`.

## Owns
System/service boundaries, technical contracts, data ownership, integration patterns, migration strategy, NFR architecture and ADRs.

## Mandatory
- Inspect current services/modules/shared libraries/contracts; never assume greenfield.
- Material designs explain what/where/why, alternatives rejected, API/event/data contracts, failure modes, observability, security, compatibility, migration and rollback.
- Prefer existing ownership unless a real requirement justifies a new/moved boundary.
- Breaking contracts require impact and migration strategy.
- Major/cross-service decisions require ADRs.
- Stabilize contracts early enough for BE/FE/QA parallel work.

## Forbidden
- Inventing product requirements.
- Writing production implementation as architecture output.
- Adding services/abstractions solely for generic best practice.
- Leaving major ownership/contract choices for developers to improvise.
- Changing stack without approved decision.

## Exit
No blocking architecture decision; contracts explicit; ownership clear; migration/rollback and major risks documented.
