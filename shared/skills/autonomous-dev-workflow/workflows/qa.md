# QA Skill Workflow

```text
READ_REQUIREMENTS -> [PARALLEL_TEST_PREP] -> TEST_MATRIX -> DESIGN_TESTS -> PREPARE_DATA -> LOCAL_LIVE_EXECUTE (FE -> BE) -> SELF_REVIEW_COVERAGE -> LOCAL_GATE_CERTIFICATION (PRE-CD) -> REPORT
```

## READ_REQUIREMENTS
Load requirements/AC/contracts and `roles/qa.md`.

## PARALLEL_TEST_PREP & TEST_MATRIX
Skills: `test-strategy`, `test-case-design`.
- **Thực thi song song với Dev:** Ngay khi contract được chốt, spawn `test-qa-agent` song song với quá trình Dev code & dev-test để lên danh sách toàn diện các test case.
- Map requirement IDs to positive/negative/boundary/permission/failure/recovery/concurrency/regression coverage as applicable.

## DESIGN & PREPARE_DATA
Conditional skills: `api-testing`, `integration-testing`, `playwright-e2e-testing`, `ui-ux-testing`, `accessibility-testing`, `performance-testing`, `security-testing`, `test-data-management`.
- Chuẩn bị test data và test scripts độc lập dựa trên contract chuẩn.

## LOCAL_LIVE_EXECUTE (FE-to-BE End-to-End)
Skills: `playwright-e2e-testing`, `integration-testing`, `systematic-debugging`.
- Khởi chạy các service phụ thuộc tại local (Backend, Database/Cache, Frontend).
- Đóng vai người dùng thật: Thao tác trực tiếp từ giao diện Frontend (hoặc API client nếu không có FE).
- Theo dõi toàn bộ luồng xử lý: kiểm tra giao diện phản hồi chính xác và rà soát log Backend đảm bảo không có exception/error ẩn.

## SELF_REVIEW_COVERAGE
Skill: `verification-before-completion`.
Check AC traceability, missing edge cases, deterministic data, false positives, test-order dependence và xác nhận log backend sạch lỗi.

## LOCAL_GATE_CERTIFICATION (PRE-CD) & REPORT
- Bắt buộc kiểm tra Local Gate: Toàn bộ Unit, Integration và Local Live tests phải PASS trước khi cấp phép push/merge lên pipeline CD.
- Skill: `bug-report-writing` for failures. Use explicit PASS/FAIL/BLOCKED/NOT_TESTED/NOT_APPLICABLE statuses.
