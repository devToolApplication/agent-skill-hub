# Modern CSS

Tận dụng CSS features mới nhất (2024-2026): container queries, :has(), @layer, nesting, color-mix(), subgrid, anchor positioning.

## Khi nào dùng

- Viết CSS mới và muốn dùng modern features
- Refactor legacy CSS sang modern patterns
- Review CSS code quality
- Tìm giải pháp CSS-only thay vì JS

## CSS Nesting (Native)

```scss
// Native CSS nesting — no preprocessor needed
.card {
  padding: var(--app-space-4);
  border: 1px solid var(--app-color-border);

  .card-header {
    font-weight: var(--app-font-semibold);
    margin-bottom: var(--app-space-3);
  }

  .card-body {
    color: var(--app-color-on-surface-muted);
  }

  // State with &
  &:hover {
    border-color: var(--app-color-primary);
  }

  &.is-active {
    background: var(--app-color-primary-subtle);
  }

  // Media queries nested
  @media (min-width: 768px) {
    padding: var(--app-space-6);
  }
}
```

## Container Queries

```scss
// Define containment
.widget-container {
  container-type: inline-size;
  container-name: widget;
}

// Respond to container size (not viewport)
@container widget (min-width: 400px) {
  .widget-content {
    display: grid;
    grid-template-columns: 1fr 1fr;
  }
}

@container widget (min-width: 700px) {
  .widget-content {
    grid-template-columns: 1fr 1fr 1fr;
  }
}

// Container query units
.widget-title {
  font-size: clamp(1rem, 3cqi, 1.5rem); // cqi = container query inline
}
```

## :has() Selector (Parent Selector)

```scss
// Style parent based on child state
.form-group:has(:invalid) {
  border-color: var(--app-color-error);
}

.form-group:has(:focus-visible) {
  border-color: var(--app-color-primary);
}

// Card with image vs without
.card:has(img) {
  grid-template-rows: 200px 1fr;
}

.card:not(:has(img)) {
  grid-template-rows: 1fr;
}

// Navigation with active item
nav:has(.is-active) .nav-item:not(.is-active) {
  opacity: 0.7;
}

// Empty state
.list:has(:not(.item)) .empty-state,
.list:not(:has(.item)) .empty-state {
  display: block;
}

// Quantity queries
.grid:has(> :nth-child(4)) {
  grid-template-columns: repeat(2, 1fr); // 4+ items → 2 columns
}

.grid:has(> :nth-child(7)) {
  grid-template-columns: repeat(3, 1fr); // 7+ items → 3 columns
}
```

## @layer (Cascade Layers)

```scss
// Define layer order — later layers win
@layer reset, tokens, base, components, utilities;

@layer reset {
  * { margin: 0; box-sizing: border-box; }
}

@layer base {
  a { color: var(--app-color-primary); }
}

@layer components {
  .button { /* component styles */ }
}

@layer utilities {
  .hidden { display: none; }
  .sr-only { /* screen reader only */ }
}

// Unlayered styles ALWAYS win over layered
// Use this for one-off overrides
.special-case { color: red; }
```

## color-mix()

```scss
// Mix colors at runtime — no preprocessor needed
.button:hover {
  // Darken by mixing with black
  background: color-mix(in srgb, var(--app-color-primary) 85%, black);
}

.button:active {
  background: color-mix(in srgb, var(--app-color-primary) 70%, black);
}

// Lighten
.badge {
  background: color-mix(in srgb, var(--app-color-primary) 15%, white);
  color: var(--app-color-primary);
}

// Opacity alternative (keeps color in flow)
.overlay {
  background: color-mix(in srgb, var(--app-color-on-surface) 50%, transparent);
}

// Tint/shade system
:root {
  --primary: #2563eb;
  --primary-light: color-mix(in oklch, var(--primary) 30%, white);
  --primary-dark: color-mix(in oklch, var(--primary) 70%, black);
}
```

## Subgrid

```scss
// Parent grid
.card-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: var(--app-space-4);
}

// Child inherits parent's grid tracks
.card {
  display: grid;
  grid-template-rows: subgrid;
  grid-row: span 3; // header + body + footer aligned across cards
}
```

## Anchor Positioning (Popovers, Tooltips)

```scss
// Define anchor
.trigger {
  anchor-name: --my-trigger;
}

// Position relative to anchor
.popover {
  position: fixed;
  position-anchor: --my-trigger;
  top: anchor(bottom);
  left: anchor(center);
  translate: -50% 8px;

  // Fallback positioning
  position-try-fallbacks: flip-block, flip-inline;
}
```

## Scroll Snap

```scss
// Horizontal carousel
.carousel {
  display: flex;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  scroll-padding-inline: var(--app-space-4);
  gap: var(--app-space-4);

  // Hide scrollbar
  scrollbar-width: none;
  &::-webkit-scrollbar { display: none; }

  .slide {
    scroll-snap-align: start;
    flex: 0 0 min(300px, 80vw);
  }
}

// Vertical page sections
.page-sections {
  overflow-y: auto;
  scroll-snap-type: y proximity;
  height: 100dvh;

  section {
    scroll-snap-align: start;
    min-height: 100dvh;
  }
}
```

## Logical Properties

```scss
// Physical → Logical (supports RTL)
// margin-left → margin-inline-start
// margin-right → margin-inline-end
// padding-top → padding-block-start
// width → inline-size
// height → block-size

.card {
  margin-inline: auto;
  padding-block: var(--app-space-4);
  padding-inline: var(--app-space-6);
  border-inline-start: 3px solid var(--app-color-primary);
  max-inline-size: 600px;
}
```

## @scope

```scss
// Scope styles to a subtree
@scope (.card) to (.card-footer) {
  // Styles apply inside .card but NOT inside .card-footer
  p { color: var(--app-color-on-surface-muted); }
  a { text-decoration: underline; }
}
```

## content-visibility (Performance)

```scss
// Skip rendering off-screen content
.below-fold-section {
  content-visibility: auto;
  contain-intrinsic-size: auto 500px; // estimated height
}
```

## Rules

1. **Progressive enhancement** — use `@supports` for newer features
2. **Native nesting** — no need for Sass nesting anymore
3. **Container queries for components** — media queries for page layout
4. **:has() over JS** — prefer CSS solutions for state-based styling
5. **@layer for architecture** — control cascade without specificity hacks
6. **color-mix() over opacity** — more predictable color manipulation
7. **Logical properties** — future-proof for RTL/internationalization
8. **content-visibility** — free performance for long pages

## Browser Support Check

```scss
// Always feature-detect newer features
@supports (container-type: inline-size) {
  .widget { container-type: inline-size; }
}

@supports selector(:has(*)) {
  .parent:has(.child) { /* ... */ }
}

@supports (anchor-name: --x) {
  .tooltip { /* anchor positioning */ }
}
```

## Anti-patterns

- ❌ Sass nesting when native nesting works
- ❌ JS for styling that :has() can solve
- ❌ `!important` when @layer solves cascade
- ❌ rgba() when color-mix() is cleaner
- ❌ Physical properties (margin-left) when logical works
- ❌ Using new features without @supports fallback

## Checklist

- [ ] Native nesting used (no unnecessary Sass)
- [ ] Container queries for reusable components
- [ ] :has() for parent-based styling
- [ ] @layer for cascade management
- [ ] Logical properties for spacing/sizing
- [ ] @supports for progressive enhancement
- [ ] content-visibility for long pages
- [ ] color-mix() for dynamic color variants
