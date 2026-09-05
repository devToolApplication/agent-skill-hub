# Architect Skill Workflow

```text
READ_REQUIREMENTS -> CURRENT_SYSTEM -> MULTI_OPTIONS_TRADEOFF -> SELECT_OPTIMAL -> MODULE_STRUCTURE_DESIGN -> DESIGN_CONTRACTS -> RISK -> ADR -> SELF_REVIEW -> HANDOFF
```

## READ_REQUIREMENTS / CURRENT_SYSTEM
Skill: `system-architecture`; inspect existing ownership, libraries and contracts.

## MULTI_OPTIONS_TRADEOFF & SELECT_OPTIMAL
Skills: `system-architecture`, `technical-risk-assessment`; conditional `microservice-design`, `integration-patterns`.
- **Bắt buộc lên tối thiểu 2-3 phương án:** Phân tích các cách tiếp cận khác nhau để giải quyết bài toán.
- **Bảng so sánh Trade-off chi tiết:** Liệt kê rõ ưu điểm, nhược điểm, độ phức tạp triển khai, hiệu năng, khả năng mở rộng, chi phí vận hành và rủi ro của từng option.
- **Luận giải đề xuất:** Chỉ định rõ phương án khuyến nghị (Recommended Option) kèm lý do chọn và lý do bác bỏ các option còn lại.

## MODULE_STRUCTURE_DESIGN & DESIGN_CONTRACTS
Conditional skills: `api-contract-design`, `event-driven-architecture`, `data-architecture`, `security-architecture`, `observability-design`, `scalability-design`.
- **Chuẩn hóa sơ đồ thư mục module (Folder Layout):**
  - Định rõ cấu trúc cây thư mục của module mới/refactor cho cả Backend (`api/`, `application/`, `domain/`, `infrastructure/`, `config/`) và Frontend (`components/`, `pages/`, `services/`, `models/`, `utils/`).
  - Phân định rõ trách nhiệm của từng layer/folder để Dev BE và Dev FE triển khai đúng vị trí.
- **Contracts:** PASS when downstream implementation can proceed without inventing major contracts.

## RISK
Skill: `technical-risk-assessment`; include compatibility, migration and rollback.

## ADR
Skill: `architecture-decision-record` for material decisions; `migration-planning` when migration exists. Lưu trữ đầy đủ phương án đã chọn, các phương án thay thế bị loại bỏ kèm trade-off và module folder layout.

## SELF_REVIEW
Check overengineering, multi-option trade-off completeness, module folder structure adherence, ownership, compatibility, failure modes, observability, security, migration and rollback. FAIL routes to MULTI_OPTIONS_TRADEOFF / MODULE_STRUCTURE_DESIGN.

## HANDOFF
Return ADR/design refs, stable contracts, module folder blueprint, ownership boundaries, evaluated trade-offs and implementation constraints.
