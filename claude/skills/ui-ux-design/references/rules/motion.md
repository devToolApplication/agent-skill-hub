# Motion Rules

## Purpose

Motion should explain:
- state change
- spatial relationship
- hierarchy
- interaction feedback

Decoration alone is not enough.

## Duration Tokens

Recommended:

motion.fast:
120–160ms

motion.normal:
180–250ms

motion.slow:
300–400ms

Do not invent many arbitrary durations.

## Easing

Appearing:
ease-out

Disappearing:
ease-in

Moving/repositioning:
ease-in-out

## Distance

Prefer small movement.

Examples:

Dropdown:
opacity 0→1
translateY(-4px→0)

Dialog:
opacity 0→1
scale(.98→1)

Avoid exaggerated travel, bounce, spin, or zoom for routine enterprise UI.

## Hover

Prefer subtle:
- background change
- border change
- shadow/elevation adjustment

Avoid large scale transforms on ordinary buttons.

## Reduced Motion

Respect reduced-motion preferences.
Remove or simplify non-essential animation.
