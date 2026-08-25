# Adaptive Design

Progressive enhancement, feature detection, device-specific UX, input modality adaptation.

## Khi nào dùng

- Optimize UX cho different devices/capabilities
- Implement progressive enhancement
- Handle touch vs pointer vs keyboard
- Adapt to user preferences (motion, contrast, color-scheme)

## Progressive Enhancement Layers

```
Layer 1: HTML (semantic, accessible, works without CSS/JS)
Layer 2: CSS (layout, visual design, animations)
Layer 3: JavaScript (interactivity, dynamic features)
Layer 4: Enhanced (WebGL, advanced animations, real-time)
```

## Input Modality Detection

### Pointer Type

```scss
// Fine pointer (mouse, stylus)
@media (pointer: fine) {
  .button { padding: var(--app-space-2) var(--app-space-4); }
  .link { text-decoration: underline; }
}

// Coarse pointer (touch)
@media (pointer: coarse) {
  .button { padding: var(--app-space-3) var(--app-space-5); min-height: 44px; }
  .link { padding: var(--app-space-2); } // larger tap target
}

// No pointer (keyboard/voice only)
@media (pointer: none) {
  // Ensure all interactive elements have visible focus
  :focus-visible { outline: 3px solid var(--app-color-primary); }
}
```

### Hover Capability

```scss
// Only show hover effects on devices that support hover
@media (hover: hover) {
  .card:hover {
    transform: translateY(-2px);
    box-shadow: var(--app-shadow-lg);
  }

  .nav-item:hover .dropdown { display: block; }
}

// Touch devices — use click/tap instead of hover
@media (hover: none) {
  .nav-item .dropdown { /* toggle via JS click */ }
  .tooltip { /* show on tap, not hover */ }
}
```

## User Preference Queries

### Reduced Motion

```scss
// Respect user's motion preference
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

// Only animate when user is OK with motion
@media (prefers-reduced-motion: no-preference) {
  .card { transition: transform var(--app-duration-normal) var(--app-ease-out); }
  .page-enter { animation: slideUp var(--app-duration-normal) var(--app-ease-out); }
}
```

### Color Scheme

```scss
// System dark mode
@media (prefers-color-scheme: dark) {
  :root:not([data-theme]) {
    // Auto dark mode when no explicit theme set
    --app-color-surface: var(--app-color-gray-900);
    --app-color-on-surface: var(--app-color-gray-50);
  }
}
```

### Contrast Preference

```scss
@media (prefers-contrast: more) {
  :root {
    --app-color-border: var(--app-color-gray-900);
    --app-color-on-surface: #000;
    --app-shadow-sm: none; // borders instead of shadows
  }

  .card { border: 2px solid var(--app-color-border); }
}

@media (prefers-contrast: less) {
  :root {
    --app-color-on-surface: var(--app-color-gray-700);
  }
}
```

### Transparency

```scss
@media (prefers-reduced-transparency) {
  .glass-panel {
    background: var(--app-color-surface); // solid instead of glass
    backdrop-filter: none;
  }
}
```

## Feature Detection (CSS)

```scss
// Container queries support
@supports (container-type: inline-size) {
  .widget { container-type: inline-size; }
}

// Subgrid support
@supports (grid-template-rows: subgrid) {
  .card { grid-template-rows: subgrid; }
}

// Has selector
@supports selector(:has(*)) {
  .form-group:has(:invalid) { border-color: var(--app-color-error); }
}

// View Transitions
@supports (view-transition-name: any) {
  .page { view-transition-name: page-content; }
}
```

## Feature Detection (Angular/JS)

```typescript
// Feature detection service
@Injectable({ providedIn: 'root' })
export class FeatureDetectionService {
  readonly supportsContainerQueries = CSS.supports('container-type', 'inline-size');
  readonly supportsViewTransitions = 'startViewTransition' in document;
  readonly prefersReducedMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;
  readonly isTouch = matchMedia('(pointer: coarse)').matches;
  readonly isDarkMode = matchMedia('(prefers-color-scheme: dark)').matches;

  // Reactive media query
  mediaQuery(query: string): Signal<boolean> {
    const mql = matchMedia(query);
    const sig = signal(mql.matches);
    mql.addEventListener('change', (e) => sig.set(e.matches));
    return sig.asReadonly();
  }
}
```

## Responsive Images

```html
<!-- Art direction — different crops per viewport -->
<picture>
  <source media="(min-width: 1024px)" srcset="hero-wide.webp" />
  <source media="(min-width: 640px)" srcset="hero-medium.webp" />
  <img src="hero-mobile.webp" alt="Hero" loading="lazy" decoding="async" />
</picture>

<!-- Resolution switching — same image, different sizes -->
<img
  srcset="photo-400.webp 400w, photo-800.webp 800w, photo-1200.webp 1200w"
  sizes="(min-width: 1024px) 33vw, (min-width: 640px) 50vw, 100vw"
  src="photo-800.webp"
  alt="Photo"
  loading="lazy"
/>
```

## Network-Aware Loading

```typescript
// Adapt to network conditions
@Injectable({ providedIn: 'root' })
export class NetworkAdaptiveService {
  readonly connection = (navigator as any).connection;

  shouldLoadHeavyAssets(): boolean {
    if (!this.connection) return true;
    return this.connection.effectiveType === '4g' && !this.connection.saveData;
  }

  getImageQuality(): 'low' | 'medium' | 'high' {
    if (!this.connection) return 'high';
    if (this.connection.saveData) return 'low';
    switch (this.connection.effectiveType) {
      case '4g': return 'high';
      case '3g': return 'medium';
      default: return 'low';
    }
  }
}
```

## Rules

1. **Progressive enhancement** — core content works without JS
2. **Respect user preferences** — motion, contrast, color-scheme, transparency
3. **Touch targets ≥ 44px** on coarse pointer devices
4. **No hover-only interactions** — always provide tap/click alternative
5. **Feature detect, don't browser detect** — `@supports` over user-agent sniffing
6. **Lazy load below-fold** — `loading="lazy"`, `content-visibility: auto`
7. **Adapt, don't hide** — show simpler version, don't remove content

## Anti-patterns

- ❌ User-agent sniffing for feature detection
- ❌ Hover-only interactions without fallback
- ❌ Ignoring `prefers-reduced-motion`
- ❌ Same heavy assets on slow connections
- ❌ `display: none` to "hide" content on mobile (still downloads)
- ❌ Assuming all users have a mouse

## Checklist

- [ ] Works without JavaScript (core content)
- [ ] Respects prefers-reduced-motion
- [ ] Touch targets ≥ 44px on touch devices
- [ ] No hover-only interactions
- [ ] Images responsive with srcset/sizes
- [ ] Dark mode supported
- [ ] High contrast mode doesn't break layout
- [ ] Network-aware loading for heavy assets
