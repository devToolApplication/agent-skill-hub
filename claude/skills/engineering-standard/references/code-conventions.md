# Code Conventions

# 19. Naming Convention

Names must communicate intent.

Good:

```text
getUserById()
calculateOrderTotal()
validatePayment()
approveOrder()
publishOrderCreated()
isUserActive()
hasPermission()
canRetry()
```

Bad:

```text
getData()
process()
handle()
doTask()
execute2()
temp()
abc()
data()
helper()
common()
```

Use generic names only when the type or scope already gives an unambiguous meaning.

---

# 20. Boolean Naming

Boolean names should read like a question.

Prefer:

```text
isActive
isDeleted
hasPermission
canApprove
shouldRetry
wasProcessed
exists
```

Avoid:

```text
activeFlag
statusBool
check
value
enabledValue
```

---

# 21. Collection Naming

Collections use domain plural names.

Prefer:

```text
users
orders
documents
activeUsers
pendingOrders
```

Avoid storage-oriented names unless relevant:

```text
userList
orderArray
dataList
```

If the implementation type matters to the algorithm, a type-oriented name may be justified.

---

# 22. Function Naming

Functions generally start with verbs.

Examples:

```text
createUser()
updateOrder()
findDocument()
calculateTotal()
validateRequest()
publishEvent()
loadCustomer()
saveOrder()
```

Boolean queries:

```text
isValid()
hasAccess()
canApprove()
shouldRetry()
exists()
```

Side effects must be reflected in the name.

Bad:

```text
getUser()
```

that also updates state and sends events.

Better:

```text
loadAndMarkUserAsRead()
```

if the side effect is truly required.

---

# 23. Class and Component Naming

Use responsibility-specific names.

Good:

```text
OrderService
PaymentGateway
DocumentRepository
UserValidator
OrderMapper
InvoiceParser
PaymentRetryPolicy
```

Avoid vague, unbounded names:

```text
CommonService
CommonUtil
Helper
GeneralUtil
Manager
Processor
Handler
```

Focused technical utilities are valid when their scope is obvious:

```text
StringUtil
TimeUtil
DateUtil
CollectionUtil
JsonUtil
EncodingUtil
```

Qualified service/handler names are also valid:

```text
PaymentHandler
OrderCommandHandler
InvoiceProcessor
```

The problem is not the suffix `Util`; the problem is an unclear or unbounded responsibility. See `shared-utilities.md`.

---

# 24. Function Responsibility

A function should perform one primary conceptual task.

Bad:

```text
createOrder()
    validate request
    query user
    calculate totals
    update inventory
    insert database
    call payment
    send email
    publish kafka
    audit
```

Better:

```text
createOrder()
    validateOrder()
    loadCustomer()
    reserveInventory()
    calculateOrderTotal()
    saveOrder()
    requestPayment()
    publishOrderCreated()
```

The high-level function should read like the business flow.

---

# 25. Function Size

Do not enforce line counts mechanically.

Guideline:

```text
5-20 lines      usually excellent
20-40 lines     usually acceptable
40-60 lines     inspect responsibility
>60 lines       strong refactoring signal
```

A cohesive 45-line parser may be better than six meaningless 7-line functions.

The rule is conceptual cohesion, not line-count worship.

---

# 26. Parameter Count

Prefer:

```text
0-3 parameters
```

When many fields belong together, create a request/command/options type.

Bad:

```text
createUser(
    name,
    email,
    phone,
    address,
    role,
    department,
    branch,
    createdBy
)
```

Better:

```text
createUser(command)
```

Example:

```text
CreateUserCommand {
    name
    email
    phone
    address
    role
    department
    branch
    createdBy
}
```

Avoid unexplained positional booleans:

```text
createUser(name, true, false, true)
```

Use named options or richer domain types.

---

# 27. Same Abstraction Level

Statements inside one function should live at roughly the same abstraction level.

Bad:

```text
createOrder()
    validateOrder()
    executeRawSql(...)
    calculateTax()
    kafka.send(...)
    buildResponse()
```

Good:

```text
createOrder()
    validateOrder()
    saveOrder()
    calculateTax()
    publishOrderCreated()
    buildResponse()
```

The lower-level methods contain the technical details.

---

# 28. Early Return

Prefer guard clauses when they reduce nesting.

Bad:

```text
if user exists:
    if user active:
        if user has permission:
            process()
```

Good:

```text
if user missing:
    return USER_NOT_FOUND

if user disabled:
    return USER_DISABLED

if user lacks permission:
    return ACCESS_DENIED

process()
```

---

# 29. Nesting

Guideline:

```text
1-2 levels   preferred
3 levels     inspect
>3 levels    usually refactor
```

Avoid shapes such as:

```text
if
    for
        if
            switch
                if
```

Extract predicates, guard clauses, or focused operations.

---

# 30. Magic Numbers and Strings

Bad:

```text
if retryCount > 5
if status == "03"
sleep(30000)
```

Good:

```text
MAX_PAYMENT_RETRIES
OrderStatus.APPROVED
PAYMENT_TIMEOUT_MS
```

Constants must include context.

Bad:

```text
TIMEOUT
LIMIT
```

Good:

```text
PAYMENT_TIMEOUT_SECONDS
MAX_SEARCH_RESULTS
```

---

# 31. Comment Philosophy

Comments explain WHY.

Do not narrate obvious code.

Bad:

```text
// increment retry count
retryCount++
```

Bad:

```text
// check user is null
if user == null
```

Good:

```text
// The legacy provider occasionally returns HTTP 200 with an empty payload.
// Retry once before marking the transaction as failed.
```

Good reasons for comments:

```text
non-obvious business rule
external system bug
compatibility workaround
security constraint
performance tradeoff
unusual algorithm
architectural decision
temporary migration behavior
```

---

# 32. Comment Quality

Prefer comments that remain useful after small implementation changes.

Bad:

```text
// Call service A first, then service B.
```

Better:

```text
// Service B reads the identifier created by Service A, so ordering is required.
```

The second comment explains the invariant, not the syntax.

---

# 33. TODO Convention

Bad:

```text
TODO fix later
TODO temporary
TODO clean this
```

Good:

```text
TODO: Remove this fallback after legacy ECM is retired.
Tracking: ECM-1842
```

A useful TODO contains:

```text
what remains
why it remains
removal condition or issue
```

Do not create ownerless TODO debt.

---

# 34. Dead Code

Delete unused code.

Do not preserve commented-out implementations.

Bad:

```text
// oldCreateUser()
// old logic below
```

Version control is the history.

If code is not used and has no documented near-term purpose, remove it.

---

# 35. File Responsibility

A file should have a clear reason to exist.

Avoid giant catch-all files:

```text
utils.ts
helpers.py
common.java
misc.cs
```

Prefer:

```text
DateParser
MoneyFormatter
EmailValidator
PaginationMapper
```

---

# 36. File Size

Guideline:

```text
<200 lines      easy to manage
200-400 lines   normal
400-600 lines   review responsibilities
>600 lines      strong signal to inspect
```

Do not split a cohesive implementation merely to satisfy a number.

---

# 37. Locality of Behavior

Code that changes together should be close together.

Feature grouping is often preferable in large modules.

Example:

```text
approve-order/
├── ApproveOrderCommand
├── ApproveOrderHandler
├── ApproveOrderValidator
└── ApproveOrderTest
```

instead of globally scattering:

```text
commands/
handlers/
validators/
tests/
```

Choose the layout that makes feature discovery easier.

---

# 38. Abstraction Rules

Do not create abstraction merely because a design pattern exists.

Bad:

```text
IUserService
UserService
UserServiceImpl
UserServiceFactory
UserServiceProvider
```

for one simple implementation.

Good abstraction boundaries:

```text
Database
External API
Message broker
Object storage
Payment provider
Email provider
Authentication provider
Clock
ID generator
Random generator
```

Create interfaces/traits/protocols when:

```text
multiple implementations exist
a boundary needs isolation
testing benefits materially
vendor replacement is plausible
dependency inversion protects business logic
```

---

# 39. Inheritance

Prefer composition.

Use inheritance only when the relationship is truly stable and substitutable.

Avoid deep inheritance trees such as:

```text
BaseService
 -> BaseCrudService
   -> BaseValidatedService
     -> UserService
```

They make behavior hard to locate.

---

# 40. Command vs Query

Queries:

```text
getUser()
findOrder()
searchDocuments()
```

should generally not mutate state.

Commands:

```text
createUser()
approveOrder()
cancelPayment()
```

may mutate state.

Avoid hidden side effects in read-looking methods.

This improves reasoning and testability.

---

# 41. Business Rule Location

Business rules should have one authoritative implementation.

Bad:

```text
Controller checks order state
Service checks same state differently
Consumer checks another version
Frontend checks another version
```

Good:

```text
order.canApprove()
order.approve()
OrderApprovalPolicy
```

The frontend may duplicate validation for UX, but backend business truth remains centralized.

---

# 42. State Modeling

Avoid representing mutually exclusive states with booleans.

Bad:

```text
isPending
isApproved
isRejected
```

which can become:

```text
isPending = true
isApproved = true
```

Use:

```text
OrderStatus.PENDING
OrderStatus.APPROVED
OrderStatus.REJECTED
```

Use domain types that make invalid states hard to represent.

---

# 43. DTO vs Domain vs Persistence Entity

Do not treat these as automatically identical.

Recommended:

```text
HTTP Request
    ↓
Request DTO
    ↓
Command / Query
    ↓
Domain / Application
    ↓
Response DTO
    ↓
HTTP Response
```

Persistence:

```text
DB Entity
    ↕ mapper
Domain Entity
```

Do not expose ORM entities directly as public APIs by default.

Reasons:

- database fields leak;
- security exposure becomes easier;
- API changes become coupled to migrations;
- lazy relationships may serialize accidentally;
- domain invariants become weaker.

---

# 44. Input Validation

Transport validation includes:

```text
required fields
type
format
length
range
syntax
```

Keep it close to the request boundary.

Examples:

```text
valid email format
pageSize <= 100
required documentId
```

---

# 45. Business Validation

Business validation includes:

```text
order can be approved
user can perform action
payment is permitted
document state allows deletion
workflow transition is valid
```

Keep it in application/domain.

Do not hide business rules inside HTTP validators.

---

# 46. Null Semantics

Do not use null/None to mean many different things.

Bad ambiguous meaning:

```text
null = not found?
null = failed?
null = not loaded?
null = empty?
```

Prefer language-appropriate constructs:

```text
Optional
Result
explicit NotFound error
empty collection
nullable value only when business-null is meaningful
```

Collections generally return:

```text
[]
```

rather than null.

---

# 47. Mutation

Prefer immutability when practical.

Protect important business state transitions.

Bad:

```text
order.status = APPROVED
order.approvedAt = now
```

scattered across services.

Good:

```text
order.approve(now)
```

The method enforces invariants.

---
