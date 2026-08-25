# Data Architecture

MongoDB schema strategy, indexing, consistency, transaction boundaries.

## Khi nào dùng
- Thiết kế data model
- Review MongoDB collections/indexes
- Cross-service data ownership
- Consistency/transaction decisions

## Workflow
1. Identify data owner service.
2. Model read/write access patterns.
3. Choose embed vs reference.
4. Define indexes from queries.
5. Define lifecycle, retention, audit.
6. Define consistency model.

## MongoDB Rules
- Design around query patterns
- Embed for one-to-few owned data
- Reference for large/unbounded relations
- Avoid unbounded arrays
- Index every high-cardinality query path
- TTL for expirable data

## Output
- Collection schemas
- Index plan
- Query patterns
- Consistency/transaction strategy
- Migration/backfill plan

## Checklist
- [ ] Owner service clear
- [ ] No shared writes across services
- [ ] Indexes match queries
- [ ] 16MB document risk checked
- [ ] Data lifecycle defined
