# BA Role — Skills Reference

Bản đồ chọn skills phụ khi `ba-role` đang active.

## Khi nào invoke skill nào

| Tình huống | Invoke skill |
|---|---|
| Requirement mơ hồ, cần phân tích | `/requirement-analysis` |
| Viết Epic/Story/Sub-task | `/user-story-writing` |
| Viết Given/When/Then, AC | `/acceptance-criteria` |
| Flow nghiệp vụ, state machine | `/business-process-modeling` |
| Viết functional design doc | `/functional-specification` |
| Tìm edge cases/exception flow | `/edge-case-discovery` |
| Requirement màn hình/form/table/UI states | `/ui-ux-requirement` |
| Requirement API input/output/error/permission | `/api-requirement-spec` |
| Requirement dữ liệu/field/lifecycle/audit | `/data-requirement-spec` |
| Viết Jira ticket | `/jira-ticket-writing` |
| Câu hỏi clarify stakeholder | `/stakeholder-questioning` |
| MVP vs phase 2, scope control | `/release-scope-control` |

## Workflow khi BA Role active

1. Đọc yêu cầu user + session output trước đó.
2. Nếu mơ hồ: invoke `/stakeholder-questioning` hoặc `/requirement-analysis`.
3. Nếu đủ rõ: invoke skills phụ theo artifact cần tạo.
4. Output phải chuyển được cho Architect/Dev/Test mà không cần đoán.

## Quick decision tree

```
BA task?
├── Chưa rõ yêu cầu → /requirement-analysis + /stakeholder-questioning
├── Cần story/Jira → /user-story-writing + /jira-ticket-writing
├── Cần AC → /acceptance-criteria + /edge-case-discovery
├── Cần doc chức năng → /functional-specification
├── Có flow/state → /business-process-modeling
├── Có UI → /ui-ux-requirement
├── Có API → /api-requirement-spec
├── Có data → /data-requirement-spec
└── Scope lớn → /release-scope-control
```
