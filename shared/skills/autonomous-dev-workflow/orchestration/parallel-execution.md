# Parallel Execution and Write Ownership

## Eligibility

A task is parallel-safe only when:

```text
design_dependencies_passed
AND contract_inputs_stable
AND agent_capacity_available
AND no_active_write_conflict
```

`runtime_dependencies` do not block design/implementation work when mocks/contracts are sufficient; they block only the verification step that needs the running dependency.

## Same-role fan-out

A role is not a singleton. Prefer:

```text
dev-be-agent -> candidate query
dev-be-agent -> approval command
dev-be-agent -> evidence API
```

instead of assigning one oversized backend task, provided ownership is disjoint.

## Write ownership

Every writing task declares `write_paths` and `forbidden_write_paths`. Main acquires a logical write lock before spawn. Two active writers MUST NOT own overlapping paths/symbols or a known shared integration file.

Read-only reviewers do not consume write locks and should run concurrently.

## Shared files

Files such as root routing, app/module registration, package manifests, central exports and migration registries are conflict hotspots. Prefer workers returning `integration_requests`, followed by one bounded fan-in task that owns the shared files.

## Rolling dispatch

If tasks A, B and C start together and B finishes early, any D depending only on B should start immediately when its gates permit. Main MUST NOT wait for A and C.

## Rolling review

When one implementation task finishes its self-gate, independent reviewers may start immediately while sibling implementation tasks continue.

## Repair

Independent review failure routes to the original implementation role:

```text
RECEIVE_REVIEW -> FIX -> SELF_TEST -> SELF_REVIEW -> FINAL_VERIFY -> INDEPENDENT_REVIEW
```

A repair may not reuse stale passing evidence.
