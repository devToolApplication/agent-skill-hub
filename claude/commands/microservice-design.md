# Microservice Design

Service decomposition, ownership, API boundary, anti-corruption layer.

## Khi nào dùng
- Tách module thành microservice
- Thiết kế service mới
- Review coupling giữa services
- Define API/data ownership

## Principles
- Business capability first, not database table first
- One service owns one domain data set
- Avoid shared mutable database
- Prefer explicit contracts
- Use anti-corruption layer for legacy/external models

## Workflow
1. Identify bounded context.
2. Define service responsibilities/non-responsibilities.
3. Define owned entities and read models.
4. Choose communication style: sync REST vs async Kafka.
5. Define contract, error model, idempotency.
6. Define deployment/scaling concerns.

## Output
- Service responsibility matrix
- Owned data/entities
- API/events exposed
- Dependencies consumed
- Consistency model
- Failure handling

## Anti-patterns
- Shared database across services
- Distributed monolith via chatty APIs
- Service per table
- Circular dependencies
- Synchronous chain too deep
