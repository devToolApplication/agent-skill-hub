# Architecture Decision Record

Viết ADR chuẩn: context, decision, consequences, alternatives.

## Khi nào dùng
- Có quyết định kiến trúc quan trọng
- Chọn giữa nhiều technology/patterns
- Breaking change/migration
- Cross-service contract change

## ADR Template
```md
# ADR-XXX: Title

## Status
Proposed | Accepted | Deprecated | Superseded

## Context
Problem, constraints, forces.

## Decision
Decision made.

## Alternatives Considered
1. Option A — pros/cons
2. Option B — pros/cons

## Consequences
Positive, negative, risks.

## Migration Plan
Steps, compatibility, rollback.

## References
Links/files/tickets.
```

## Rules
- Decision must be explicit
- Include rejected alternatives
- Include consequences, not only benefits
- Include rollback for risky changes
