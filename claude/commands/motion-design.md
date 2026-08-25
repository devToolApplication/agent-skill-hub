# Motion Design

CSS animations, View Transitions API, scroll-driven animations, FLIP technique.

## Khi nào dùng

- Page transitions (route change)
- Scroll-driven animations (parallax, reveal)
- Complex multi-step animations
- FLIP technique cho layout animations

## Animation Principles

1. **Purpose** — animation phải có lý do (guide attention, show relationship, provide feedback)
2. **Duration** — 150-350ms cho UI, 500-1000ms cho decorative
3. **Easing** — ease-out cho enter, ease-in cho exit, spring cho playful
4. **Respect motion preference** — always check `prefers-reduced-motion`

## View Transitions API (Route Transitions)

```typescript
// Angular route transition with View Transitions
// app.config.ts
export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes, withViewTransitions()),
  ]
};
```

```scss
// Global view transition styles
::view-transition-old(page-content) {
  animation: fade-out 200ms ease-in;
}

::view-transition-new(page-content) {
  animation: fade-in 300ms ease-out;
}

// Shared element transition (e.g., card → detail page)
::view-transition-old(hero-image) {
  animation: none;
  mix-blend-mode: normal;
}

::view-transition-new(hero-image) {
  animation: none;
  mix-blend-mode: normal;
}

// Name the transitioning element
.card-image {
  view-transition-name: hero-image;
}

@keyframes fade-out { to { opacity: 0; } }
@keyframes fade-in { from { opacity: 0; } }
```

```typescript
// Custom view transition in component
@Component({...})
export class ListComponent {
  private readonly doc = inject(DOCUMENT);

  async navigateToDetail(item: Item) {
    if (!('startViewTransition' in this.doc)) {
      this.router.navigate(['/detail', item.id]);
      return;
    }

    (this.doc as any).startViewTransition(() => {
      this.router.navigate(['/detail', item.id]);
    });
  }
}
```

## Scroll-Driven Animations

```scss
// Reveal on scroll
@keyframes reveal {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

.scroll-reveal {
  animation: reveal linear both;
  animation-timeline: view();
  animation-range: entry 0% entry 100%;
}

// Progress bar tied to scroll
.reading-progress {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: var(--app-color-primary);
  transform-origin: left;
  animation: grow-width linear;
  animation-timeline: scroll();
}

@keyframes grow-width {
  from { transform: scaleX(0); }
  to { transform: scaleX(1); }
}

// Parallax effect
.parallax-bg {
  animation: parallax linear;
  animation-timeline: scroll();
}

@keyframes parallax {
  from { transform: translateY(-100px); }
  to { transform: translateY(100px); }
}
```

## FLIP Technique (Layout Animations)

```typescript
// FLIP = First, Last, Invert, Play
// Animate layout changes smoothly

export function flipAnimate(element: HTMLElement, callback: () => void): void {
  // First — record current position
  const first = element.getBoundingClientRect();

  // Execute the DOM change
  callback();

  // Last — record new position
  const last = element.getBoundingClientRect();

  // Invert — calculate delta
  const deltaX = first.left - last.left;
  const deltaY = first.top - last.top;
  const deltaW = first.width / last.width;
  const deltaH = first.height / last.height;

  // Play — animate from inverted to final
  element.animate([
    {
      transform: `translate(${deltaX}px, ${deltaY}px) scale(${deltaW}, ${deltaH})`,
    },
    {
      transform: 'none',
    }
  ], {
    duration: 300,
    easing: 'cubic-bezier(0.2, 0, 0.2, 1)',
  });
}
```

## Stagger Animations

```scss
// Stagger children on enter
.list-enter .item {
  animation: slideUp var(--app-duration-normal) var(--app-ease-out) both;
}

// Stagger delay via custom property
.item:nth-child(1) { --delay: 0ms; }
.item:nth-child(2) { --delay: 50ms; }
.item:nth-child(3) { --delay: 100ms; }
.item:nth-child(4) { --delay: 150ms; }
.item:nth-child(5) { --delay: 200ms; }

.item { animation-delay: var(--delay); }
```

```typescript
// Dynamic stagger in Angular
@Component({
  template: `
    @for (item of items(); track item.id; let i = $index) {
      <div class="item" [style.--delay.ms]="i * 50">
        {{ item.name }}
      </div>
    }
  `,
  styles: [`
    .item {
      animation: slideUp 300ms ease-out both;
      animation-delay: var(--delay);
    }
  `]
})
```

## Keyframe Patterns

```scss
// Bounce in
@keyframes bounceIn {
  0% { transform: scale(0.3); opacity: 0; }
  50% { transform: scale(1.05); }
  70% { transform: scale(0.9); }
  100% { transform: scale(1); opacity: 1; }
}

// Shake (error feedback)
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  10%, 30%, 50%, 70%, 90% { transform: translateX(-4px); }
  20%, 40%, 60%, 80% { transform: translateX(4px); }
}

// Pulse (attention)
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

// Spin (loading)
@keyframes spin {
  to { transform: rotate(360deg); }
}

// Skeleton shimmer
@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

.skeleton {
  background: linear-gradient(90deg, var(--app-color-gray-200) 25%, var(--app-color-gray-100) 50%, var(--app-color-gray-200) 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}
```

## Reduced Motion Fallback

```scss
// ALWAYS wrap animations
@media (prefers-reduced-motion: no-preference) {
  .animated { animation: slideUp 300ms ease-out; }
  .scroll-reveal { animation-timeline: view(); }
}

@media (prefers-reduced-motion: reduce) {
  .animated { animation: fadeIn 100ms ease-out; } // simple fade only
  .scroll-reveal { animation: none; opacity: 1; }
}
```

## Rules

1. **Purpose-driven** — every animation must serve UX (guide, feedback, continuity)
2. **Duration 150-350ms** cho UI interactions, never >500ms for functional animations
3. **Ease-out for enter**, ease-in for exit, linear for continuous
4. **Respect prefers-reduced-motion** — ALWAYS provide fallback
5. **GPU-friendly properties** — only animate `transform` and `opacity`
6. **No layout thrashing** — don't animate `width`, `height`, `top`, `left`
7. **View Transitions** cho route changes — progressive enhancement
8. **FLIP** cho layout animations — smooth reordering/resizing

## Anti-patterns

- ❌ Animating `width`, `height`, `margin`, `padding` (triggers layout)
- ❌ Animation duration > 500ms for UI feedback
- ❌ Animations without `prefers-reduced-motion` check
- ❌ Infinite animations (except loading spinners)
- ❌ Animation for decoration only (no UX purpose)
- ❌ Blocking user interaction during animation

## Checklist

- [ ] All animations have clear UX purpose
- [ ] Duration ≤ 350ms for interactions
- [ ] Only transform/opacity animated
- [ ] prefers-reduced-motion respected
- [ ] View Transitions for route changes (with fallback)
- [ ] Stagger used for list animations
- [ ] No jank (60fps verified in DevTools)
