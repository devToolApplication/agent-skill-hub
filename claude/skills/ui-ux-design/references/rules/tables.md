# Data Table Rules

## When to Use

Use a table when users need to compare records across multiple attributes.

Do not use a table merely because the data comes from a database.

## Alignment

Text → left
Date → usually left
Status → left
Numbers → right
Currency → right
Percentage → right
Actions → right

## Columns

Include only fields useful for scanning, comparison, sorting, filtering, or action.

Move deep detail to:
- detail page
- drawer
- expandable row when justified

## Row Actions

0–2 frequent actions:
may be visible

3+ actions:
prefer overflow menu

Rare destructive actions should usually be separated from frequent safe actions.

## Search & Filters

Always-visible:
high-frequency filters

Advanced:
filter panel/drawer

Applied filters must remain visible and removable.

Provide:
Clear all

## Large Tables

Consider:
- sticky header
- sticky identity column
- sticky actions
- column resizing
- column visibility
- density mode
- server-side pagination
- virtualized rendering

Only add complexity when the data volume requires it.

## Empty States

Distinguish:

NO DATA:
there are no records yet

NO RESULTS:
records exist but filters/search match nothing

## Loading

Use skeleton rows or a localized loading state where practical.

## Mobile

Do not squeeze a wide table into a tiny viewport.

Consider:

Record Name            ⋯
email@example.com
Admin · Active
Last login: ...
