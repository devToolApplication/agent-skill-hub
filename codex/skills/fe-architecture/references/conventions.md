# Coding Conventions

## Naming

Names should communicate intent and domain.

Prefer:
- `selectedOrder`
- `customerProfile`
- `calculateOrderTotal`
- `loadCustomerProfile`
- `submitOrder`

Avoid vague names when a precise name exists:
- `data`
- `obj`
- `temp`
- `info`
- `process`
- `helper`
- `common`

Short names are acceptable for conventional narrow scopes.

## Functions

A function should have one coherent responsibility.

Prefer:
- explicit inputs,
- explicit result,
- minimal hidden mutation,
- early returns over deeply nested conditions,
- domain language over implementation language.

Do not create a one-line wrapper if it adds no semantic boundary.

## Comments

Comments explain WHY, constraints, non-obvious tradeoffs, external quirks, or invariants.

Bad:

```text
// set username
user.name = name
```

Useful:

```text
// The legacy endpoint may return duplicates during migration.
// Keep the newest record by updatedAt.
```

Delete stale comments when code changes.

## Imports

Prefer stable aliases if the project supports them.

Avoid very deep relative imports when a stable public module boundary exists.

Do not bypass feature public APIs to reach internals.

## Utilities

Do not create dumping grounds such as:
- `common.ts`
- `helpers.ts`
- `misc.ts`
- `utils.ts` containing unrelated behavior.

Use focused names:
- `date`
- `money`
- `string`
- `file`

Domain-aware utilities stay with the domain.

## Constants

Create named constants for values with business/configuration meaning.

Do not replace every literal with a constant mechanically.

## Validation

Business validation belongs near the owning feature/domain.

Generic reusable validators may live in shared.

Keep browser/form-library plumbing separate from business rules when practical.

## Side effects

Keep side effects obvious.

Network, storage, navigation, analytics, and global mutation should not be hidden inside generic-looking pure helpers.

## Async code

Handle:
- loading state,
- errors,
- stale/cancelled requests where relevant,
- duplicate submissions,
- race conditions for user-triggered search/autocomplete where relevant.

Do not add defensive complexity for impossible states without evidence.

## Type safety

Use the project's type system fully.

Avoid:
- `any`/untyped escapes without reason,
- unsafe casts masking contract problems,
- duplicated incompatible type definitions.

Do not make types more complex than the runtime model.

## Duplication

Before extracting an abstraction, ask:
- Are the duplicated pieces semantically the same?
- Will they change for the same reason?
- Does the abstraction get a clear name?
- Does it reduce future change cost?

If not, keep them separate.

## Cleanup scope

When modifying existing code:
- remove dead code caused by your change,
- update directly related names/comments/tests,
- avoid opportunistic repository-wide cleanup.

Small focused diffs are easier to review and safer to revert.
