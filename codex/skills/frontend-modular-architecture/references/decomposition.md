# Frontend Decomposition Recipes

The strong parent converts broad frontend concerns into factual discovery tasks, then exact write tasks.

## Module boundary

Do not dispatch `review architecture`.

Collect:
1. changed files;
2. owning feature/layer for each;
3. imports from changed files;
4. resolved import target paths;
5. cross-feature/shared/core crossings.

Parent judges violations and chooses a fix. Only then dispatch exact edits.

## State placement

Collect:
1. state declaration;
2. all readers;
3. all writers;
4. component/subtree ownership;
5. remote/query source for the same data;
6. persistence/global-store location.

Parent decides local vs server vs global state. Worker receives the decided move/removal direction and exact files.

## DTO boundary

Collect:
1. API response/request types;
2. where DTO types are consumed;
3. existing mapper/adapters;
4. wire-specific fields/semantics;
5. domain/UI model differences.

Parent decides whether mapping is warranted, then sends exact file instructions.

## Component responsibility

Collect from a known component:
- props;
- local state;
- effects/watchers;
- query/mutation calls;
- navigation/storage calls;
- domain calculations;
- child components;
- feature/service imports.

Parent decides extraction direction. Do not ask the worker to `split the component cleanly` without a concrete target structure.

## Async/query behavior

Collect:
- mutation trigger;
- pending/in-flight guard;
- cancellation/request identity;
- writes after await;
- invalidation/refetch behavior;
- error/rollback branch.

Parent judges race/staleness risk and chooses the fix.

## Test mapping

Parent writes acceptance criteria first. Search existing tests per criterion. Missing criteria become explicit `fe_test_author` tasks with exact scenarios and test files.
