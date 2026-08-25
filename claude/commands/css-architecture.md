# CSS Architecture

Tổ chức CSS scalable cho Angular projects: component styles, layers, scope, naming conventions.

## Khi nào dùng

- Setup CSS structure cho project mới
- Review/refactor CSS organization
- Fix specificity wars hoặc style leaking
- Thiết kế component styling strategy

## Layer Architecture

```scss
/* styles.scss — global entry point */
@layer reset, tokens, base, components, utilities;

@layer reset {
  /* Modern CSS reset */
  *, *::before, *::after { box-sizing: border-box; }
  * { margin: 0; }
  html { -moz-text-size-adjust: none; text-size-adjust: none; }
  body { min-height: 100dvh; line-height: 1.5; -webkit-font-smoothing: antialiased; }
  img, picture, video, canvas, svg { display: block; max-width: 100%; }
  input, button, textarea, select { font: inherit; }
  p, h1, h2, h3, h4, h5, h6 { overflow-wrap: break-word; }
}

@layer tokens {
  :root {
    /* Import all design tokens here */
    --app-color-primary: #2563eb;
    /* ... see design-tokens skill */
  }
}

@layer base {
  /* Element defaults — no classes */
  body { font-family: var(--app-font-sans); color: var(--app-color-on-surface); background: var(--app-color-surface); }
  h1, h2, h3 { line-height: var(--app-leading-tight); font-weight: var(--app-font-semibold); }
  a { color: var(--app-color-primary); text-decoration-skip-ink: auto; }
  :focus-visible { outline: 2px solid var(--app-color-primary); outline-offset: 2px; }
}

@layer components {
  /* Shared component styles — only if not using Tailwind */
}

@layer utilities {
  /* One-off utilities */
  .visually-hidden { /* sr-only equivalent */ }
}
```

## Angular Component Styles Strategy

### Rule 1: ViewEncapsulation.Emulated (default)

```typescript
@Component({
  // Mặc định — styles scoped to component
  styles: [`
    :host {
      display: block;
      /* Host styles define component's box model */
    }

    .header {
      /* Scoped — won't leak */
    }
  `]
})
```

### Rule 2: KHÔNG dùng ::ng-deep, :host-context

```typescript
// ❌ NEVER
:host-context(.dark) .card { background: black; }
::ng-deep .child-component .inner { color: red; }

// ✅ INSTEAD — dùng CSS custom properties
:host {
  --card-bg: var(--app-color-surface);
  --card-text: var(--app-color-on-surface);
}

.card {
  background: var(--card-bg);
  color: var(--card-text);
}
```

### Rule 3: Component API via CSS Custom Properties

```typescript
// Parent truyền style xuống child qua custom properties
// parent.component.html
<app-card style="--card-bg: var(--app-color-primary-50)">

// card.component.scss
:host {
  --card-bg: var(--app-color-surface); // default
  --card-padding: var(--app-space-4);  // default
}

.card {
  background: var(--card-bg);
  padding: var(--card-padding);
}
```

## File Organization

```
src/
├── styles/
│   ├── _reset.scss          // CSS reset
│   ├── _tokens.scss         // Design tokens
│   ├── _base.scss           // Element defaults
│   ├── _utilities.scss      // Utility classes
│   └── styles.scss          // Entry — imports layers
├── app/
│   └── shared/
│       └── components/
│           └── button/
│               ├── button.component.ts
│               └── button.component.scss  // Scoped styles
```

## Naming Convention

```scss
// BEM-lite cho scoped components (Angular auto-scopes, nên chỉ cần semantic names)
.card { }
.card-header { }
.card-body { }
.card-footer { }

// State classes
.is-active { }
.is-disabled { }
.is-loading { }

// Layout classes (nếu không dùng Tailwind)
.stack { display: flex; flex-direction: column; gap: var(--app-space-4); }
.cluster { display: flex; flex-wrap: wrap; gap: var(--app-space-4); }
.sidebar { display: grid; grid-template-columns: fit-content(20rem) 1fr; }
```

## Rules

1. **@layer ordering** — reset < tokens < base < components < utilities
2. **No !important** — fix specificity via layers hoặc selector structure
3. **Component styles = scoped** — dùng Angular encapsulation, KHÔNG global
4. **Custom properties for theming** — child components expose `--component-*` vars
5. **No ::ng-deep** — deprecated và breaks encapsulation
6. **No :host-context** — couples child to parent's DOM structure
7. **Logical properties** — `margin-inline`, `padding-block` thay vì `margin-left`
8. **Mobile-first media queries** — `min-width` only

## Anti-patterns

- ❌ Global styles targeting component internals
- ❌ `::ng-deep` for any reason
- ❌ `:host-context` to read parent state
- ❌ `!important` to win specificity
- ❌ Inline styles (except CSS custom property overrides)
- ❌ Deeply nested selectors (>.3 levels)
- ❌ ID selectors for styling
- ❌ `@import` without `@layer` (causes ordering issues)

## Checklist

- [ ] Layers defined và ordered correctly
- [ ] No specificity conflicts
- [ ] All component styles scoped
- [ ] Custom properties used for theming
- [ ] No deprecated Angular CSS features
- [ ] Logical properties where applicable
- [ ] Mobile-first media queries
