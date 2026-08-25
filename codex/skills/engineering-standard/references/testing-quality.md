# Testing and Engineering Quality

# 83. Testing Philosophy

Test behavior, not implementation details.

Good:

```text
should_create_order_when_request_is_valid
should_reject_approval_when_order_is_already_approved
```

Bad:

```text
testMethod1
testServiceA
```

Test names should describe:

```text
condition
action
expected result
```

---

# 84. Test Structure

Use:

```text
Arrange
Act
Assert
```

or:

```text
Given
When
Then
```

Example:

```text
Arrange:
    active customer
    valid item

Act:
    create order

Assert:
    order created
    total calculated
    OrderCreated emitted
```

---

# 85. Test What Matters

Prioritize tests for:

```text
business rules
state transitions
error behavior
integration contracts
security-sensitive decisions
critical persistence behavior
idempotency
retry logic where important
```

Do not chase meaningless line coverage.

Coverage is a signal, not the goal.

---

# 86. Mocking

Mock external boundaries, not the entire application.

Good mock targets:

```text
PaymentProvider
EmailProvider
ExternalAPI
Clock
Random
ObjectStorage
```

Avoid over-mocking:

```text
every domain object
every internal method
private implementation details
```

Tests that know every internal call become brittle during refactoring.

---

# 87. Deterministic Tests

Do not rely on:

```text
real current time
uncontrolled random
real external network
test execution order
shared dirty global state
```

Inject:

```text
Clock
Random
ExternalClient
```

or use test containers/fakes when appropriate.

---

# 88. Test Scope

Use the smallest scope that proves behavior.

Typical:

```text
unit test
module integration test
repository integration test
API integration test
end-to-end test
performance test
```

Do not use E2E for logic that a fast unit test can prove.

Do not mock persistence when the persistence mapping itself is the thing being tested.

---

# 89. Module Tests

Keep module-local tests close:

```text
modules/order/tests/
```

Root tests:

```text
tests/integration/
tests/e2e/
tests/performance/
```

cover cross-module or system behavior.

---

# 90. Test Data

Use builders/factories/fixtures when they improve readability.

Bad test setup:

```text
construct 40 unrelated fields in every test
```

Better:

```text
validOrder()
disabledUser()
approvedOrder()
```

Avoid hiding critical values inside opaque fixtures.

---

# 91. Formatting

Use the ecosystem formatter.

Examples:

```text
Java       Spotless / Google Java Format
TS/JS      Prettier
Python     Ruff format / Black
Go         gofmt
C#         dotnet format
Rust       rustfmt
```

Do not manually argue about whitespace in review when tooling can decide.

---

# 92. Linting and Static Analysis

Use project-standard tooling.

Examples:

```text
Java       Checkstyle / Error Prone / SpotBugs
TS/JS      ESLint / TypeScript
Python     Ruff / mypy/pyright when used
Go         go vet / staticcheck
C#         analyzers
Rust       clippy
```

Do not disable warnings globally to make CI green.

Suppress narrowly and document why.

---

# 93. CI Minimum

Production repositories should normally check:

```text
format
lint/static analysis
unit tests
build/type check
```

Add as appropriate:

```text
integration tests
security scans
dependency checks
container build
migration checks
contract tests
```

---

# 94. Dependency Management

Before adding a library:

```text
Does the standard library already solve it?
Does the project already have a library for it?
Is the library maintained?
Does it add security/operational risk?
Is it justified for the amount of code saved?
```

Do not add a dependency for trivial functionality.

---

# 95. Version Upgrades

Do not mix large unrelated dependency upgrades into feature work when avoidable.

Separate:

```text
feature
refactor
dependency upgrade
format migration
```

when it improves reviewability.

---

# 96. Pull Request Scope

Prefer small coherent PRs.

Avoid one PR containing:

```text
feature
large refactor
whole-repo formatting
dependency upgrade
renaming hundreds of files
```

unless they are inseparable.

Small changes are easier to:

```text
review
test
rollback
understand
```

---

# 97. Refactoring

When refactoring:

```text
preserve behavior unless behavior change is requested
add tests before risky changes
change one concept at a time
avoid unrelated cleanup explosion
```

If possible:

```text
PR 1 = behavior-preserving refactor
PR 2 = behavior change
```

---

# 98. Boy Scout Rule

Improve touched code slightly when safe.

Do not use the Boy Scout Rule as justification to rewrite the entire subsystem during a bug fix.

---

# 99. Rule of Least Surprise

Functions should behave as their names imply.

Bad:

```text
validateOrder()
```

that updates DB.

Bad:

```text
calculatePrice()
```

that calls payment provider.

Bad:

```text
findUser()
```

that deletes expired sessions.

Make side effects explicit.

---

# 100. One Source of Truth

Business rules should not be duplicated across backend modules.

If a rule changes, there should be an obvious canonical implementation.

Examples:

```text
OrderApprovalPolicy
PaymentEligibilityPolicy
UserAccessPolicy
```

---
