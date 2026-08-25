# Micro-interactions

Hover states, loading skeletons, feedback animations, state transitions, toast notifications.

## Khi nào dùng

- Polish UI interactions (hover, focus, active)
- Loading states và skeletons
- User feedback (success, error, progress)
- State transitions (expand, collapse, toggle)

## Hover & Focus States

### Button States

```scss
.button {
  // Base
  transition: all var(--app-duration-fast) var(--app-ease-default);

  // Hover — subtle lift
  &:hover:not(:disabled) {
    transform: translateY(-1px);
    box-shadow: var(--app-shadow-sm);
  }

  // Active — press down
  &:active:not(:disabled) {
    transform: translateY(0) scale(0.98);
    box-shadow: none;
  }

  // Focus visible — keyboard only
  &:focus-visible {
    outline: 2px solid var(--app-color-primary);
    outline-offset: 2px;
  }

  // Disabled
  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  // Loading state
  &.is-loading {
    pointer-events: none;
    position: relative;
    color: transparent;

    &::after {
      content: '';
      position: absolute;
      inset: 0;
      margin: auto;
      width: 1em;
      height: 1em;
      border: 2px solid currentColor;
      border-right-color: transparent;
      border-radius: 50%;
      animation: spin 600ms linear infinite;
      color: var(--app-color-on-primary);
    }
  }
}
```

### Card Hover

```scss
.card {
  transition: transform var(--app-duration-fast) var(--app-ease-out),
              box-shadow var(--app-duration-fast) var(--app-ease-out);

  &:hover {
    transform: translateY(-2px);
    box-shadow: var(--app-shadow-md);
  }

  // Image zoom on hover
  .card-image {
    overflow: hidden;

    img {
      transition: transform var(--app-duration-normal) var(--app-ease-out);
    }
  }

  &:hover .card-image img {
    transform: scale(1.05);
  }
}
```

### Link Underline Animation

```scss
.animated-link {
  position: relative;
  text-decoration: none;

  &::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    width: 100%;
    height: 2px;
    background: currentColor;
    transform: scaleX(0);
    transform-origin: right;
    transition: transform var(--app-duration-fast) var(--app-ease-out);
  }

  &:hover::after {
    transform: scaleX(1);
    transform-origin: left;
  }
}
```

## Loading States

### Skeleton Screen

```scss
.skeleton {
  --skeleton-bg: var(--app-color-gray-200);
  --skeleton-shine: var(--app-color-gray-100);

  background: linear-gradient(
    90deg,
    var(--skeleton-bg) 25%,
    var(--skeleton-shine) 50%,
    var(--skeleton-bg) 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s ease-in-out infinite;
  border-radius: var(--app-radius-md);
}

.skeleton-text { height: 1em; margin-bottom: 0.5em; }
.skeleton-text:last-child { width: 60%; }
.skeleton-avatar { width: 40px; height: 40px; border-radius: 50%; }
.skeleton-image { width: 100%; aspect-ratio: 16/9; }

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

```html
<!-- Angular skeleton component -->
@if (loading()) {
  <div class="card-skeleton">
    <div class="skeleton skeleton-image"></div>
    <div class="p-4 space-y-2">
      <div class="skeleton skeleton-text"></div>
      <div class="skeleton skeleton-text"></div>
      <div class="skeleton skeleton-text"></div>
    </div>
  </div>
} @else {
  <app-card [data]="data()" />
}
```

### Progress Indicators

```scss
// Indeterminate progress bar
.progress-indeterminate {
  height: 3px;
  background: var(--app-color-gray-200);
  overflow: hidden;
  border-radius: var(--app-radius-full);

  &::after {
    content: '';
    display: block;
    height: 100%;
    width: 40%;
    background: var(--app-color-primary);
    border-radius: inherit;
    animation: indeterminate 1.5s ease-in-out infinite;
  }
}

@keyframes indeterminate {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(350%); }
}

// Determinate progress
.progress-bar {
  height: 6px;
  background: var(--app-color-gray-200);
  border-radius: var(--app-radius-full);
  overflow: hidden;

  .progress-fill {
    height: 100%;
    background: var(--app-color-primary);
    border-radius: inherit;
    transition: width var(--app-duration-normal) var(--app-ease-out);
  }
}
```

## Feedback Animations

### Success Checkmark

```scss
.success-check {
  width: 48px;
  height: 48px;

  .circle {
    stroke-dasharray: 166;
    stroke-dashoffset: 166;
    animation: stroke 600ms ease-out forwards;
  }

  .check {
    stroke-dasharray: 48;
    stroke-dashoffset: 48;
    animation: stroke 300ms ease-out 400ms forwards;
  }
}

@keyframes stroke {
  to { stroke-dashoffset: 0; }
}
```

### Shake on Error

```scss
.shake-error {
  animation: shake 400ms ease-out;
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  20%, 60% { transform: translateX(-6px); }
  40%, 80% { transform: translateX(6px); }
}
```

### Ripple Effect (Material-style)

```scss
.ripple {
  position: relative;
  overflow: hidden;

  &::after {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(circle, currentColor 10%, transparent 10%);
    background-position: center;
    background-size: 0;
    opacity: 0;
    transition: background-size 400ms ease-out, opacity 300ms ease-out;
  }

  &:active::after {
    background-size: 1000%;
    opacity: 0.1;
    transition: 0s;
  }
}
```

## State Transitions

### Expand/Collapse

```scss
.collapsible {
  display: grid;
  grid-template-rows: 0fr;
  transition: grid-template-rows var(--app-duration-normal) var(--app-ease-default);

  &.is-open {
    grid-template-rows: 1fr;
  }

  .content {
    overflow: hidden;
  }
}
```

### Toggle Switch

```scss
.toggle {
  width: 44px;
  height: 24px;
  background: var(--app-color-gray-300);
  border-radius: var(--app-radius-full);
  padding: 2px;
  cursor: pointer;
  transition: background var(--app-duration-fast) var(--app-ease-default);

  &::after {
    content: '';
    display: block;
    width: 20px;
    height: 20px;
    background: white;
    border-radius: 50%;
    box-shadow: var(--app-shadow-xs);
    transition: transform var(--app-duration-fast) var(--app-ease-spring);
  }

  &.is-active {
    background: var(--app-color-primary);

    &::after { transform: translateX(20px); }
  }
}
```

### Tooltip

```scss
.tooltip-trigger {
  position: relative;

  .tooltip {
    position: absolute;
    bottom: calc(100% + 8px);
    left: 50%;
    transform: translateX(-50%) translateY(4px);
    opacity: 0;
    pointer-events: none;
    transition: opacity var(--app-duration-fast) var(--app-ease-out),
                transform var(--app-duration-fast) var(--app-ease-out);
    // styles...
  }

  &:hover .tooltip,
  &:focus-visible .tooltip {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
}
```

## Rules

1. **Consistent timing** — same interaction type = same duration across app
2. **Feedback within 100ms** — user must see response immediately
3. **Skeleton > spinner** — skeletons preserve layout, spinners don't
4. **Only transform + opacity** — never animate layout properties
5. **Hover ≠ required** — hover effects are enhancement, not functionality
6. **Focus-visible** — only show focus ring on keyboard navigation
7. **Reduced motion** — replace motion with opacity fade

## Anti-patterns

- ❌ Spinner for content that has known structure (use skeleton)
- ❌ Hover effects that change layout (push other elements)
- ❌ Animations that block interaction
- ❌ Different timing for same interaction type
- ❌ Focus ring on mouse click (use `:focus-visible`)
- ❌ Tooltip only on hover (inaccessible on touch)

## Checklist

- [ ] All interactive elements have hover/focus/active states
- [ ] Loading states use skeletons for known layouts
- [ ] Feedback animations < 400ms
- [ ] Reduced motion alternative provided
- [ ] Focus-visible (not :focus) for keyboard ring
- [ ] No layout shift during state transitions
- [ ] Touch devices have tap feedback
