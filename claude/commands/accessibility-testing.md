# Accessibility Testing

WCAG, keyboard navigation, screen reader basics, contrast.

## Khi nào dùng
- Test accessibility cho UI
- Verify keyboard/screen reader behavior
- Check contrast and ARIA

## Coverage
- Semantic HTML
- Keyboard-only flow
- Focus order and focus visible
- Labels for inputs/buttons
- ARIA only when semantic HTML insufficient
- Contrast ratios
- Error announcement
- Reduced motion preference

## WCAG Minimum
- Text contrast >= 4.5:1
- Large text/UI components >= 3:1
- Touch targets >= 44x44px
- No keyboard trap

## Checklist
- [ ] All controls reachable by keyboard
- [ ] Focus order logical
- [ ] Inputs have accessible labels
- [ ] Buttons have accessible names
- [ ] Errors announced/associated
- [ ] Contrast passes WCAG AA
- [ ] No hover-only functionality
