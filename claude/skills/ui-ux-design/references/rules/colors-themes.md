# Color & Theme Rules

## Semantic Tokens

Components should depend on semantic tokens, not raw color values.

Required semantic groups:

Background:
- bg
- surface
- surfaceElevated

Text:
- textPrimary
- textSecondary
- textMuted
- textInverse

Border:
- border
- borderStrong

Action:
- primary
- primaryHover
- primaryPressed

Status:
- success
- warning
- danger
- info

## Neutral First

Most of the interface should use neutral surfaces and text.

Accent/brand color should remain scarce enough to preserve hierarchy.

A useful heuristic:
- majority: neutral background/surfaces
- secondary: structure/text/borders
- minority: brand/accent/status

Do not treat this as a rigid percentage rule.

## Light Theme

Use:
- bright neutral background
- slightly distinct surfaces
- restrained shadows
- clear text hierarchy

## Dark Theme

Dark theme is not inverted light theme.

Prefer:
- near-black background
- slightly brighter surfaces
- near-white primary text
- restrained saturation
- borders/luminance for elevation

Do not rely on large black shadows for dark-mode elevation.

## Status

Never communicate status with color alone.

Use:
color + text
or
color + icon + text

## Brand Themes

Brand may alter:
- primary hue
- accent
- selected state
- illustrations

Brand should not alter:
- interaction meaning
- danger meaning
- keyboard behavior
- layout logic
