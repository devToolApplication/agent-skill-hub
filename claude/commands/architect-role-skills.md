# Architect Role — Skills Reference

Bản đồ chọn skills phụ khi `architect-role` đang active.

## Khi nào invoke skill nào

| Tình huống | Invoke skill |
|---|---|
| Thiết kế tổng thể hệ thống, service map | `/system-architecture` |
| Tách service, define ownership/boundaries | `/microservice-design` |
| Thiết kế REST/API contract, DTO, versioning | `/api-contract-design` |
| Kafka/event/topic/schema/retry/DLQ | `/event-driven-architecture` |
| AuthN/AuthZ, Keycloak, token flow | `/security-architecture` |
| MongoDB schema, indexing, data ownership | `/data-architecture` |
| Feign/WebClient/sync/async integration | `/integration-patterns` |
| Caching, scale, load, bottleneck | `/scalability-design` |
| Logs, traces, metrics, correlationId | `/observability-design` |
| Ghi quyết định kiến trúc | `/architecture-decision-record` |
| Phân tích risk/trade-off | `/technical-risk-assessment` |
| Migration/refactor/compatibility plan | `/migration-planning` |

## Workflow khi Architect Role active

1. Đọc requirement/session output trước đó.
2. Xác định 1-4 skills phụ liên quan.
3. Invoke skills phụ trước khi viết final architecture.
4. Output bắt buộc có: Context, Decision/Design, Trade-offs, Risks, Next Role.

## Quick decision tree

```
Architecture task?
├── System/module boundaries → /system-architecture + /microservice-design
├── API contract → /api-contract-design
├── Events/Kafka → /event-driven-architecture
├── Security/Auth → /security-architecture
├── Data/schema → /data-architecture
├── Integration calls → /integration-patterns
├── Scale/perf → /scalability-design
├── Logs/tracing → /observability-design
├── Need formal record → /architecture-decision-record
├── Risk review → /technical-risk-assessment
└── Migration → /migration-planning
```
