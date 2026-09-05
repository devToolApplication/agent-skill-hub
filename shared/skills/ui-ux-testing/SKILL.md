---
name: ui-ux-testing
description: Kiểm thử UI/UX - Xác minh giao diện khớp với design spec, responsive breakpoints, contrast, accessibility và user flow.
---

# UI/UX Testing

## Scope
Xác minh visual fidelity, interaction behavior, responsive layout, accessibility compliance và end-to-end user flow.

## Checklist

### Visual & Layout
- [ ] Component render đúng với design spec (spacing, color, typography, border-radius, shadow).
- [ ] Responsive hoạt động đúng tại tất cả breakpoints: mobile (320-767px), tablet (768-1023px), desktop (1024px+).
- [ ] Không có overflow ngang bất kỳ ở viewport nào.
- [ ] Dark/Light mode chuyển đổi đúng — không có text trắng trên nền trắng hoặc ngược lại.

### Interaction & State
- [ ] Hover, focus, active, disabled, loading, error states render đúng.
- [ ] Form validation hiển thị đúng error message tại vị trí chính xác.
- [ ] Toast/Snackbar/Alert hiển thị và tự đóng đúng hành vi.
- [ ] Modal, drawer, dropdown đóng khi click ngoài hoặc nhấn Escape.

### Accessibility
- [ ] Tất cả interactive elements có thể focus bằng bàn phím theo đúng tab order.
- [ ] Color contrast ratio đạt tối thiểu 4.5:1 (WCAG AA).
- [ ] Hình ảnh có `alt` text mô tả.
- [ ] ARIA labels đặt đúng cho icons, buttons không có text.

### User Flow
- [ ] Happy path hoàn chỉnh từ đầu đến cuối không có lỗi hiển thị.
- [ ] Error path (API lỗi, validation fail) hiển thị thông báo đúng nội dung từ BE response.
- [ ] Loading state được thể hiện rõ ràng trong khi chờ dữ liệu.

## Evidence
Screenshot/recording tại mỗi breakpoint; DevTools console không có JS error; Lighthouse accessibility score ≥ 90.
