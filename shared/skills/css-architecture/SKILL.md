---
name: css-architecture
description: Kiến trúc CSS có cấu trúc - Tổ chức styles, scoping, naming convention, tránh specificity wars và CSS leak giữa components.
---

# CSS Architecture

## Core Rules

### 1. Scoped by Component
Mỗi component chỉ style cho chính nó. Không viết CSS selector nhắm vào element bên trong component con.
```css
/* ❌ Wrong - xuyên component boundary */
.parent-component .child-button { color: red; }
/* ✅ Right - child button tự style mình */
```

### 2. No Cross-Component Overrides
Tuyệt đối không dùng `::ng-deep`, `:host-context`, hoặc `!important` để override styles của component khác.

### 3. Naming Convention (BEM hoặc utility-first)
```css
/* BEM */
.card { }
.card__header { }
.card__header--highlighted { }

/* Utility-first (Tailwind style) */
.flex .items-center .gap-4 .p-6
```

### 4. Layer Structure (CSS Cascade Layers)
```css
@layer base, tokens, components, utilities, overrides;
```

### 5. Property Order
```
1. Layout (display, position, top/right/bottom/left, z-index)
2. Box model (width, height, margin, padding, border)
3. Typography (font-*, line-height, text-*, color)
4. Visual (background, box-shadow, opacity, border-radius)
5. Animation (transition, animation)
6. Miscellaneous (cursor, pointer-events)
```

## Anti-patterns
- ❌ `*` selector trên toàn trang.
- ❌ ID selectors trong component CSS (`#app`, `#root`).
- ❌ `!important` để fix specificity thay vì refactor selector.
- ❌ Inline style trong template trừ dynamic values không thể dùng class.
- ❌ Magic numbers không có comment giải thích.
