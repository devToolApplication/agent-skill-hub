# Playwright E2E Testing

E2E test flow bằng Playwright cho web UI.

## Khi nào dùng
- Critical FE flow cần automation
- Regression suite
- Verify UI behavior end-to-end

## Rules
- Use user-facing locators: getByRole, getByLabel, getByText
- Avoid brittle CSS selectors
- Test behavior, not implementation
- Setup/cleanup test data
- No fixed sleeps; wait for assertions

## Pattern
```ts
test('user can create item', async ({ page }) => {
  await page.goto('/items');
  await page.getByRole('button', { name: /create/i }).click();
  await page.getByLabel(/name/i).fill('Test item');
  await page.getByRole('button', { name: /save/i }).click();
  await expect(page.getByText('Test item')).toBeVisible();
});
```

## Checklist
- [ ] Stable locators
- [ ] No hard sleeps
- [ ] Test data isolated
- [ ] Mobile viewport if UI responsive
- [ ] Screenshots/traces on failure
