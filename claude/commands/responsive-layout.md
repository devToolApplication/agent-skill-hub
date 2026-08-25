# Responsive Layout

Mobile-first patterns, container queries, fluid typography, breakpoint strategy.

## Khi nào dùng

- Thiết kế layout responsive cho page/component mới
- Fix layout bể trên mobile/tablet
- Setup breakpoint system
- Review responsive behavior

## Breakpoint Strategy (Mobile-First)

```scss
// Breakpoints — chỉ dùng min-width
$breakpoints: (
  sm: 640px,   // Large phone landscape
  md: 768px,   // Tablet portrait
  lg: 1024px,  // Tablet landscape / small desktop
  xl: 1280px,  // Desktop
  2xl: 1536px, // Large desktop
);

// Usage
.container {
  padding-inline: var(--app-space-4);

  @media (min-width: 640px) { padding-inline: var(--app-space-6); }
  @media (min-width: 1024px) { padding-inline: var(--app-space-8); }
}
```

## Container Queries (Component-Level Responsive)

```scss
// Parent defines containment
.card-grid {
  container-type: inline-size;
  container-name: card-grid;
}

// Child responds to container, not viewport
@container card-grid (min-width: 400px) {
  .card { grid-template-columns: auto 1fr; }
}

@container card-grid (min-width: 700px) {
  .card { grid-template-columns: 200px 1fr auto; }
}
```

```html
<!-- Angular component using container queries -->
<div class="card-grid">
  @for (item of items(); track item.id) {
    <app-card [data]="item" />
  }
</div>
```

## Layout Patterns

### Pattern 1: Fluid Container

```scss
.page-container {
  width: min(100% - var(--app-space-8), 1200px);
  margin-inline: auto;
}
```

### Pattern 2: Responsive Grid (Auto-fit)

```scss
// Cards tự wrap — không cần media queries
.auto-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(280px, 100%), 1fr));
  gap: var(--app-space-4);
}
```

### Pattern 3: Sidebar Layout

```scss
// Sidebar collapses on small screens
.with-sidebar {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--app-space-6);

  @media (min-width: 1024px) {
    grid-template-columns: 280px 1fr;
  }
}
```

### Pattern 4: Holy Grail (Header + Main + Footer)

```scss
.app-layout {
  display: grid;
  grid-template-rows: auto 1fr auto;
  min-height: 100dvh;
}
```

### Pattern 5: Responsive Stack → Row

```scss
// Stack on mobile, row on desktop
.stack-to-row {
  display: flex;
  flex-direction: column;
  gap: var(--app-space-4);

  @media (min-width: 768px) {
    flex-direction: row;
    align-items: center;
  }
}
```

### Pattern 6: Responsive Table → Cards

```html
<!-- Table on desktop, cards on mobile -->
<div class="responsive-table">
  @for (row of data(); track row.id) {
    <div class="table-row">
      <span class="cell" data-label="Name">{{ row.name }}</span>
      <span class="cell" data-label="Status">{{ row.status }}</span>
    </div>
  }
</div>
```

```scss
.responsive-table {
  .table-row {
    display: grid;
    grid-template-columns: 1fr;
    gap: var(--app-space-2);
    padding: var(--app-space-4);
    border-bottom: 1px solid var(--app-color-border);

    @media (min-width: 768px) {
      grid-template-columns: 2fr 1fr 1fr auto;
      align-items: center;
    }
  }

  .cell::before {
    content: attr(data-label);
    font-weight: var(--app-font-semibold);
    @media (min-width: 768px) { display: none; }
  }
}
```

## Fluid Typography

```scss
// Dùng clamp() — no media queries needed
h1 { font-size: clamp(1.75rem, 1.2rem + 2.5vw, 2.5rem); }
h2 { font-size: clamp(1.4rem, 1.1rem + 1.5vw, 1.875rem); }
h3 { font-size: clamp(1.15rem, 1rem + 0.75vw, 1.5rem); }
body { font-size: clamp(0.9rem, 0.85rem + 0.25vw, 1rem); }
```

## Responsive Spacing

```scss
// Fluid spacing with clamp
.section {
  padding-block: clamp(var(--app-space-8), 5vw, var(--app-space-16));
}

.card {
  padding: clamp(var(--app-space-3), 3vw, var(--app-space-6));
}
```

## Rules

1. **Mobile-first** — base styles = mobile, add complexity with `min-width`
2. **Container queries > media queries** cho components — components không nên biết viewport
3. **Fluid values** — dùng `clamp()`, `min()`, `max()` thay vì nhiều breakpoints
4. **`min()` for max-width** — `width: min(100%, 1200px)` thay vì `max-width` + `width: 100%`
5. **`dvh` over `vh`** — `100dvh` handles mobile browser chrome
6. **No fixed heights** — dùng `min-height` nếu cần
7. **Logical properties** — `margin-inline`, `padding-block` cho RTL support
8. **Test at content breakpoints** — không chỉ device breakpoints

## Anti-patterns

- ❌ `max-width` media queries (desktop-first)
- ❌ Fixed pixel widths cho layout containers
- ❌ `height: 100vh` (fails on mobile browsers)
- ❌ Hiding content with `display: none` on mobile (load but hide = waste)
- ❌ Separate mobile/desktop templates — dùng responsive CSS thay vì `@if (isMobile)`
- ❌ Breakpoints based on devices — breakpoints based on content

## Checklist

- [ ] Base styles work on 320px viewport
- [ ] No horizontal scroll at any viewport
- [ ] Touch targets ≥ 44x44px on mobile
- [ ] Text readable without zoom (≥16px body)
- [ ] Images responsive (max-width: 100%)
- [ ] Container queries for reusable components
- [ ] Tested on real devices (not just DevTools)
