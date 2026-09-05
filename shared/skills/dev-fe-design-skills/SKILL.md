---
name: dev-fe-design-skills
description: Bộ kỹ năng triển khai UI cho Dev FE - Áp dụng Design Tokens, component variants, animation, dark/light mode và pixel-perfect rendering.
---

# Frontend Design Skills

## Core Principles
1. **Pixel-perfect từ spec:** Không tự ý điều chỉnh spacing, color, font-size so với design spec/token mà không có lý do.
2. **Dùng Design Tokens trước:** Luôn ưu tiên token (`--color-primary`, `spacing-4`, v.v.) thay vì hardcode giá trị CSS.
3. **Component-driven:** Tách thành component nhỏ, tái sử dụng được, đúng Single Responsibility.
4. **Zero raw HTML:** Sử dụng 100% shared UI components (`app-*`); không tự viết raw HTML input/button/table.

## Implementation Checklist

### Component Structure
- [ ] Props/Inputs đặt tên rõ ràng, typed đầy đủ.
- [ ] Emit/Output được document rõ event shape.
- [ ] Skeleton variant tồn tại cho loading state nếu component hiển thị async data.
- [ ] Empty state được xử lý và có UI phản hồi rõ ràng.

### Styling
- [ ] Dùng Design Token cho màu, spacing, typography, border-radius, shadow.
- [ ] Không viết `!important` trừ override đặc biệt được comment rõ lý do.
- [ ] Không dùng `:host-context`, `::ng-deep`, hoặc CSS selector xuyên component boundary.
- [ ] CSS class names theo convention của dự án (BEM / utility-first).

### Responsive
- [ ] Áp dụng đúng breakpoints đã định nghĩa trong token/theme.
- [ ] Test thủ công tại 3 viewport: 375px, 768px, 1440px.

### Dark / Light Mode
- [ ] Dùng color tokens hỗ trợ cả 2 mode.
- [ ] Không hardcode màu hex trong component CSS.

### Animation / Transition
- [ ] Duration và easing từ motion tokens.
- [ ] `prefers-reduced-motion` được tôn trọng — disable hoặc giảm animation.
