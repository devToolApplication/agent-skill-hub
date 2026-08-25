# Integration Patterns

FeignClient/WebClient, sync vs async, timeout/retry/circuit breaker.

## Khi nào dùng
- Thiết kế service-to-service integration
- Chọn REST vs Kafka
- Define timeout/retry policy
- Streaming integration

## Rules trong project này
- FeignClient cho CRUD/simple request-response
- WebClient cho streaming/long-running calls
- Kafka cho async domain events
- FE không gọi execute-service trực tiếp; FE → ai-agent-mcrs → ai-agent-excute-service

## Decision Matrix
| Need | Pattern |
|---|---|
| Immediate response | REST sync |
| Streaming response | WebClient/SSE |
| Background processing | Kafka event |
| Cross-service CRUD | FeignClient |
| Fan-out async | Kafka topic |

## Checklist
- [ ] Timeout defined
- [ ] Retry only for safe/idempotent operations
- [ ] Circuit breaker for external dependency
- [ ] Correlation ID propagated
- [ ] Error mapping documented
