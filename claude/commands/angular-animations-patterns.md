# Angular Animations Patterns

Route transitions, component enter/leave, stagger, reusable animation triggers with @angular/animations and Web Animations API.

## Khi nào dùng

- Route transitions (page enter/leave)
- Component enter/leave animations
- List stagger animations
- Reusable animation triggers
- Complex multi-step sequences

## Setup

```typescript
// app.config.ts
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';

export const appConfig: ApplicationConfig = {
  providers: [
    provideAnimationsAsync(), // Lazy-load animation module
  ]
};
```

## Route Transitions

```typescript
// route-animations.ts
import { trigger, transition, style, animate, query, group } from '@angular/animations';

export const routeAnimation = trigger('routeAnimation', [
  transition('* <=> *', [
    query(':enter, :leave', [
      style({ position: 'absolute', width: '100%' })
    ], { optional: true }),

    group([
      query(':leave', [
        animate('200ms ease-in', style({ opacity: 0, transform: 'translateY(-10px)' }))
      ], { optional: true }),

      query(':enter', [
        style({ opacity: 0, transform: 'translateY(10px)' }),
        animate('300ms 100ms ease-out', style({ opacity: 1, transform: 'translateY(0)' }))
      ], { optional: true }),
    ]),
  ]),
]);

// app.component.ts
@Component({
  animations: [routeAnimation],
  template: `
    <div [@routeAnimation]="getRouteAnimationData()">
      <router-outlet />
    </div>
  `
})
export class AppComponent {
  private readonly route = inject(ActivatedRoute);

  getRouteAnimationData() {
    return this.route.firstChild?.snapshot?.data?.['animation'] ?? '';
  }
}
```

## Component Enter/Leave

```typescript
// Reusable fade trigger
export const fadeInOut = trigger('fadeInOut', [
  transition(':enter', [
    style({ opacity: 0 }),
    animate('250ms ease-out', style({ opacity: 1 })),
  ]),
  transition(':leave', [
    animate('200ms ease-in', style({ opacity: 0 })),
  ]),
]);

// Slide from bottom
export const slideUp = trigger('slideUp', [
  transition(':enter', [
    style({ opacity: 0, transform: 'translateY(16px)' }),
    animate('300ms ease-out', style({ opacity: 1, transform: 'translateY(0)' })),
  ]),
  transition(':leave', [
    animate('200ms ease-in', style({ opacity: 0, transform: 'translateY(8px)' })),
  ]),
]);

// Scale in (for modals, popovers)
export const scaleIn = trigger('scaleIn', [
  transition(':enter', [
    style({ opacity: 0, transform: 'scale(0.95)' }),
    animate('200ms cubic-bezier(0.34, 1.56, 0.64, 1)', style({ opacity: 1, transform: 'scale(1)' })),
  ]),
  transition(':leave', [
    animate('150ms ease-in', style({ opacity: 0, transform: 'scale(0.95)' })),
  ]),
]);
```

```typescript
// Usage in component
@Component({
  animations: [fadeInOut, slideUp],
  template: `
    @if (showPanel()) {
      <div @slideUp class="panel">
        Panel content
      </div>
    }

    @if (notification()) {
      <div @fadeInOut class="notification">
        {{ notification() }}
      </div>
    }
  `
})
```

## List Stagger

```typescript
export const listStagger = trigger('listStagger', [
  transition('* => *', [
    query(':enter', [
      style({ opacity: 0, transform: 'translateY(12px)' }),
      stagger('50ms', [
        animate('300ms ease-out', style({ opacity: 1, transform: 'translateY(0)' })),
      ]),
    ], { optional: true }),

    query(':leave', [
      stagger('30ms', [
        animate('200ms ease-in', style({ opacity: 0, transform: 'translateY(-8px)' })),
      ]),
    ], { optional: true }),
  ]),
]);

// Usage
@Component({
  animations: [listStagger],
  template: `
    <div [@listStagger]="items().length">
      @for (item of items(); track item.id) {
        <app-card [data]="item" />
      }
    </div>
  `
})
```

## State-Based Animations

```typescript
export const expandCollapse = trigger('expandCollapse', [
  state('collapsed', style({ height: '0', opacity: 0, overflow: 'hidden' })),
  state('expanded', style({ height: '*', opacity: 1 })),
  transition('collapsed <=> expanded', [
    animate('250ms cubic-bezier(0.4, 0, 0.2, 1)'),
  ]),
]);

// Usage
@Component({
  animations: [expandCollapse],
  template: `
    <button (click)="toggle()">Toggle</button>
    <div [@expandCollapse]="isOpen() ? 'expanded' : 'collapsed'">
      Collapsible content
    </div>
  `
})
```

## Web Animations API (Alternative)

```typescript
// For dynamic/programmatic animations — no @angular/animations needed
@Directive({ selector: '[appAnimate]' })
export class AnimateDirective {
  private readonly el = inject(ElementRef);

  animateIn(): void {
    this.el.nativeElement.animate([
      { opacity: 0, transform: 'translateY(12px)' },
      { opacity: 1, transform: 'translateY(0)' },
    ], {
      duration: 300,
      easing: 'cubic-bezier(0, 0, 0.2, 1)',
      fill: 'forwards',
    });
  }

  animateOut(): Promise<void> {
    const animation = this.el.nativeElement.animate([
      { opacity: 1, transform: 'translateY(0)' },
      { opacity: 0, transform: 'translateY(-8px)' },
    ], {
      duration: 200,
      easing: 'cubic-bezier(0.4, 0, 1, 1)',
      fill: 'forwards',
    });

    return animation.finished;
  }
}
```

## Reduced Motion Support

```typescript
// Animation-aware service
@Injectable({ providedIn: 'root' })
export class MotionService {
  readonly prefersReducedMotion = signal(
    matchMedia('(prefers-reduced-motion: reduce)').matches
  );

  constructor() {
    matchMedia('(prefers-reduced-motion: reduce)')
      .addEventListener('change', (e) => this.prefersReducedMotion.set(e.matches));
  }

  // Use in components to conditionally apply animations
  getDuration(normalMs: number): number {
    return this.prefersReducedMotion() ? 0 : normalMs;
  }
}

// In animations — use params
export const adaptiveFade = trigger('adaptiveFade', [
  transition(':enter', [
    style({ opacity: 0 }),
    animate('{{ duration }}ms ease-out', style({ opacity: 1 })),
  ], { params: { duration: 250 } }),
]);

// Template
// <div [@adaptiveFade]="{ value: '', params: { duration: motionService.getDuration(250) } }">
```

## Shared Animation Library Pattern

```typescript
// animations/index.ts — export all reusable animations
export { fadeInOut } from './fade';
export { slideUp, slideDown, slideLeft, slideRight } from './slide';
export { scaleIn } from './scale';
export { listStagger } from './stagger';
export { expandCollapse } from './expand';
export { routeAnimation } from './route';
```

## Rules

1. **provideAnimationsAsync()** — lazy load animation module
2. **Reusable triggers** — define once in shared lib, import where needed
3. **Track by** — always use `track` in `@for` for proper enter/leave detection
4. **Optional queries** — `{ optional: true }` prevents errors when elements don't exist
5. **Params for customization** — duration, delay, easing as animation params
6. **Web Animations API** cho dynamic/programmatic — @angular/animations cho declarative
7. **Reduced motion** — provide 0-duration alternative

## Anti-patterns

- ❌ `provideAnimations()` (synchronous) — use `provideAnimationsAsync()`
- ❌ Animations without `track` in `@for` — causes full re-render
- ❌ Complex animations in `@angular/animations` — use Web Animations API instead
- ❌ Animating layout properties (width, height, top, left)
- ❌ Missing `{ optional: true }` on queries
- ❌ Hardcoded durations — use params or tokens

## Checklist

- [ ] provideAnimationsAsync() in app config
- [ ] Reusable triggers in shared animation library
- [ ] All @for loops have track
- [ ] Reduced motion respected
- [ ] Only transform/opacity animated
- [ ] Route transitions smooth (no flash)
- [ ] List stagger for dynamic lists
