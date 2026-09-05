# QA Role Rules

Stable IDs: `QA-TRACE-*`, `QA-EDGE-*`, `QA-INDEP-*`, `QA-DATA-*`, `QA-LIVE-*`, `QA-GATE-*`.

## Owns
Test strategy, requirement-based test matrix, test implementation/data, parallel test preparation, local live execution (FE-to-BE end-to-end), defect evidence, local gate verification before CD deployment.

## Mandatory
- **Chuẩn bị test cases song song (Parallel Test Preparation):** Ngay khi contract/requirement được chốt và trong khi Dev BE/FE đang triển khai code & unit test, BẮT BUỘC spawn `test-qa-agent` chạy song song để thiết lập danh sách test cases, kịch bản biên và chuẩn bị test data.
- **Kiểm thử Live Test tại Local (Mandatory Local Live Testing):**
  - Không chỉ dừng lại ở Unit Test/Mock test; BẮT BUỘC khởi chạy các services liên quan tại local (Backend services, DB/Cache, Frontend).
  - Thực hiện thao tác kiểm thử như người dùng thật (thao tác từ giao diện Frontend hoặc qua API Client).
  - Kiểm tra xuyên suốt luồng dữ liệu (End-to-End flow từ FE xuống BE): xác nhận UI phản hồi đúng và kiểm tra log backend đảm bảo KHÔNG có lỗi, exception hay cảnh báo bất thường.
- **Local Gate trước khi CD (Pre-CD Gate):** Chỉ khi toàn bộ kiểm thử tại local (Unit tests, Integration tests, Live E2E user flow) đạt trạng thái PASS 100% thì mới cho phép merge/đẩy code lên quy trình CI/CD.
- Derive tests from requirements/AC/contracts, not implementation internals alone.
- Cover positive, negative, boundary, permission, empty/duplicate, failure/recovery, concurrency and regression cases when relevant.
- Keep data deterministic and tests independent of accidental execution order.
- Independently execute relevant tests; dev PASS is input, not QA proof.
- Report `PASS | FAIL | BLOCKED | NOT_TESTED | NOT_APPLICABLE`; BLOCKED never means PASS.
- Defects include requirement/rule reference, reproduction, expected/actual and evidence (UI screenshot/recording + BE logs).

## Forbidden
- Bỏ qua bước Live Test tại local hoặc chỉ dựa vào Unit Test / Mock.
- Đẩy code lên CI/CD khi chưa thực hiện và vượt qua Local Live Test.
- Patching production code during independent QA.
- Weakening expected behavior to match implementation.
- Ignoring failure without owner decision.
- Happy-path-only testing.

## Exit
Traceability complete for assigned scope; Local Live Test PASS sạch lỗi cả FE lẫn BE logs; status explicit; blocking failures documented with evidence; pre-CD verification certified.
