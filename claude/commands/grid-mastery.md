# CSS Grid & Flexbox Mastery

Complex layout patterns, subgrid, auto-placement, alignment strategies.

## Khi nào dùng

- Layout phức tạp (dashboard, multi-column)
- Alignment tricky giữa siblings
- Subgrid cho nested alignment
- Chọn Grid vs Flexbox

## Khi nào Grid vs Flexbox

| Dùng Grid khi | Dùng Flexbox khi |
|---------------|------------------|
| 2D layout (rows + columns) | 1D layout (row HOẶC column) |
| Known grid structure | Unknown number of items |
| Alignment across tracks | Content-driven sizing |
| Overlap/layering needed | Simple centering |
| Dashboard/page layout | Nav, toolbar, card content |

## Grid Patterns

### Pattern 1: Dashboard Layout

```scss
.dashboard {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  grid-template-rows: auto;
  gap: var(--app-space-4);

  .widget-full { grid-column: 1 / -1; }
  .widget-half { grid-column: span 6; }
  .widget-third { grid-column: span 4; }
  .widget-quarter { grid-column: span 3; }

  @media (max-width: 1023px) {
    .widget-half,
    .widget-third,
    .widget-quarter { grid-column: span 6; }
  }

  @media (max-width: 639px) {
    grid-template-columns: 1fr;
    .widget-full,
    .widget-half,
    .widget-third,
    .widget-quarter { grid-column: 1 / -1; }
  }
}
```

### Pattern 2: Auto-fit Cards

```scss
// Tự động wrap — không cần media queries
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(300px, 100%), 1fr));
  gap: var(--app-space-4);
}
```

### Pattern 3: Subgrid (Aligned Card Content)

```scss
// Cards trong grid có header/body/footer aligned across cards
.card-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: var(--app-space-4);
}

.card {
  display: grid;
  grid-template-rows: subgrid;
  grid-row: span 3; // header + body + footer
  gap: var(--app-space-3);
}
```

### Pattern 4: Overlap/Layering

```scss
// Image with overlay text
.hero {
  display: grid;
  grid-template: 1fr / 1fr;

  > * { grid-area: 1 / 1; }

  .hero-image { object-fit: cover; width: 100%; height: 100%; }
  .hero-content { align-self: end; padding: var(--app-space-8); z-index: 1; }
}
```

### Pattern 5: Named Grid Areas

```scss
.page-layout {
  display: grid;
  grid-template-areas:
    "header header"
    "sidebar main"
    "footer footer";
  grid-template-columns: 250px 1fr;
  grid-template-rows: auto 1fr auto;
  min-height: 100dvh;

  @media (max-width: 1023px) {
    grid-template-areas:
      "header"
      "main"
      "footer";
    grid-template-columns: 1fr;
  }
}

.header { grid-area: header; }
.sidebar { grid-area: sidebar; }
.main { grid-area: main; }
.footer { grid-area: footer; }
```

### Pattern 6: Masonry-like (CSS Grid)

```scss
// Approximate masonry with auto-rows
.masonry {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  grid-auto-rows: 10px;
  gap: 0 var(--app-space-4);

  .item {
    // grid-row-end set dynamically based on content height
    // Requires JS to calculate span
  }
}
```

## Flexbox Patterns

### Pattern 1: Space Between with Wrap

```scss
.toolbar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: var(--app-space-3);
}
```

### Pattern 2: Sticky Footer in Card

```scss
.card {
  display: flex;
  flex-direction: column;
  height: 100%;

  .card-body { flex: 1; }
  .card-footer { margin-top: auto; }
}
```

### Pattern 3: Truncated Text with Icon

```scss
.list-item {
  display: flex;
  align-items: center;
  gap: var(--app-space-2);
  min-width: 0; // Critical for truncation

  .text {
    flex: 1;
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .icon { flex-shrink: 0; }
}
```

### Pattern 4: Equal Height Columns

```scss
.columns {
  display: flex;
  gap: var(--app-space-4);

  .column {
    flex: 1;
    display: flex;
    flex-direction: column;
  }
}
```

## Alignment Cheat Sheet

```scss
// Center anything
.center-grid { display: grid; place-items: center; }
.center-flex { display: flex; align-items: center; justify-content: center; }

// Stretch to fill
.stretch { align-items: stretch; } // flex default

// Baseline alignment (text alignment across different font sizes)
.baseline { align-items: baseline; }

// Last item pushed to end
.space-between { justify-content: space-between; }
.ml-auto-last .item:last-child { margin-inline-start: auto; }
```

## Rules

1. **Grid for layout, Flexbox for content** — page structure = Grid, component internals = Flexbox
2. **`min-width: 0`** trên flex children khi cần truncation
3. **`minmax(min(X, 100%), 1fr)`** cho responsive grid — handles small viewports
4. **Subgrid** khi cần align content across sibling cards
5. **Named areas** cho page-level layouts — readable và maintainable
6. **`gap` over margins** — consistent spacing, no collapsing issues
7. **Avoid `calc()` for grid sizing** — dùng `fr` units

## Anti-patterns

- ❌ Flexbox for 2D layouts — dùng Grid
- ❌ `float` for layout (legacy only)
- ❌ Negative margins for gaps — dùng `gap`
- ❌ Fixed heights on grid rows (trừ khi intentional)
- ❌ `grid-template-columns: 33.33% 33.33% 33.33%` — dùng `repeat(3, 1fr)`
- ❌ Forgetting `min-width: 0` on flex items with overflow

## Checklist

- [ ] Grid/Flexbox choice justified
- [ ] No overflow at any viewport
- [ ] Alignment consistent across items
- [ ] Gap used instead of margins between siblings
- [ ] min-width: 0 on flex items that truncate
- [ ] Subgrid used where siblings need cross-alignment
