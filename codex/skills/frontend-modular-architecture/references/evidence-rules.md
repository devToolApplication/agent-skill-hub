# Frontend Evidence Rules

Convert only relevant rules into bounded `fe_evidence` tasks. Workers report facts; parent judges severity/fix.

## FE-ARCH-001 — shared/core must not depend on feature internals
Collect imports from changed shared/core files and resolve targets.

## FE-ARCH-002 — cross-feature consumers use stable/public boundaries
Collect cross-feature imports and identify deep-internal paths.

## FE-STATE-001 — server data should not be duplicated without a reason
For changed server-data flows, identify query/cache source plus local/global copies and writers.

## FE-STATE-002 — derived state should not be independently stored without a reason
Identify stored values that are directly computable from canonical state in the changed path.

## FE-DATA-001 — backend DTO should not leak through meaningful frontend domain boundaries
Identify direct DTO usage in domain calculations/components/stores when wire semantics differ materially.

## FE-COMP-001 — presentation component should not accumulate unrelated orchestration/domain responsibilities
Collect new query/mutation/storage/navigation/domain-calculation responsibilities added to a changed component.

## FE-ASYNC-001 — changed async mutation/search path has controlled stale/pending behavior
Collect pending guard, cancellation/request identity, post-await writes, invalidation and error behavior.

## FE-TEST-001 — changed acceptance behavior has regression coverage
Map each parent-defined acceptance criterion to a test or return uncovered criteria.
