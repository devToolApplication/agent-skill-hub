# Design Tokens

Quản lý design tokens (color, spacing, typography, elevation, border-radius, shadow) để đảm bảo consistency giữa design và code.

## Khi nào dùng

- Tạo hoặc sửa theme/tokens
- Setup design system mới
- Sync tokens giữa Figma và code
- Review token usage consistency

## Token Categories

### 1. Color Tokens

```scss
// Semantic (dùng trong code)
--app-color-primary: var(--app-color-blue-600);
--app-color-on-primary: var(--app-color-white);
--app-color-surface: var(--app-color-gray-50);
--app-color-on-surface: var(--app-color-gray-900);
--app-color-error: var(--app-color-red-600);
--app-color-success: var(--app-color-green-600);
--app-color-warning: var(--app-color-amber-600);

// Reference (base palette — KHÔNG dùng trực tiếp trong components)
--app-color-blue-50 ... --app-color-blue-900
--app-color-gray-50 ... --app-color-gray-900
```

### 2. Spacing Tokens

```scss
// 4px base unit system
--app-space-0: 0;
--app-space-1: 0.25rem;  // 4px
--app-space-2: 0.5rem;   // 8px
--app-space-3: 0.75rem;  // 12px
--app-space-4: 1rem;     // 16px
--app-space-5: 1.25rem;  // 20px
--app-space-6: 1.5rem;   // 24px
--app-space-8: 2rem;     // 32px
--app-space-10: 2.5rem;  // 40px
--app-space-12: 3rem;    // 48px
--app-space-16: 4rem;    // 64px
```

### 3. Typography Tokens

```scss
// Font family
--app-font-sans: 'Inter', system-ui, -apple-system, sans-serif;
--app-font-mono: 'JetBrains Mono', 'Fira Code', monospace;

// Font size (fluid scale)
--app-text-xs: clamp(0.7rem, 0.65rem + 0.25vw, 0.75rem);
--app-text-sm: clamp(0.8rem, 0.75rem + 0.25vw, 0.875rem);
--app-text-base: clamp(0.9rem, 0.85rem + 0.25vw, 1rem);
--app-text-lg: clamp(1.05rem, 0.95rem + 0.5vw, 1.125rem);
--app-text-xl: clamp(1.15rem, 1rem + 0.75vw, 1.25rem);
--app-text-2xl: clamp(1.4rem, 1.15rem + 1.25vw, 1.5rem);
--app-text-3xl: clamp(1.7rem, 1.3rem + 2vw, 1.875rem);

// Line height
--app-leading-tight: 1.25;
--app-leading-normal: 1.5;
--app-leading-relaxed: 1.75;

// Font weight
--app-font-regular: 400;
--app-font-medium: 500;
--app-font-semibold: 600;
--app-font-bold: 700;
```

### 4. Elevation (Shadow) Tokens

```scss
--app-shadow-xs: 0 1px 2px rgb(0 0 0 / 0.05);
--app-shadow-sm: 0 1px 3px rgb(0 0 0 / 0.1), 0 1px 2px rgb(0 0 0 / 0.06);
--app-shadow-md: 0 4px 6px rgb(0 0 0 / 0.1), 0 2px 4px rgb(0 0 0 / 0.06);
--app-shadow-lg: 0 10px 15px rgb(0 0 0 / 0.1), 0 4px 6px rgb(0 0 0 / 0.05);
--app-shadow-xl: 0 20px 25px rgb(0 0 0 / 0.1), 0 8px 10px rgb(0 0 0 / 0.04);
```

### 5. Border Radius Tokens

```scss
--app-radius-none: 0;
--app-radius-sm: 0.25rem;   // 4px
--app-radius-md: 0.375rem;  // 6px
--app-radius-lg: 0.5rem;    // 8px
--app-radius-xl: 0.75rem;   // 12px
--app-radius-2xl: 1rem;     // 16px
--app-radius-full: 9999px;
```

### 6. Transition Tokens

```scss
--app-duration-fast: 150ms;
--app-duration-normal: 250ms;
--app-duration-slow: 350ms;
--app-ease-default: cubic-bezier(0.4, 0, 0.2, 1);
--app-ease-in: cubic-bezier(0.4, 0, 1, 1);
--app-ease-out: cubic-bezier(0, 0, 0.2, 1);
--app-ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
```

## Rules

1. **KHÔNG hardcode values** — luôn dùng token variables
2. **Semantic over reference** — dùng `--app-color-primary` thay vì `--app-color-blue-600`
3. **Dark mode via semantic tokens** — chỉ cần swap semantic layer, reference layer giữ nguyên
4. **Prefix `--app-`** cho tất cả tokens để tránh conflict
5. **4px grid** — mọi spacing phải là bội số của 4px
6. **Fluid typography** — dùng `clamp()` cho responsive text sizing

## Dark Mode Pattern

```scss
:root {
  --app-color-surface: var(--app-color-white);
  --app-color-on-surface: var(--app-color-gray-900);
  --app-color-border: var(--app-color-gray-200);
}

[data-theme="dark"] {
  --app-color-surface: var(--app-color-gray-900);
  --app-color-on-surface: var(--app-color-gray-50);
  --app-color-border: var(--app-color-gray-700);
}
```

## Integration với Angular

```typescript
// tokens.service.ts — nếu cần dynamic tokens
@Injectable({ providedIn: 'root' })
export class TokensService {
  private readonly doc = inject(DOCUMENT);

  setToken(name: string, value: string): void {
    this.doc.documentElement.style.setProperty(`--app-${name}`, value);
  }

  getToken(name: string): string {
    return getComputedStyle(this.doc.documentElement)
      .getPropertyValue(`--app-${name}`).trim();
  }
}
```

## Checklist

- [ ] Tất cả colors dùng semantic tokens
- [ ] Spacing theo 4px grid
- [ ] Typography dùng fluid scale
- [ ] Dark mode hoạt động đúng
- [ ] Không có magic numbers trong CSS
- [ ] Tokens documented trong design system docs
