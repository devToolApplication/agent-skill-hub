# Event-Driven Architecture

Kafka events, topic design, idempotency, retry, DLQ, ordering.

## Khi nào dùng
- Thiết kế Kafka topic/event
- Async integration giữa services
- Background processing
- Event replay/audit

## Workflow
1. Xác định producer/consumer và business event.
2. Define event schema, key, version.
3. Define topic naming and partition strategy.
4. Define ordering requirement.
5. Define retry, DLQ, idempotency.
6. Define monitoring and replay strategy.

## Event Contract
```json
{
  "eventId": "uuid",
  "eventType": "domain.entity.action.v1",
  "occurredAt": "ISO-8601",
  "producer": "service-name",
  "correlationId": "...",
  "payload": {}
}
```

## Rules
- Event name = past tense business fact, not command
- Include version in eventType or schema registry
- Consumer must be idempotent
- DLQ for poison messages
- Use correlationId for tracing

## Checklist
- [ ] Partition key chosen intentionally
- [ ] Ordering requirement documented
- [ ] Retry/backoff/DLQ specified
- [ ] Schema evolution backward compatible
- [ ] Idempotency key defined
