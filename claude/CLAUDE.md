# Custom Instructions for Claude Code

---

# Project-Level AGENTS.md

Before starting any task, check if an `AGENTS.md` file exists in the current working directory (workspace root). If it does, read it first and follow its instructions — they take priority over any generic behavior.

---

# Role-Based Execution (bắt buộc)

**Trước khi bắt đầu BẤT KỲ task nào, phải xác định role phù hợp và invoke skill tương ứng.**

## Quy trình:

1. Đọc yêu cầu của user.
2. Xác định task thuộc role nào theo bảng dưới.
3. Invoke skill role đó (dùng `/role-name` hoặc tự activate workflow của role).
4. Tuân thủ workflow của role — KHÔNG skip steps.

## Bảng phân loại task → role:

| Task | Role | Skill |
|------|------|-------|
| Phân tích yêu cầu, viết user story, acceptance criteria | BA | `ba-role` |
| Thiết kế kiến trúc, đánh giá kỹ thuật, module design | Architect | `architect-role` |
| Implement backend (API, service, DB, integration) | Dev BE | `dev-be-role` |
| Implement frontend (component, UI, styling) | Dev FE | `dev-fe-role` |
| Test UI/UX, tạo test cases, report bugs | Test | `test-role` |
| Phân tích trading rules, indicators, strategy | Trade Analysis | `trade-analysis` |

## Khi task cross-role:

- Nếu task cần nhiều roles → thực hiện tuần tự, mỗi role ghi output file, role sau đọc output role trước.
- Output lưu tại: `{WORKSPACE_ROOT}/.roleSession/{SESSION_ID}/{YYYYMMDD-HHmm - tiêu đề}.md`
- Mỗi output file phải có: Input (yêu cầu), Output (kết quả), Next Role (role tiếp theo + action).
- **Khi chưa rõ yêu cầu:** kiểm tra lại các output files trước đó trong cùng session (`{WORKSPACE_ROOT}/.roleSession/{SESSION_ID}/`) để hiểu context đầy đủ. Nếu vẫn chưa rõ → hỏi user.

## Quy định Session ID:

- **SESSION_ID** đặt theo feature/logic, KHÔNG theo phiên làm việc (conversation).
- Format: `{tên-feature-kebab-case}` — ví dụ: `rule-expression-builder`, `paper-trade-flow`, `candle-chart-refactor`.
- **Trước khi tạo session mới:** kiểm tra `{WORKSPACE_ROOT}/.roleSession/` xem đã có session nào cùng feature/logic chưa. Nếu có → dùng lại session đó, KHÔNG tạo mới.
- Nhiều phiên làm việc (conversations) khác nhau có thể ghi vào cùng 1 session nếu cùng feature.
- Chỉ tạo session mới khi feature/logic thực sự khác biệt.

---

## Khi KHÔNG cần role:

- Hỏi đáp nhanh, tra cứu thông tin
- Sửa lỗi nhỏ rõ ràng (typo, 1 dòng)
- Git operations, config changes
- Câu hỏi về Claude Code / tools
