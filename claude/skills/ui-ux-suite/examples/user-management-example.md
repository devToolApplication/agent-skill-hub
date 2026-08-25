# Example: User Management

## Requirement Summary

Target:
enterprise admin on desktop.

Primary tasks:
- search user
- inspect status and role
- lock/unlock account
- edit account

Rare/destructive:
- delete account

Expected scale:
100k+ users.

## UX Architecture

Decision:
Use server-side data table.

Why:
Users must compare identity, role, status, department, and last login.

Decision:
Use detail drawer for quick inspection.

Why:
Admins frequently inspect records while preserving filters and table context.

Decision:
Use dedicated page for edit.

Why:
Edit form spans multiple sections and permissions.

Decision:
Place delete in overflow menu.

Why:
Delete is rare and destructive.

## List Screen

Page Header:
Users
Primary action: Add user

Controls:
Search by name/email
Status filter
Role filter
More filters

Table:
- User
- Email
- Role
- Department
- Status
- Last login
- Actions

Row:
Click identity → open detail drawer
Edit → dedicated page
Overflow → reset password, lock/unlock, delete

## Mobile Adaptation

Use structured list items instead of retaining the full table.

Record:

Nguyen Van A            ⋯
a@example.com
Admin · Active
IT Department
Last login: 2 hours ago
