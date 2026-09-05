# Codex Dedicated Subagent Routing & Enforcement

BẮT BUỘC: Khi thực hiện task phân rã hoặc spawn subagents, Codex PHẢI sử dụng trực tiếp các dedicated subagents đã được cấu hình sẵn trong `~/.codex/agents/`, TUYỆT ĐỐI KHÔNG tự tạo agent tự do hoặc dùng generic subagent.

## Danh sách Dedicated Subagents có sẵn

| Subagent Name | Role | Primary Use Case |
|---|---|---|
| `ba-agent` | Business Analyst | Phân tích yêu cầu, bóc tách User Story, Acceptance Criteria, Functional Spec |
| `architect-agent` | Solution / System Architect | Thiết kế kiến trúc, Module folder layout, API Contracts, 2-3 phương án & Trade-off, ADR |
| `dev-be-agent` | Backend Developer | Code Java/Spring Boot/Node/Go/Python, DB query, TDD, Clean Code, SRP, xử lý lỗi |
| `dev-fe-agent` | Frontend Developer | Code Angular/React/Vue, UI components, responsive layout, styling, token system |
| `test-qa-agent` | QA / Test Engineer | Lên test case song song, Local Live Test (chạy service, test FE->BE), Pre-CD Gate |
| `bpmn-agent` | BPMN Specialist | Thiết kế, thẩm định và ánh xạ luồng BPMN 2.0 |
| `trade-analysis-agent` | Trading Specialist | Phân tích quy tắc giao dịch, chỉ báo kỹ thuật, rule engine, risk management |

## Quy định Spawn Subagent trong Codex

1. **Chỉ định rõ Subagent:** Khi gọi subtask/spawn agent, phải chỉ định chính xác tên subagent: `ba-agent`, `architect-agent`, `dev-be-agent`, `dev-fe-agent`, `test-qa-agent`, `bpmn-agent`, `trade-analysis-agent`.
2. **Không tự tạo prompt agent mới:** Không định nghĩa lại system prompt mới từ đầu cho subagent; subagent sẽ tự động load cấu hình trong `~/.codex/agents/{name}.toml`.
3. **Truyền đúng context:** Cung cấp input đầu vào rõ ràng (task ID, requirements, contract, files liên quan, expected output) để agent thực thi độc lập.
