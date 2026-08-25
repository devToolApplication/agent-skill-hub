# Form Rules

## Labels

Every field needs a persistent understandable label.

Placeholder is supplemental, never the only label.

## Layout

Default:
one column

Use two columns only for strongly related fields:

First Name | Last Name
Start Date | End Date
City | Postal Code

## Field Width

Field width should roughly reflect expected value when practical.

Examples:
- age: short
- OTP: short
- date: medium
- description: wide/multiline

## Required Fields

If most fields are required, mark optional fields instead of filling the form with asterisks.

## Validation

Do not show "required" errors before meaningful user interaction.

Prefer:
- on blur
- after user interaction
- on submit with field-level feedback

Error message should explain:
1. what is wrong
2. how to fix it

## Submission

During submit:
- prevent duplicate submission
- show processing state
- preserve entered values on recoverable failure
- show clear recovery action

## Long Forms

Use:
- sections
- side navigation
- wizard only when the process is genuinely sequential

## Controls

Checkbox:
independent multiple choices

Radio:
one-of-many choice

Switch:
immediate binary setting

Select:
moderate number of options

Combobox/Search Select:
large searchable option set

## Read-only

For read-only information, prefer text/description list over disabled inputs when no editing affordance is needed.
