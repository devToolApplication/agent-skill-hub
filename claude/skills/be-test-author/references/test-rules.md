# BE Test Rules

Prefer tests at the boundary that owns behavior:

- service/domain tests for semantic business behavior;
- transport tests for exception -> status/error response mapping;
- integration adapter tests for external error translation;
- transaction tests for rollback/commit semantics where meaningful;
- retry tests for attempt/exhaustion behavior without arbitrary sleep.
