---
name: accessibility-testing
description: Kiểm thử Accessibility (a11y) - Keyboard navigation, screen reader, color contrast, ARIA, WCAG AA compliance.
---

# Accessibility Testing

## Standard: WCAG 2.1 Level AA

## Checklist

### Keyboard Navigation
- [ ] Tab qua tất cả interactive elements theo thứ tự logic (trái → phải, trên → dưới).
- [ ] Focus indicator luôn hiển thị — không bị ẩn bởi `outline: none` mà không có alternative.
- [ ] Modal/Dialog: Focus bị trap bên trong khi mở; trả focus về trigger element khi đóng.
- [ ] Dropdown/Menu: Arrow keys điều hướng, Escape đóng.
- [ ] Không có keyboard trap không mong muốn.

### Screen Reader (NVDA / VoiceOver)
- [ ] Headings có thứ tự đúng: `h1` → `h2` → `h3`, không skip level.
- [ ] Landmark roles: `<main>`, `<nav>`, `<header>`, `<footer>`, `<aside>`.
- [ ] Icon-only buttons có `aria-label` hoặc `<span class="sr-only">`.
- [ ] Images có `alt` text mô tả; decorative images có `alt=""`.
- [ ] Form inputs có `<label>` gắn đúng hoặc `aria-label`/`aria-labelledby`.
- [ ] Error messages được announce qua `aria-live="polite"` hoặc `role="alert"`.
- [ ] Dynamic content (toast, spinner) được announce đúng.

### Color & Contrast
- [ ] Text thường (< 18px): contrast ratio ≥ 4.5:1.
- [ ] Text lớn (≥ 18px hoặc ≥ 14px bold): contrast ratio ≥ 3:1.
- [ ] UI components (border, icon): contrast ratio ≥ 3:1 với background.
- [ ] Thông tin không truyền tải chỉ qua màu sắc (có icon/text kèm theo).

### Touch & Motion
- [ ] Touch target ≥ 44x44px.
- [ ] Animation tôn trọng `prefers-reduced-motion`.

## Tools
- Chrome DevTools → Lighthouse Accessibility audit (score ≥ 90).
- axe DevTools browser extension.
- Thủ công: keyboard-only navigation test.
