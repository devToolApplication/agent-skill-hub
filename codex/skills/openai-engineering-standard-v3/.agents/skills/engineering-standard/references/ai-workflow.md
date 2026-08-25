# AI Coding Workflow and Review Checklists

# 127. AI Pre-Change Workflow

Before editing code, the AI must:

```text
1. Identify the requested behavior.
2. Locate the owning module.
3. Inspect nearby existing patterns.
4. Search for existing reusable code.
5. Identify public contracts.
6. Identify persistence ownership.
7. Identify external integrations.
8. Identify relevant tests.
9. Determine the smallest coherent change.
10. Avoid unrelated modifications.
```

---

# 128. AI New File Rule

Before creating a new:

```text
service
repository
helper
util
mapper
DTO
adapter
client
module
```

the AI must search for an existing equivalent.

Do not create duplicates with slightly different names.

Examples of accidental duplicates:

```text
DateUtils
DateHelper
DateUtil
DateParser
CommonDateService
```

Search first.

---

# 129. AI New Dependency Rule

Before adding a package/library:

```text
check existing dependencies
check standard library
check project utilities
justify why new dependency is needed
```

Do not add packages for trivial operations.

---

# 130. AI Shared Code and Utility Rule

Before modifying `shared/`, determine:

```text
Is this business-specific or business-neutral?
Does an existing shared utility already provide the same behavior?
Does the proposed class/module have one narrow technical responsibility?
Will unrelated modules reuse the same semantics?
Does it hide I/O, runtime state, or infrastructure behind a utility name?
Would a service/port/adapter be more accurate?
```

Use these defaults:

```text
Business-specific behavior
    -> keep in the owning module

Generic focused reusable behavior
    -> shared utility is allowed

Vague mixed behavior
    -> do not create CommonUtil/CommonService/Helper; split by concern

Infrastructure or side-effecting behavior
    -> service/client/repository/adapter, not *Util
```

Examples of valid shared utilities:

```text
StringUtil
TimeUtil
DateUtil
CollectionUtil
JsonUtil
EncodingUtil
UrlUtil
```

Examples that should not become global shared utilities:

```text
OrderUtil
PaymentUtil
UserHelper
CommonUtil
CommonService
```

A foundational utility may be introduced before repeated duplication when it deliberately standardizes project-wide semantics such as string normalization, date parsing, time-zone conversion, masking, JSON serialization, or collection handling.

Do not re-wrap the entire standard library. The utility must add project-level semantics, consistency, or real reuse.

For time-dependent business logic, prefer `Clock`/`TimeProvider` injection over direct `TimeUtil.now()` calls.

---

# 131. AI Refactor Rule

For a feature request, do not perform a broad refactor unless required.

Bad AI behavior:

```text
User asks to add one field.
AI rewrites module architecture.
```

Preferred:

```text
implement requested behavior
preserve current architecture
perform only necessary cleanup
```

---

# 132. AI Comment Rule

Do not generate noisy comments such as:

```text
// Create user
// Return result
// Check if valid
```

Comments must add information not obvious from code.

---

# 133. AI Error Rule

Do not solve compilation/runtime issues by:

```text
catching Exception everywhere
returning null
ignoring failures
disabling lint
disabling type checking
using any/object everywhere
```

Fix the root cause.

---

# 134. AI Type Rule

Do not weaken types merely to make code compile.

Avoid unnecessary:

```text
any
Object
Map<String, Object>
dict[str, Any]
dynamic
```

when the domain structure is known.

Prefer meaningful types.

---

# 135. AI Test Rule

When changing important behavior:

```text
update or add tests
test success path
test important failure path
```

Do not create tests that only assert mocks were called without proving behavior.

---

# 136. AI Completion Rule

Before claiming the task is complete, check where applicable:

```text
format
lint
type check
unit tests
build
relevant integration tests
```

If something cannot be run, state that clearly.

Do not claim tests passed if they were not executed.

---

# 137. AI Review Questions

Before finalizing a change, answer internally:

```text
Is this in the correct module?
Is this in the correct layer?
Did I create an unnecessary abstraction?
Did I duplicate an existing helper?
Did I leak infrastructure into business code?
Did I import another module's internals?
Did I add a hidden side effect?
Did I handle failure intentionally?
Did I preserve existing conventions?
Did I test the important behavior?
```

---

# 138. Function Review Checklist

- [ ] Name communicates intent.
- [ ] One primary responsibility.
- [ ] Parameters are understandable.
- [ ] No unexplained positional booleans.
- [ ] No unnecessary deep nesting.
- [ ] No unexplained magic values.
- [ ] Side effects are obvious.
- [ ] Error behavior is intentional.
- [ ] Comments explain WHY only.
- [ ] Business behavior is tested where important.

---

# 139. File/Class Review Checklist

- [ ] Responsibility is clear.
- [ ] Name reflects responsibility.
- [ ] Not a dumping ground.
- [ ] Does not improperly mix transport, persistence, and business logic.
- [ ] Dependencies point correctly.
- [ ] Size remains understandable.
- [ ] Public surface is minimal.
- [ ] Internal details do not leak.

---

# 140. Module Review Checklist

- [ ] Represents a business capability.
- [ ] Owns its persistence.
- [ ] Public contract is explicit.
- [ ] Internal code is not imported by other modules.
- [ ] Dependencies are acyclic.
- [ ] Shared code is business-neutral and bounded; focused utilities are reused instead of duplicated, while business-specific helpers stay in their owning module.
- [ ] Domain logic is not framework-coupled.
- [ ] Tests exist for important rules.

---

# 141. Feature Review Checklist

- [ ] Owning module identified.
- [ ] Use case identified.
- [ ] Business rules in application/domain.
- [ ] Transport kept thin.
- [ ] Persistence kept in infrastructure.
- [ ] External API isolated.
- [ ] No cross-module internal import.
- [ ] No cross-module table mutation.
- [ ] Errors are meaningful.
- [ ] Remote calls have timeouts.
- [ ] Retry/idempotency considered.
- [ ] Transaction boundary is clear.
- [ ] Tests updated.
- [ ] Logging/metrics added if operationally useful.
- [ ] API/docs updated if contract changed.

---

# 142. Definition of Done

A change is done when applicable:

- [ ] Requested behavior works.
- [ ] Correct module owns the change.
- [ ] Dependency boundaries remain valid.
- [ ] Naming is clear.
- [ ] No unnecessary abstraction was introduced.
- [ ] No accidental duplicate utility exists.
- [ ] Tests pass.
- [ ] Format passes.
- [ ] Lint/static analysis passes.
- [ ] Build/type check passes.
- [ ] Error handling is intentional.
- [ ] Remote operations are bounded.
- [ ] Secrets are not logged.
- [ ] Documentation/contracts are updated if required.
- [ ] No dead/commented-out code remains.
- [ ] No ownerless TODO remains.
- [ ] No unrelated rewrite was performed.

---

# 143. Mandatory 20 Rules

When context is limited, enforce these first:

1. Divide code by business capability.
2. Keep business logic out of controllers.
3. Keep framework/vendor details out of domain.
4. A function has one primary responsibility.
5. Use business-oriented names.
6. Prefer early return and shallow nesting.
7. Other modules use public contracts only.
8. Do not directly mutate another module's database tables.
9. Shared code must be business-neutral and bounded; focused technical utilities are allowed.
10. Do not abstract without a real need.
11. Do not create generic helper dumping grounds.
12. Comments explain WHY, not obvious WHAT.
13. Errors must have meaningful semantics.
14. Never swallow exceptions.
15. External calls require intentional timeout behavior.
16. Retry state changes only with safe semantics/idempotency.
17. Important business behavior must be tested.
18. Use ecosystem formatter/linter/build tooling.
19. Preserve existing coherent repository conventions.
20. Prefer the simplest design that is easy to change.

---

# 144. Good vs Bad — Function Example

Bad:

```text
process(data)
```

Problems:

```text
vague name
unknown input
unknown side effects
unknown business meaning
```

Better:

```text
approveOrder(command)
```

The intent is obvious.

---

# 145. Good vs Bad — Service Example

Bad:

```text
CommonService
    formatDate()
    sendEmail()
    updateOrder()
    parseToken()
    calculatePrice()
```

Better:

```text
OrderPricingService
EmailSender
TokenParser
DateFormatter
```

Each responsibility is discoverable.

---

# 146. Good vs Bad — Controller Example

Bad:

```text
OrderController.create()
    query customer
    validate customer
    calculate price
    insert DB
    call provider
    send event
```

Better:

```text
OrderController.create()
    request -> command
    createOrder.execute(command)
    result -> response
```

---

# 147. Good vs Bad — Shared Example

Bad:

```text
shared/
└── OrderUtils
```

Better:

```text
modules/order/
└── domain/OrderPricing
```

The business concept stays with its owner.

---

# 148. Good vs Bad — Comment Example

Bad:

```text
// Validate order
validateOrder(order)
```

Better:

```text
// Legacy orders created before migration may not have a currency.
// Default to VND only for those records to preserve historical behavior.
```

---

# 149. Good vs Bad — Error Example

Bad:

```text
throw Error("Invalid")
```

Better:

```text
throw OrderCannotBeApproved(orderId, currentStatus)
```

---

# 150. Good vs Bad — External API Example

Bad:

```text
OrderService
    requests.post(payment_url)
```

Better:

```text
OrderService
    -> PaymentGateway
        -> HttpPaymentClient
```

---

# 151. Good vs Bad — Boolean Example

Bad:

```text
createUser(name, true, false)
```

Better:

```text
createUser(CreateUserCommand(
    name=name,
    sendWelcomeEmail=true,
    requirePasswordReset=false
))
```

or better yet separate behavior if those flags imply separate use cases.

---

# 152. Good vs Bad — State Example

Bad:

```text
isPending
isApproved
isRejected
```

Better:

```text
status = OrderStatus.APPROVED
```

---

# 153. Good vs Bad — Cross Module Example

Bad:

```text
PaymentRepository
    UPDATE orders
```

Better:

```text
PaymentCompleted
    -> Order module handles state transition
```

or:

```text
OrderPublicApi.markPaid(...)
```

---

# 154. Good vs Bad — Transaction Example

Bad:

```text
BEGIN
save order
call provider
send email
COMMIT
```

Better:

```text
BEGIN
save order
save outbox event
COMMIT

publish asynchronously
```

when reliability requirements justify an outbox.

---

# 155. Good vs Bad — Test Example

Bad:

```text
testService()
```

Better:

```text
should_reject_order_when_customer_is_disabled()
```

---

# 164. Repository Navigation Goal

A healthy repository should make this sequence easy:

```text
find business module
    ↓
find use case
    ↓
find domain rule
    ↓
find adapter/repository
    ↓
find test
```

If a small feature requires opening many unrelated global folders, reconsider structure.

---

# 165. Final Quality Test

Before finalizing code, be able to answer:

```text
What does this code do?
Which module owns it?
Where is the business rule?
What does it depend on?
What side effects occur?
What happens when it fails?
How is it tested?
Where would the next related change go?
```

If these answers are not obvious, improve the design.

---

# 166. Final AI Directive

Do not optimize for producing the most code.

Optimize for producing the smallest coherent change that:

```text
solves the requested problem
fits the repository
preserves architecture
is easy to understand
is easy to test
is safe to extend
```

The best implementation is often the one that future developers can understand quickly without needing the original author.


# Shared Utility Review Checklist

Before creating or extending a shared utility:

- [ ] Searched for an existing equivalent utility/function first.
- [ ] Name identifies one bounded technical concern.
- [ ] No `User`, `Order`, `Payment`, `Document`, `Workflow`, or other business ownership leaks into it.
- [ ] No hidden database/network/message-broker/storage call.
- [ ] No hidden mutable global state.
- [ ] Functionality adds project consistency or real reuse beyond a trivial standard-library alias.
- [ ] Method belongs to the utility's existing scope.
- [ ] Utility API remains small enough to scan and understand.
- [ ] Important edge cases have focused tests.
- [ ] Time-dependent business rules use an injectable `Clock`/`TimeProvider` where deterministic testing matters.
