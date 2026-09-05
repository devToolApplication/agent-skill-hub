---
name: design-tokens
description: Định nghĩa và sử dụng Design Tokens - Color, spacing, typography, border-radius, shadow, motion tokens trong hệ thống UI.
---

# Design Tokens

## What
Design Token là các biến đặt tên cho các giá trị thiết kế (màu, khoảng cách, font, v.v.) để dùng nhất quán toàn hệ thống và hỗ trợ theming (dark/light mode, branding).

## Categories

### Color Tokens
```css
--color-primary-50: #eff6ff;
--color-primary-500: #3b82f6;   /* Main brand */
--color-primary-900: #1e3a8a;

--color-surface: #ffffff;        /* Background */
--color-on-surface: #111827;    /* Text on surface */
--color-error: #ef4444;
--color-success: #22c55e;
```

### Spacing Tokens
```css
--spacing-1: 4px;   --spacing-2: 8px;   --spacing-3: 12px;
--spacing-4: 16px;  --spacing-6: 24px;  --spacing-8: 32px;
--spacing-12: 48px; --spacing-16: 64px;
```

### Typography Tokens
```css
--font-size-xs: 0.75rem;   --font-size-sm: 0.875rem;
--font-size-base: 1rem;    --font-size-lg: 1.125rem;
--font-size-xl: 1.25rem;   --font-size-2xl: 1.5rem;
--font-weight-regular: 400; --font-weight-medium: 500; --font-weight-bold: 700;
--line-height-tight: 1.25; --line-height-normal: 1.5; --line-height-relaxed: 1.75;
```

### Shape & Effect Tokens
```css
--radius-sm: 4px; --radius-md: 8px; --radius-lg: 12px; --radius-full: 9999px;
--shadow-sm: 0 1px 2px rgba(0,0,0,.05);
--shadow-md: 0 4px 6px -1px rgba(0,0,0,.1);
--shadow-lg: 0 10px 15px -3px rgba(0,0,0,.1);
```

### Motion Tokens
```css
--duration-fast: 100ms;  --duration-normal: 200ms;  --duration-slow: 300ms;
--ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
--ease-out: cubic-bezier(0, 0, 0.2, 1);
```

## Rules
- **Chỉ dùng tokens** trong component CSS — không hardcode `#3b82f6` hay `16px` trực tiếp.
- **Semantic over primitive:** Dùng `--color-primary` thay vì `--color-blue-500` trong component.
- **Dark mode:** Override semantic tokens trong `[data-theme="dark"]` scope, không override từng component riêng lẻ.
