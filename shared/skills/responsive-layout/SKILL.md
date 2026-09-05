---
name: responsive-layout
description: Thiết kế và triển khai layout responsive đa thiết bị - Mobile-first, breakpoints, fluid grid, container queries.
---

# Responsive Layout

## Mobile-First Approach
Viết CSS cho mobile trước, dùng `min-width` media queries để mở rộng lên tablet/desktop.

```css
/* Mobile default */
.container { padding: 16px; }

/* Tablet+ */
@media (min-width: 768px) { .container { padding: 24px; } }

/* Desktop+ */
@media (min-width: 1024px) { .container { padding: 32px; max-width: 1280px; margin: 0 auto; } }
```

## Standard Breakpoints

| Name | Min Width | Typical Use |
|---|---|---|
| `xs` | 0 | Mobile portrait |
| `sm` | 480px | Mobile landscape |
| `md` | 768px | Tablet |
| `lg` | 1024px | Desktop |
| `xl` | 1280px | Wide desktop |
| `2xl` | 1536px | Ultra-wide |

## Layout Patterns

### Fluid Grid (CSS Grid)
```css
.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px; }
```

### Stack → Side-by-side
```css
.split { display: flex; flex-direction: column; gap: 16px; }
@media (min-width: 768px) { .split { flex-direction: row; } }
```

## Checklist
- [ ] Layout không bị overflow ngang ở bất kỳ viewport nào.
- [ ] Text không bị cắt, truncate đúng với `text-overflow: ellipsis` khi cần.
- [ ] Images responsive: `max-width: 100%; height: auto;`.
- [ ] Table trên mobile: scroll container (`overflow-x: auto`) hoặc card layout.
- [ ] Touch target tối thiểu 44x44px trên mobile.
