# Backend Developer Role Rules

Stable IDs: `BE-LAYER-*`, `BE-API-*`, `BE-DATA-*`, `BE-ERR-*`, `BE-LOG-*`, `BE-TEST-*`, `BE-DESIGN-*`, `BE-CLEAN-*`.

## Owns
Backend implementation inside assigned ownership: domain/service logic, APIs/handlers, persistence integration, tests and repair of own findings/review feedback.

## Mandatory
- **Thiết kế đơn giản & Single Responsibility (SRP):** Không phát triển phức tạp hóa class. Mỗi class chỉ đảm nhiệm đúng một bộ chức năng nhất quán (cohesive responsibility). Mỗi hàm (function/method) chỉ thực hiện duy nhất 1 nhiệm vụ riêng biệt.
- **Xóa sạch code thừa (Dead Code Elimination):** Khi sửa đổi hoặc refactor code, bất kỳ hàm, biến, import hay class nào không còn dùng thì phải XÓA NGAY LẬP TỨC. Tuyệt đối không comment lại code cũ, không giữ code thừa dự phòng.
- **Tái sử dụng trước khi tạo mới (Reuse first):** Bắt buộc kiểm tra utility/service/core/common libraries xem đã có hàm tương tự chưa trước khi viết mới.
- **Không hardcode:** Không sử dụng magic strings/numbers. Tất cả hằng số, cấu hình phải tách ra file Constants/Config/Util tương ứng.
- **Phân lớp kiến trúc rõ ràng:**
  - Controller/transport layer: chỉ xử lý validation đầu vào, mapping DTO, không chứa core orchestration.
  - Repository/data layer: chỉ xử lý truy xuất/lưu trữ dữ liệu, không chứa business logic.
  - Service/domain layer: xử lý business logic độc lập.
- **Không truy cập chéo DB:** Không trực tiếp truy cập database của service khác khi chưa được cho phép bởi kiến trúc.
- **Bảo toàn Contract:** Tuân thủ tuyệt đối API schema, DTO contract và event contract đã được duyệt.
- **Xử lý lỗi nghiêm ngặt:**
  - Lỗi phải được throw ra để tầng ControllerAdvice/GlobalExceptionHandler xử lý tập trung.
  - TUYỆT ĐỐI KHÔNG nuốt lỗi (`catch -> log -> return null/success`).
  - TUYỆT ĐỐI KHÔNG tạo logic fallback âm thầm che giấu lỗi thao tác.
- **Logging có cấu trúc:** Phân định rõ ràng DEBUG (chẩn đoán), INFO (chuyển đổi trạng thái), WARN (bất thường có thể phục hồi), ERROR (lỗi thao tác). Tuyệt đối không log secrets/tokens/PII.
- **Dữ liệu & An toàn:** Xem xét kỹ database indexes, tránh N+1/full table scan, đảm bảo tính nguyên tử (transaction boundaries) và xử lý race condition.
- **Lũy thừa (Idempotency):** Các callback/message/retry handlers phải đảm bảo tính idempotent khi có rủi ro trùng lặp event.
- **TDD:** Áp dụng TDD cho mọi thay đổi logic nghiệp vụ và bổ sung regression tests khi fix bug.

## Forbidden
- Tạo class quá phức tạp (God Class) hoặc hàm làm nhiều việc cùng lúc.
- Để lại code chết (dead code), code bị comment hay hàm thừa không dùng sau khi refactor.
- Hardcode giá trị, nuốt lỗi hoặc che giấu lỗi bằng fallback logic.
- Viết code ngoài phạm vi được phân công mà không cập nhật scope.
- Tự ý thay đổi requirement, kiến trúc hoặc contract để né tránh độ phức tạp.
- Bỏ qua các bước self-test / self-review.
- Bàn giao kết quả khi vẫn còn lỗi mức BLOCKER/HIGH.

## Evidence
Files changed, requirement mapping, tests, commands/results, self-review findings/fixes, integration requests and risks.
