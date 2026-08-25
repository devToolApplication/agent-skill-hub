# Tailwind CSS Design System

Best practices cho Tailwind CSS: custom theme config, component patterns, utility-first workflow.

## Khi nào dùng

- Setup hoặc extend Tailwind theme
- Tạo component patterns với Tailwind
- Optimize Tailwind usage (purge, JIT)
- Review Tailwind code quality

## Theme Configuration

```javascript
// tailwind.config.js
export default {
  content: ['./src/**/*.{html,ts}'],
  theme: {
    extend: {
      colors: {
        primary: {
          50: 'var(--app-color-primary-50)',
          100: 'var(--app-color-primary-100)',
          // ... map to CSS custom properties for runtime theming
          600: 'var(--app-color-primary-600)',
          700: 'var(--app-color-primary-700)',
        },
        surface: 'var(--app-color-surface)',
        'on-surface': 'var(--app-color-on-surface)',
      },
      spacing: {
        // Extend with app-specific spacing if needed
        '18': '4.5rem',
        '88': '22rem',
      },
      borderRadius: {
        'app': 'var(--app-radius-lg)',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
        mono: ['JetBrains Mono', 'Fira Code', 'monospace'],
      },
      fontSize: {
        // Fluid type scale
        'fluid-sm': 'clamp(0.8rem, 0.75rem + 0.25vw, 0.875rem)',
        'fluid-base': 'clamp(0.9rem, 0.85rem + 0.25vw, 1rem)',
        'fluid-lg': 'clamp(1.05rem, 0.95rem + 0.5vw, 1.125rem)',
        'fluid-xl': 'clamp(1.15rem, 1rem + 0.75vw, 1.25rem)',
        'fluid-2xl': 'clamp(1.4rem, 1.15rem + 1.25vw, 1.5rem)',
      },
      animation: {
        'fade-in': 'fadeIn var(--app-duration-normal) var(--app-ease-out)',
        'slide-up': 'slideUp var(--app-duration-normal) var(--app-ease-out)',
        'scale-in': 'scaleIn var(--app-duration-fast) var(--app-ease-spring)',
      },
      keyframes: {
        fadeIn: { from: { opacity: '0' }, to: { opacity: '1' } },
        slideUp: { from: { transform: 'translateY(8px)', opacity: '0' }, to: { transform: 'translateY(0)', opacity: '1' } },
        scaleIn: { from: { transform: 'scale(0.95)', opacity: '0' }, to: { transform: 'scale(1)', opacity: '1' } },
      },
    },
  },
  plugins: [],
}
```

## Component Patterns

### Pattern 1: Base + Variant (CVA-style)

```typescript
// Trong Angular component — dùng class composition
type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger';
type ButtonSize = 'sm' | 'md' | 'lg';

const buttonBase = 'inline-flex items-center justify-center font-medium rounded-app transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-600 disabled:opacity-50 disabled:pointer-events-none';

const buttonVariants: Record<ButtonVariant, string> = {
  primary: 'bg-primary-600 text-white hover:bg-primary-700 active:bg-primary-800',
  secondary: 'bg-surface border border-gray-300 text-on-surface hover:bg-gray-50 active:bg-gray-100',
  ghost: 'text-on-surface hover:bg-gray-100 active:bg-gray-200',
  danger: 'bg-red-600 text-white hover:bg-red-700 active:bg-red-800',
};

const buttonSizes: Record<ButtonSize, string> = {
  sm: 'h-8 px-3 text-sm gap-1.5',
  md: 'h-10 px-4 text-sm gap-2',
  lg: 'h-12 px-6 text-base gap-2.5',
};
```

### Pattern 2: Responsive Layout

```html
<!-- Mobile-first responsive card grid -->
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 p-4">
  <article class="bg-surface rounded-app shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow">
    <img class="w-full h-48 object-cover" />
    <div class="p-4 space-y-2">
      <h3 class="text-fluid-lg font-semibold text-on-surface line-clamp-2">Title</h3>
      <p class="text-sm text-gray-600 line-clamp-3">Description</p>
    </div>
  </article>
</div>
```

### Pattern 3: Dark Mode

```html
<!-- Dùng class strategy cho Angular -->
<div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-50">
  <div class="border-gray-200 dark:border-gray-700">
    <!-- content -->
  </div>
</div>
```

## Rules

1. **Utility-first** — viết utilities trước, extract component class chỉ khi lặp >3 lần
2. **Không @apply trong component styles** — dùng class binding trong template
3. **Responsive mobile-first** — `sm:` `md:` `lg:` `xl:` theo thứ tự
4. **Semantic color names** — `primary`, `surface`, `on-surface` thay vì `blue-600`
5. **Consistent spacing** — dùng scale mặc định (4, 8, 12, 16, 24, 32, 48, 64)
6. **Group hover/focus states** — `group-hover:`, `peer-checked:` cho interactive patterns
7. **Avoid arbitrary values** — `w-[347px]` là code smell, extend theme thay vì arbitrary

## Anti-patterns

- ❌ `@apply` everywhere — defeats purpose of utility-first
- ❌ `!important` via `!` prefix — fix specificity issue at source
- ❌ Mixing Tailwind + custom CSS cho cùng property
- ❌ Arbitrary values `[123px]` thay vì extend theme
- ❌ Quá nhiều utilities trên 1 element (>10) — extract component

## Angular Integration

```typescript
// Dùng với Angular class binding
@Component({
  template: `
    <button
      [class]="buttonClasses()"
      [disabled]="disabled()">
      <ng-content />
    </button>
  `
})
export class AppButtonComponent {
  variant = input<ButtonVariant>('primary');
  size = input<ButtonSize>('md');
  disabled = input(false);

  buttonClasses = computed(() =>
    [buttonBase, buttonVariants[this.variant()], buttonSizes[this.size()]].join(' ')
  );
}
```

## Checklist

- [ ] Theme extends design tokens (CSS custom properties)
- [ ] Mobile-first responsive
- [ ] Dark mode support
- [ ] No arbitrary values without justification
- [ ] Consistent spacing scale
- [ ] Accessible focus states on all interactive elements
- [ ] PurgeCSS/content config covers all template files
