# System Architecture

Thiết kế tổng thể hệ thống: service map, boundaries, dependencies, runtime topology.

## Khi nào dùng
- Thiết kế hệ thống mới hoặc module lớn
- Review kiến trúc hiện tại
- Vẽ service boundaries, dependency flow
- Đánh giá tác động cross-service

## Workflow
1. Xác định business capability và actors.
2. Map bounded contexts/service ownership.
3. Vẽ data flow + control flow.
4. Xác định sync/async communication.
5. Chỉ ra dependencies, failure points, bottlenecks.
6. Đề xuất target architecture + migration path.

## Output bắt buộc
- Context & goals
- Current architecture (nếu có)
- Proposed architecture diagram (ASCII/Mermaid)
- Service responsibilities
- Data ownership
- Integration points
- Risks/trade-offs
- Migration steps

## Checklist
- [ ] Boundaries rõ, không overlap ownership
- [ ] Service nào owning data nào
- [ ] Critical path latency được xác định
- [ ] Failure modes có fallback/retry/circuit breaker
- [ ] Security/auth flow rõ
- [ ] Observability points rõ
