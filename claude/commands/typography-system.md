# Typography System

Font pairing, vertical rhythm, fluid type scales, reading experience optimization.

## Khi nào dùng

- Setup typography cho project mới
- Fix readability issues
- Tạo type scale
- Font pairing decisions
- Vertical rhythm alignment

## Type Scale (Fluid)

```scss
// Major Third scale (1.25 ratio) with fluid clamp
:root {
  // Base
  --app-text-xs: clamp(0.694rem, 0.65rem + 0.22vw, 0.75rem);     // 11-12px
  --app-text-sm: clamp(0.8rem, 0.75rem + 0.25vw, 0.875rem);      // 13-14px
  --app-text-base: clamp(0.9rem, 0.85rem + 0.25vw, 1rem);        // 14-16px
  --app-text-lg: clamp(1.05rem, 0.95rem + 0.5vw, 1.125rem);      // 17-18px
  --app-text-xl: clamp(1.15rem, 1rem + 0.75vw, 1.25rem);         // 18-20px
  --app-text-2xl: clamp(1.4rem, 1.15rem + 1.25vw, 1.5rem);       // 22-24px
  --app-text-3xl: clamp(1.7rem, 1.3rem + 2vw, 1.875rem);         // 27-30px
  --app-text-4xl: clamp(2rem, 1.5rem + 2.5vw, 2.25rem);          // 32-36px
  --app-text-5xl: clamp(2.5rem, 1.75rem + 3.75vw, 3rem);         // 40-48px

  // Line heights
  --app-leading-none: 1;
  --app-leading-tight: 1.25;
  --app-leading-snug: 1.375;
  --app-leading-normal: 1.5;
  --app-leading-relaxed: 1.625;
  --app-leading-loose: 2;

  // Letter spacing
  --app-tracking-tighter: -0.05em;
  --app-tracking-tight: -0.025em;
  --app-tracking-normal: 0;
  --app-tracking-wide: 0.025em;
  --app-tracking-wider: 0.05em;
}
```

## Font Pairing Recommendations

### Pairing 1: Inter + JetBrains Mono (Modern SaaS)
```scss
--app-font-sans: 'Inter', system-ui, -apple-system, sans-serif;
--app-font-mono: 'JetBrains Mono', 'Fira Code', monospace;
```

### Pairing 2: Plus Jakarta Sans + IBM Plex Mono (Professional)
```scss
--app-font-sans: 'Plus Jakarta Sans', system-ui, sans-serif;
--app-font-mono: 'IBM Plex Mono', monospace;
```

### Pairing 3: Geist + Geist Mono (Vercel-style)
```scss
--app-font-sans: 'Geist', system-ui, sans-serif;
--app-font-mono: 'Geist Mono', monospace;
```

### Pairing 4: System fonts (Zero FOUT, fastest)
```scss
--app-font-sans: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
--app-font-mono: ui-monospace, 'Cascadia Code', 'Source Code Pro', monospace;
```

## Font Loading Strategy

```html
<!-- Preload critical fonts -->
<link rel="preload" href="/fonts/inter-var.woff2" as="font" type="font/woff2" crossorigin>

<!-- Font-face with display swap -->
<style>
@font-face {
  font-family: 'Inter';
  src: url('/fonts/inter-var.woff2') format('woff2');
  font-weight: 100 900;
  font-display: swap;
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+2000-206F;
}
</style>
```

```scss
// Fallback font metrics matching (reduce CLS)
@font-face {
  font-family: 'Inter Fallback';
  src: local('Arial');
  ascent-override: 90%;
  descent-override: 22%;
  line-gap-override: 0%;
  size-adjust: 107%;
}

:root {
  --app-font-sans: 'Inter', 'Inter Fallback', system-ui, sans-serif;
}
```

## Vertical Rhythm

```scss
// Base unit = line-height of body text
// If body = 16px * 1.5 = 24px line-height → rhythm unit = 24px

:root {
  --rhythm: 1.5rem; // 24px at 16px base
}

// All vertical spacing = multiples of rhythm
h1 { margin-bottom: var(--rhythm); }
h2 { margin-top: calc(var(--rhythm) * 2); margin-bottom: var(--rhythm); }
h3 { margin-top: calc(var(--rhythm) * 1.5); margin-bottom: calc(var(--rhythm) * 0.5); }
p { margin-bottom: var(--rhythm); }
ul, ol { margin-bottom: var(--rhythm); }

// Images snap to rhythm grid
img { margin-bottom: var(--rhythm); }
```

## Heading Styles

```scss
h1, .h1 {
  font-size: var(--app-text-4xl);
  font-weight: var(--app-font-bold);
  line-height: var(--app-leading-tight);
  letter-spacing: var(--app-tracking-tight);
}

h2, .h2 {
  font-size: var(--app-text-3xl);
  font-weight: var(--app-font-semibold);
  line-height: var(--app-leading-tight);
  letter-spacing: var(--app-tracking-tight);
}

h3, .h3 {
  font-size: var(--app-text-2xl);
  font-weight: var(--app-font-semibold);
  line-height: var(--app-leading-snug);
}

h4, .h4 {
  font-size: var(--app-text-xl);
  font-weight: var(--app-font-medium);
  line-height: var(--app-leading-snug);
}
```

## Reading Experience

```scss
// Optimal reading width
.prose {
  max-width: 65ch; // ~65 characters per line
  font-size: var(--app-text-base);
  line-height: var(--app-leading-relaxed);

  // Paragraph spacing
  p + p { margin-top: var(--rhythm); }

  // List styling
  ul, ol {
    padding-inline-start: 1.5em;
    li + li { margin-top: calc(var(--rhythm) * 0.5); }
  }

  // Code blocks
  pre {
    font-size: var(--app-text-sm);
    line-height: var(--app-leading-normal);
    padding: var(--app-space-4);
    overflow-x: auto;
  }

  code {
    font-size: 0.875em;
    padding: 0.125em 0.25em;
    border-radius: var(--app-radius-sm);
    background: var(--app-color-gray-100);
  }
}
```

## Responsive Typography Patterns

```scss
// Heading that adapts to container
.page-title {
  font-size: var(--app-text-4xl);
  font-weight: var(--app-font-bold);
  line-height: var(--app-leading-tight);
  text-wrap: balance; // Prevent orphans
}

// Truncation
.truncate-single {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.truncate-multi {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

// Text wrap balance (headings)
h1, h2, h3 { text-wrap: balance; }

// Text wrap pretty (paragraphs — avoids orphans)
p { text-wrap: pretty; }
```

## Rules

1. **Fluid type scale** — `clamp()` cho responsive, không media queries
2. **Max 2 font families** — 1 sans + 1 mono (hoặc system fonts)
3. **65ch max line width** cho reading content
4. **Vertical rhythm** — spacing = multiples of base line-height
5. **font-display: swap** — prevent invisible text during load
6. **Preload critical fonts** — only above-fold fonts
7. **text-wrap: balance** cho headings, `pretty` cho paragraphs
8. **Variable fonts** — 1 file thay vì nhiều weights

## Anti-patterns

- ❌ More than 3 font weights loaded (use variable font)
- ❌ Font size < 16px for body text on mobile
- ❌ Line length > 80ch (hard to read)
- ❌ Line height < 1.4 for body text
- ❌ `font-display: block` (causes FOIT)
- ❌ Loading fonts from Google Fonts without preconnect
- ❌ Different font sizes for same semantic level

## Checklist

- [ ] Type scale defined with fluid clamp()
- [ ] Max 2 font families
- [ ] Variable fonts used where possible
- [ ] font-display: swap on all @font-face
- [ ] Critical fonts preloaded
- [ ] Body text ≥ 16px on mobile
- [ ] Line length ≤ 65ch for reading
- [ ] Vertical rhythm consistent
- [ ] text-wrap: balance on headings
- [ ] Fallback font metrics matched (reduce CLS)
