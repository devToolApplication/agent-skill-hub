# Dev FE Role — Design Skills Reference

Danh sách skills chuyên web design để sử dụng trong workflow Dev FE Role.

## Khi nào invoke skill nào

### Bước 3 (Thinking) — Xác định skills cần dùng:

| Tình huống | Skill cần invoke |
|------------|-----------------|
| Setup/extend theme, tokens | `/design-tokens` |
| Tailwind config, component patterns | `/tailwind-design-system` |
| Tổ chức CSS, layers, scope | `/css-architecture` |
| Layout responsive, breakpoints | `/responsive-layout` |
| Grid/Flexbox complex layout | `/grid-mastery` |
| Progressive enhancement, device adapt | `/adaptive-design` |
| Page transitions, scroll animations | `/motion-design` |
| Hover, loading, feedback states | `/micro-interactions` |
| Angular @angular/animations | `/angular-animations-patterns` |
| Font, type scale, readability | `/typography-system` |
| Color palette, dark mode, contrast | `/color-system` |
| Modern CSS features (nesting, :has, etc) | `/modern-css` |
| Rendering performance, CLS, paint | `/css-performance` |

### Bước 5 (Implementation) — Áp dụng theo rule:

- **R1 (UI/UX rule):** Dùng `/responsive-layout` + `/grid-mastery` cho layout
- **R2 (Components):** Dùng `/tailwind-design-system` hoặc `/css-architecture` cho styling
- **R3 (Design tokens):** Dùng `/design-tokens` + `/color-system` + `/typography-system`
- **R4 (i18n):** Không liên quan design skills
- **R5 (Scope):** Dùng `/modern-css` + `/css-performance` để optimize

### Bước 6 (Verification) — Check quality:

- Responsive: invoke `/responsive-layout` checklist
- Performance: invoke `/css-performance` checklist
- Accessibility: invoke `/color-system` (contrast) + `/adaptive-design` (motion/preferences)
- Animations: invoke `/micro-interactions` hoặc `/motion-design` checklist

## Quick Decision Tree

```
Cần làm gì?
├── Layout/Structure → /responsive-layout, /grid-mastery
├── Colors/Theme → /design-tokens, /color-system
├── Typography → /typography-system
├── Animations → /motion-design, /micro-interactions, /angular-animations-patterns
├── CSS Organization → /css-architecture, /modern-css
├── Performance → /css-performance
├── Device Adaptation → /adaptive-design
└── Tailwind → /tailwind-design-system
```

## Nguyên tắc chung

1. **Luôn dùng design tokens** — không hardcode values
2. **Mobile-first** — base = mobile, enhance with min-width
3. **Container queries cho components** — media queries cho page layout
4. **Animate only transform + opacity** — không animate layout properties
5. **Respect user preferences** — reduced-motion, color-scheme, contrast
6. **WCAG AA minimum** — 4.5:1 text contrast, 3:1 UI components
