# Engineering Rule and Reviewer Routing

## Purpose

Use changed files, plan intent, and architecture impact to decide which project standards and dynamic reviewers apply. Do not load every standard into every agent.

## Example project standards

```text
docs/03-architecture/standards/
├── review-policy.md
├── backend.md
├── frontend.md
├── uiux.md
├── api.md
├── event.md
├── database.md
├── logging.md
├── error-handling.md
├── testing.md
├── security.md
├── performance.md
└── infrastructure.md
```

## Routing examples

### Backend business logic
Load:
- backend.md
- testing.md
- error-handling.md
- logging.md
- review-policy.md

Reviewer set:
- Spec
- Test
- Code

### REST/API change
Add:
- api.md
- API Contract Reviewer

### DB/query/migration
Add:
- database.md
- DB Reviewer

### Auth/security-sensitive path
Add:
- security.md
- Security Reviewer

### Frontend behavior
Load:
- frontend.md
- testing.md
- uiux.md when UX is affected

Add UI/UX Reviewer when user interaction/layout changes.

### Realtime/concurrency/high-throughput
Add:
- performance.md
- Performance Reviewer

### Cross-module/service architecture change
Add:
- Architecture Reviewer
- relevant ADR/service docs

## Rule IDs

Project standards should use stable IDs such as:

```text
ARCH-001
ERR-003
LOG-002
TEST-002
API-004
DB-003
SEC-002
```

Review findings should cite these IDs so repair agents receive deterministic expectations rather than vague advice.
