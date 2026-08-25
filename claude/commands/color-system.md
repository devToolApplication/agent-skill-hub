# Color System

Accessible color palettes, dark mode, contrast ratios, semantic color architecture.

## Khi nào dùng

- Tạo color palette cho project
- Implement dark mode
- Fix contrast/accessibility issues
- Review color usage consistency
- Thêm semantic colors mới

## Color Architecture (3 Layers)

```
Layer 1: Primitive (raw values)     → --color-blue-600: #2563eb
Layer 2: Semantic (meaning)         → --app-color-primary: var(--color-blue-600)
Layer 3: Component (scoped)         → --button-bg: var(--app-color-primary)
```

### Layer 1: Primitive Palette

```scss
:root {
  // Gray (Neutral)
  --color-gray-50: #f9fafb;
  --color-gray-100: #f3f4f6;
  --color-gray-200: #e5e7eb;
  --color-gray-300: #d1d5db;
  --color-gray-400: #9ca3af;
  --color-gray-500: #6b7280;
  --color-gray-600: #4b5563;
  --color-gray-700: #374151;
  --color-gray-800: #1f2937;
  --color-gray-900: #111827;
  --color-gray-950: #030712;

  // Blue (Primary)
  --color-blue-50: #eff6ff;
  --color-blue-100: #dbeafe;
  --color-blue-200: #bfdbfe;
  --color-blue-300: #93c5fd;
  --color-blue-400: #60a5fa;
  --color-blue-500: #3b82f6;
  --color-blue-600: #2563eb;
  --color-blue-700: #1d4ed8;
  --color-blue-800: #1e40af;
  --color-blue-900: #1e3a8a;

  // Status colors
  --color-red-500: #ef4444;
  --color-red-600: #dc2626;
  --color-green-500: #22c55e;
  --color-green-600: #16a34a;
  --color-amber-500: #f59e0b;
  --color-amber-600: #d97706;
}
```

### Layer 2: Semantic Tokens

```scss
:root {
  // Surfaces
  --app-color-surface: var(--color-gray-50);
  --app-color-surface-raised: #ffffff;
  --app-color-surface-overlay: #ffffff;
  --app-color-surface-sunken: var(--color-gray-100);

  // Text
  --app-color-on-surface: var(--color-gray-900);
  --app-color-on-surface-muted: var(--color-gray-600);
  --app-color-on-surface-subtle: var(--color-gray-400);

  // Primary
  --app-color-primary: var(--color-blue-600);
  --app-color-primary-hover: var(--color-blue-700);
  --app-color-primary-active: var(--color-blue-800);
  --app-color-on-primary: #ffffff;
  --app-color-primary-subtle: var(--color-blue-50);

  // Borders
  --app-color-border: var(--color-gray-200);
  --app-color-border-strong: var(--color-gray-300);
  --app-color-border-focus: var(--color-blue-600);

  // Status
  --app-color-error: var(--color-red-600);
  --app-color-error-subtle: #fef2f2;
  --app-color-on-error: #ffffff;

  --app-color-success: var(--color-green-600);
  --app-color-success-subtle: #f0fdf4;
  --app-color-on-success: #ffffff;

  --app-color-warning: var(--color-amber-600);
  --app-color-warning-subtle: #fffbeb;
  --app-color-on-warning: #ffffff;

  --app-color-info: var(--color-blue-600);
  --app-color-info-subtle: var(--color-blue-50);
}
```

### Dark Mode (Swap Semantic Layer)

```scss
[data-theme="dark"] {
  // Surfaces
  --app-color-surface: var(--color-gray-900);
  --app-color-surface-raised: var(--color-gray-800);
  --app-color-surface-overlay: var(--color-gray-800);
  --app-color-surface-sunken: var(--color-gray-950);

  // Text
  --app-color-on-surface: var(--color-gray-50);
  --app-color-on-surface-muted: var(--color-gray-400);
  --app-color-on-surface-subtle: var(--color-gray-500);

  // Primary (lighter in dark mode for contrast)
  --app-color-primary: var(--color-blue-400);
  --app-color-primary-hover: var(--color-blue-300);
  --app-color-primary-active: var(--color-blue-200);
  --app-color-primary-subtle: rgba(59, 130, 246, 0.15);

  // Borders
  --app-color-border: var(--color-gray-700);
  --app-color-border-strong: var(--color-gray-600);

  // Status (lighter variants for dark bg)
  --app-color-error: #f87171;
  --app-color-error-subtle: rgba(239, 68, 68, 0.15);
  --app-color-success: #4ade80;
  --app-color-success-subtle: rgba(34, 197, 94, 0.15);
  --app-color-warning: #fbbf24;
  --app-color-warning-subtle: rgba(245, 158, 11, 0.15);
}
```

## Dark Mode Implementation (Angular)

```typescript
// theme.service.ts
@Injectable({ providedIn: 'root' })
export class ThemeService {
  private readonly doc = inject(DOCUMENT);
  private readonly storageKey = 'app-theme';

  readonly theme = signal<'light' | 'dark' | 'system'>(this.getStoredTheme());
  readonly resolvedTheme = computed(() => {
    const t = this.theme();
    if (t !== 'system') return t;
    return matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  });

  constructor() {
    effect(() => {
      const resolved = this.resolvedTheme();
      this.doc.documentElement.setAttribute('data-theme', resolved);
      localStorage.setItem(this.storageKey, this.theme());
    });

    // Listen for system changes
    matchMedia('(prefers-color-scheme: dark)')
      .addEventListener('change', () => {
        if (this.theme() === 'system') {
          // Trigger recomputation
          this.theme.set('system');
        }
      });
  }

  toggle(): void {
    this.theme.update(t => t === 'dark' ? 'light' : 'dark');
  }

  private getStoredTheme(): 'light' | 'dark' | 'system' {
    return (localStorage.getItem(this.storageKey) as any) ?? 'system';
  }
}
```

## Contrast Requirements (WCAG 2.1)

| Element | Minimum Ratio | Level |
|---------|--------------|-------|
| Body text | 4.5:1 | AA |
| Large text (≥18px bold, ≥24px) | 3:1 | AA |
| UI components & graphics | 3:1 | AA |
| Body text (enhanced) | 7:1 | AAA |

```typescript
// Contrast checker utility
function getContrastRatio(fg: string, bg: string): number {
  const fgLum = relativeLuminance(hexToRgb(fg));
  const bgLum = relativeLuminance(hexToRgb(bg));
  const lighter = Math.max(fgLum, bgLum);
  const darker = Math.min(fgLum, bgLum);
  return (lighter + 0.05) / (darker + 0.05);
}

function relativeLuminance([r, g, b]: number[]): number {
  const [rs, gs, bs] = [r, g, b].map(c => {
    c /= 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
}
```

## Color Usage Patterns

```scss
// Status badges
.badge-success {
  background: var(--app-color-success-subtle);
  color: var(--app-color-success);
  border: 1px solid currentColor;
}

.badge-error {
  background: var(--app-color-error-subtle);
  color: var(--app-color-error);
  border: 1px solid currentColor;
}

// Interactive states
.interactive {
  color: var(--app-color-on-surface);
  background: var(--app-color-surface-raised);
  border: 1px solid var(--app-color-border);

  &:hover { background: var(--app-color-surface-sunken); }
  &:focus-visible { border-color: var(--app-color-border-focus); }
  &.is-active { background: var(--app-color-primary-subtle); border-color: var(--app-color-primary); }
}
```

## Rules

1. **3-layer architecture** — primitive → semantic → component
2. **Never use primitives in components** — always go through semantic layer
3. **WCAG AA minimum** — 4.5:1 text, 3:1 UI components
4. **Dark mode = swap semantic layer** — primitives stay the same
5. **Don't rely on color alone** — add icons, text, patterns for status
6. **Consistent opacity** — use `subtle` variants, not arbitrary opacity
7. **Test both themes** — every component must work in light AND dark

## Anti-patterns

- ❌ Using primitive tokens (`--color-blue-600`) directly in components
- ❌ `opacity: 0.5` for disabled — use dedicated disabled tokens
- ❌ Color as only indicator (red = error without icon/text)
- ❌ Pure black `#000` on pure white `#fff` (too harsh — use gray-900)
- ❌ Different color systems for light/dark (inconsistent brand)
- ❌ Hardcoded hex values in component styles

## Checklist

- [ ] 3-layer color architecture defined
- [ ] All text passes WCAG AA contrast (4.5:1)
- [ ] All UI components pass 3:1 contrast
- [ ] Dark mode implemented and tested
- [ ] No color-only status indicators
- [ ] Semantic tokens used everywhere (no primitives in components)
- [ ] System preference respected (prefers-color-scheme)
- [ ] Focus states visible in both themes
