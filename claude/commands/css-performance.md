# CSS Performance

Critical CSS, content-visibility, will-change, paint containment, rendering optimization.

## Khi nào dùng

- Optimize rendering performance
- Fix jank/stuttering animations
- Reduce paint/layout costs
- Improve LCP/CLS/INP metrics
- Audit CSS performance

## Rendering Pipeline

```
Style → Layout → Paint → Composite
  ↓        ↓       ↓        ↓
 Fast    Expensive Expensive  Fast (GPU)
```

**Goal:** Keep animations in Composite layer (transform, opacity only)

## Critical CSS (Above-the-fold)

```html
<!-- Inline critical CSS in <head> -->
<style>
  /* Only styles needed for first viewport render */
  body { font-family: system-ui; margin: 0; }
  .header { height: 64px; display: flex; align-items: center; }
  .hero { min-height: 50vh; display: grid; place-items: center; }
</style>

<!-- Defer non-critical CSS -->
<link rel="preload" href="/styles.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet" href="/styles.css"></noscript>
```

```typescript
// Angular — inline critical CSS via SSR
// angular.json
{
  "architect": {
    "build": {
      "options": {
        "inlineCriticalCss": true // Angular CLI handles this
      }
    }
  }
}
```

## content-visibility

```scss
// Skip rendering for off-screen sections
.page-section {
  content-visibility: auto;
  contain-intrinsic-size: auto 600px; // estimated height to prevent CLS
}

// Cards in a long list
.card-list .card:nth-child(n+5) {
  content-visibility: auto;
  contain-intrinsic-block-size: auto 300px;
}

// Never use on above-fold content
// ❌ .hero { content-visibility: auto; } — delays LCP
```

## CSS Containment

```scss
// contain: layout — element doesn't affect outside layout
// contain: paint — element doesn't paint outside its box
// contain: size — element's size doesn't depend on children
// contain: style — counters/quotes scoped to subtree

// Common patterns:
.widget {
  contain: layout paint; // Independent rendering island
}

.fixed-size-widget {
  contain: strict; // = size + layout + paint + style (most aggressive)
}

// Container queries require containment
.container {
  container-type: inline-size; // Implicitly adds contain: inline-size layout style
}
```

## will-change (Use Sparingly)

```scss
// ✅ Apply BEFORE animation starts, remove after
.card {
  transition: transform 200ms ease-out;
}

.card:hover {
  will-change: transform; // Hint to browser
  transform: translateY(-2px);
}

// ✅ For elements that WILL animate (known ahead of time)
.modal-overlay {
  will-change: opacity; // Will fade in/out
}

// ❌ NEVER apply to everything
// * { will-change: transform; } — wastes GPU memory

// ❌ NEVER leave permanently on static elements
// .static-card { will-change: transform; } — no benefit, wastes resources
```

## GPU-Accelerated Properties

```scss
// ✅ Composite-only (GPU, no repaint)
.animate-good {
  transform: translateX(100px);
  opacity: 0.5;
  filter: blur(4px);
}

// ❌ Triggers Layout + Paint (expensive)
.animate-bad {
  width: 200px;      // Layout
  height: 100px;     // Layout
  top: 50px;         // Layout
  left: 100px;       // Layout
  margin: 10px;      // Layout
  padding: 20px;     // Layout
  border-width: 2px; // Layout
}

// ❌ Triggers Paint (medium cost)
.animate-medium {
  background-color: red;  // Paint
  color: blue;            // Paint
  box-shadow: 0 2px 4px;  // Paint
  border-color: green;    // Paint
}
```

## Reduce Layout Thrashing

```scss
// ✅ Use transform instead of position changes
.slide-in {
  transform: translateX(0);
  transition: transform 300ms ease-out;

  &.is-hidden {
    transform: translateX(-100%);
  }
}

// ❌ Don't animate left/top
.slide-in-bad {
  left: 0;
  transition: left 300ms;

  &.is-hidden { left: -100%; }
}

// ✅ Expand/collapse with grid (no height animation)
.collapsible {
  display: grid;
  grid-template-rows: 0fr;
  transition: grid-template-rows 250ms ease;

  &.is-open { grid-template-rows: 1fr; }
  .content { overflow: hidden; }
}

// ❌ Don't animate height
.collapsible-bad {
  height: 0;
  transition: height 250ms;
  &.is-open { height: auto; } // doesn't even work with auto
}
```

## Font Performance

```scss
// Prevent FOIT (Flash of Invisible Text)
@font-face {
  font-family: 'Inter';
  src: url('/fonts/inter-var.woff2') format('woff2');
  font-display: swap; // Show fallback immediately
  unicode-range: U+0000-00FF; // Only load Latin subset initially
}

// Reduce CLS from font swap
@font-face {
  font-family: 'Inter Fallback';
  src: local('Arial');
  size-adjust: 107%;
  ascent-override: 90%;
  descent-override: 22%;
  line-gap-override: 0%;
}
```

## Selector Performance

```scss
// ✅ Fast selectors (right to left matching)
.card { }
.card-header { }
.button.primary { }

// ⚠️ Slower (but usually fine in modern browsers)
.card > .header > .title { }
.sidebar .nav .item { }

// ❌ Avoid universal in middle of selector
.card * .text { } // Matches every element, then checks ancestors

// ❌ Avoid attribute selectors on high-frequency elements
div[class*="card"] { } // Substring match is expensive at scale
```

## Image Performance

```scss
// Prevent CLS — always set dimensions
img {
  max-width: 100%;
  height: auto;
  aspect-ratio: attr(width) / attr(height); // From HTML attributes
}

// Lazy load below-fold images
img[loading="lazy"] {
  // Browser handles lazy loading
}

// Responsive images with art direction
.hero-image {
  width: 100%;
  height: auto;
  object-fit: cover;
  aspect-ratio: 16 / 9;

  @media (max-width: 768px) {
    aspect-ratio: 4 / 3; // Taller on mobile
  }
}
```

## Reduce Unused CSS

```typescript
// Angular — PurgeCSS via build config
// Tailwind handles this automatically via content config
// For custom CSS:

// 1. Use component-scoped styles (Angular default)
// 2. Avoid global stylesheets for component-specific styles
// 3. Use @layer to organize and potentially tree-shake

// angular.json — budget warnings
{
  "budgets": [
    { "type": "initial", "maximumWarning": "500kb", "maximumError": "1mb" },
    { "type": "anyComponentStyle", "maximumWarning": "4kb", "maximumError": "8kb" }
  ]
}
```

## Performance Audit Checklist

```scss
// DevTools → Performance tab → check for:
// 1. Long "Recalculate Style" (>5ms) → too many/complex selectors
// 2. Frequent "Layout" → animating layout properties
// 3. Large "Paint" areas → missing containment
// 4. Missing "Composite" → not using transform/opacity

// DevTools → Rendering tab:
// - Paint flashing (green = repaint)
// - Layout shift regions (blue = layout)
// - Layer borders (orange = composited layers)
```

## Rules

1. **Animate only transform + opacity** — everything else triggers layout/paint
2. **content-visibility: auto** cho off-screen content
3. **contain: layout paint** cho independent widgets
4. **will-change sparingly** — only on elements about to animate
5. **Inline critical CSS** — defer the rest
6. **Component-scoped styles** — reduces unused CSS automatically
7. **aspect-ratio on images** — prevents CLS
8. **font-display: swap** — prevents FOIT

## Anti-patterns

- ❌ `will-change` on everything or permanently
- ❌ Animating width/height/top/left/margin/padding
- ❌ `* { box-shadow: ... }` — universal selectors with expensive properties
- ❌ Large global stylesheets (>50KB uncompressed)
- ❌ `content-visibility` on above-fold content
- ❌ Missing aspect-ratio on images (causes CLS)
- ❌ `@import` chains (serial loading)

## Checklist

- [ ] Only transform/opacity animated
- [ ] Critical CSS inlined
- [ ] content-visibility on below-fold sections
- [ ] contain on independent widgets
- [ ] will-change used correctly (not permanent)
- [ ] Images have aspect-ratio / width+height
- [ ] font-display: swap on custom fonts
- [ ] No layout thrashing in animations
- [ ] CSS budget < 50KB initial
- [ ] DevTools shows no unnecessary repaints
