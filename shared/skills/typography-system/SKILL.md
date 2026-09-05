---
name: typography-system
description: Hệ thống typography - Type scale, font tokens, line-height, fluid typography và text rendering chuẩn.
---

# Typography System

## Type Scale

| Token | Size | Weight | Line Height | Use |
|---|---|---|---|---|
| `text-xs` | 12px / 0.75rem | 400 | 1.5 | Caption, label phụ |
| `text-sm` | 14px / 0.875rem | 400 | 1.5 | Body phụ, helper text |
| `text-base` | 16px / 1rem | 400 | 1.5 | Body chính |
| `text-lg` | 18px / 1.125rem | 500 | 1.4 | Sub-heading |
| `text-xl` | 20px / 1.25rem | 600 | 1.3 | Section heading |
| `text-2xl` | 24px / 1.5rem | 700 | 1.25 | Page heading |
| `text-3xl` | 30px / 1.875rem | 700 | 1.2 | Hero heading |

## Font Tokens
```css
--font-family-sans: 'Inter', system-ui, -apple-system, sans-serif;
--font-family-mono: 'JetBrains Mono', 'Fira Code', monospace;

--font-size-xs: 0.75rem;  --font-size-sm: 0.875rem;
--font-size-base: 1rem;   --font-size-lg: 1.125rem;
--font-size-xl: 1.25rem;  --font-size-2xl: 1.5rem;
--font-size-3xl: 1.875rem;

--font-weight-regular: 400;
--font-weight-medium: 500;
--font-weight-semibold: 600;
--font-weight-bold: 700;
```

## Rules
- **16px minimum** cho body text trên mobile.
- **Line-height ≥ 1.5** cho body text đảm bảo readability.
- **Letter-spacing** chỉ áp dụng cho UPPERCASE labels và headings lớn.
- **Max line-length** 60-80 characters cho body text (dùng `max-width: 65ch`).
- Heading hierarchy: `h1` duy nhất trên mỗi page; `h2-h6` theo đúng cấu trúc nội dung.
- Không dùng `<b>` hay `<i>` thô — dùng `<strong>` và `<em>` cho semantic đúng.

## Fluid Typography (optional)
```css
/* Scale tự động giữa mobile và desktop */
font-size: clamp(1rem, 2.5vw, 1.5rem);
```
