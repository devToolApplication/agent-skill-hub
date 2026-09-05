---
name: color-system
description: Xây dựng và áp dụng hệ thống màu sắc - Palette, semantic colors, dark/light mode, contrast compliance.
---

# Color System

## Structure: Primitive → Semantic → Component

```
Primitive (raw values):    blue-500: #3b82f6
         ↓
Semantic (role-based):     color-primary: blue-500
                           color-surface: white / gray-950 (dark)
                           color-on-primary: white
         ↓
Component:                 button-bg: color-primary
                           button-text: color-on-primary
```

## Palette Definition

### Primary (Brand)
```css
--blue-50: #eff6ff;  --blue-100: #dbeafe; --blue-200: #bfdbfe;
--blue-500: #3b82f6; --blue-600: #2563eb; --blue-700: #1d4ed8;
--blue-900: #1e3a8a;
```

### Neutral (Surface / Text)
```css
--gray-50: #f9fafb;  --gray-100: #f3f4f6; --gray-200: #e5e7eb;
--gray-400: #9ca3af; --gray-600: #4b5563; --gray-700: #374151;
--gray-900: #111827; --gray-950: #030712;
```

### Semantic (light mode default)
```css
:root {
  --color-surface: var(--gray-50);
  --color-surface-raised: #ffffff;
  --color-on-surface: var(--gray-900);
  --color-on-surface-muted: var(--gray-600);
  --color-primary: var(--blue-600);
  --color-on-primary: #ffffff;
  --color-border: var(--gray-200);
  --color-error: #dc2626;
  --color-success: #16a34a;
  --color-warning: #d97706;
}
```

### Dark mode override
```css
[data-theme="dark"] {
  --color-surface: var(--gray-950);
  --color-surface-raised: var(--gray-900);
  --color-on-surface: var(--gray-50);
  --color-on-surface-muted: var(--gray-400);
  --color-primary: var(--blue-400);
  --color-border: var(--gray-700);
}
```

## Rules
- Luôn dùng semantic tokens trong component; primitive chỉ dùng khi định nghĩa semantic.
- Kiểm tra contrast ratio trước khi finalize bất kỳ color pair nào.
- Không thêm màu mới vào system mà không có semantic token mapping rõ ràng.
