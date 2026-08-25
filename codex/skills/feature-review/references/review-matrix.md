# Evidence Review Matrix

Convert only relevant rows into atomic evidence questions.

## Architecture

Collect evidence for:

- changed files and owning modules;
- new cross-module imports;
- imports of another module's internals/infrastructure;
- direct mutation/access of another module's persistence;
- newly introduced cycles;
- new abstractions/shared utilities and existing equivalents.

## Correctness

Collect evidence for:

- changed branches/state transitions;
- caller assumptions around changed signatures/return/error behavior;
- null/empty/default behavior changes;
- changed data mapping/calculation;
- changed side effects;
- backward-compatibility-sensitive contracts.

## Maintainability

Collect evidence for:

- unrelated files changed;
- new duplicate utility/helper behavior;
- type weakening (`any`, raw object/maps, broad casts) introduced by diff;
- dead/commented code or ownerless TODOs introduced by diff;
- unusually broad responsibilities added to an existing file/symbol.

## Tests

Collect evidence for:

- changed business branches without corresponding tests;
- changed error/failure paths without tests;
- changed persistence/API contracts without regression tests;
- nondeterministic time/concurrency behavior introduced without control;
- tests that only assert mocks while missing business output/state.

## Security

Collect evidence for:

- authn/authz/tenant/resource ownership checks removed or bypassed;
- string-built SQL/commands/HTML/path usage introduced;
- secret-like literals/logging of sensitive values;
- new outbound URL/file-path handling with user-controlled input;
- changed JWT/webhook/signature validation.

## Reliability / Performance

Collect evidence for:

- new remote calls with no visible timeout strategy;
- retries around state-changing work without visible idempotency protection;
- transaction boundaries that include remote I/O;
- unbounded loops/queries/tasks/collections introduced;
- resource lifecycle changes;
- N+1 query patterns introduced in changed execution paths;
- concurrency-sensitive shared state changes.
