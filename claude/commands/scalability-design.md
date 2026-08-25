# Scalability Design

Caching, load, horizontal scaling, bottleneck analysis.

## Khi nào dùng
- Thiết kế feature có high traffic
- Review performance bottlenecks
- Capacity planning
- Cache strategy

## Workflow
1. Identify traffic pattern and hot paths.
2. Estimate read/write ratio.
3. Identify bottleneck: CPU, DB, network, external API.
4. Choose scaling strategy: horizontal, cache, queue, partition.
5. Define metrics and limits.

## Patterns
- Redis cache for hot read data
- Kafka queue for burst smoothing
- Pagination/streaming for large datasets
- Read model/materialized view for expensive queries
- Backpressure for streaming/agent runs

## Checklist
- [ ] Expected QPS/concurrency noted
- [ ] DB indexes/cache plan defined
- [ ] Backpressure/rate limit defined
- [ ] Horizontal scaling safe
- [ ] State/session storage externalized
