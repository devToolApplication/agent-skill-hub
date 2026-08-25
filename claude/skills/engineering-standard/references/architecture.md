# Architecture, Modules, and Language Mapping

# 1. Non-Negotiable Priorities

When multiple designs are possible, prioritize in this order:

```text
1. Correctness
2. Readability
3. Maintainability
4. Testability
5. Clear dependency boundaries
6. Extensibility
7. Operational safety
8. Performance based on evidence
9. Conciseness
```

Prefer:

```text
Explicit > Implicit
Simple > Clever
Readable > Short
Business language > Generic technical language
Composition > Inheritance
Stable boundaries > Convenient coupling
Locality > Premature reuse
Small coherent changes > Broad rewrites
Measured optimization > Guessing
Existing project convention > Inventing a second convention
```

Do not make code more abstract merely because abstraction appears more "architectural".

---

# 2. AI Operating Rule

Before changing code, determine:

```text
What is the requested behavior?
Which business module owns it?
Which layer should contain it?
What existing pattern already exists?
What is the public contract?
What dependencies are involved?
What can fail?
What tests prove the behavior?
What files actually need to change?
```

Do not immediately create files.

First inspect existing structure and reuse existing patterns where reasonable.

When the current repository has coherent conventions, preserve them unless the task explicitly asks for architectural change.

---

# 3. Default Project Architecture

For medium and large applications, prefer:

```text
project/
│
├── apps/
│   ├── api/
│   │   ├── bootstrap/
│   │   ├── config/
│   │   ├── middleware/
│   │   └── main.*
│   │
│   ├── worker/
│   │   └── main.*
│   │
│   └── scheduler/
│       └── main.*
│
├── modules/
│   ├── user/
│   │   ├── domain/
│   │   ├── application/
│   │   ├── infrastructure/
│   │   ├── interfaces/
│   │   ├── public/
│   │   └── tests/
│   │
│   ├── order/
│   │   └── ...
│   │
│   └── payment/
│       └── ...
│
├── shared/
│   ├── kernel/
│   ├── contracts/
│   ├── infrastructure/
│   ├── security/
│   ├── observability/
│   └── testing/
│
├── config/
├── migrations/
├── tests/
│   ├── integration/
│   ├── e2e/
│   └── performance/
├── docs/
│   ├── architecture/
│   ├── api/
│   └── adr/
├── scripts/
├── deploy/
│   ├── docker/
│   ├── k8s/
│   └── helm/
└── README.md
```

This is a logical architecture.

Map it to the language ecosystem instead of fighting the ecosystem.

---

# 4. Language Mapping

## 4.1 Java

Typical options:

```text
Gradle multi-module
Maven multi-module
Spring Boot application module
business modules as subprojects
```

Example:

```text
project/
├── app-api/
├── app-worker/
├── modules/
│   ├── user/
│   ├── order/
│   └── payment/
└── shared/
```

For very large systems, one business module may be physically split:

```text
user-domain
user-application
user-infrastructure
user-api
```

Do not split into many physical build modules unless the scale justifies the build complexity.

## 4.2 Node.js / TypeScript

Typical:

```text
pnpm workspace
npm workspace
yarn workspace
Nx/Turborepo if already justified
```

Example:

```text
apps/
├── api/
└── worker/

packages/
├── user/
├── order/
├── payment/
└── shared/
```

Framework may be:

```text
NestJS
Fastify
Express
Hono
```

Do not let the framework dictate business module ownership.

## 4.3 Python

Typical:

```text
src/
├── apps/
├── modules/
└── shared/
```

Use:

```text
uv
Poetry
pip-tools
```

according to the repository.

Framework may be:

```text
FastAPI
Django
Flask
Litestar
```

Django apps may serve as business modules, but do not allow arbitrary cross-app model access to destroy boundaries.

## 4.4 .NET

Typical:

```text
Solution
├── App.Api
├── App.Worker
├── Modules.User
├── Modules.Order
└── Shared
```

Large modules may use separate projects for Domain/Application/Infrastructure only when the extra compile-time boundary is worth the complexity.

## 4.5 Go

Typical:

```text
cmd/
├── api/
└── worker/

internal/
├── modules/
│   ├── user/
│   ├── order/
│   └── payment/
└── shared/
```

Prefer Go idioms and avoid importing heavyweight enterprise patterns unnecessarily.

## 4.6 Rust

Typical:

```text
Cargo workspace
crates/
├── api
├── user
├── order
└── shared
```

Use traits at real boundaries, not everywhere.

---

# 5. Root Architecture Rule

Do not organize a large project globally like this:

```text
src/
├── controllers/
├── services/
├── repositories/
├── entities/
└── utils/
```

Why this fails:

```text
controllers/
├── UserController
├── OrderController
├── PaymentController
├── WorkflowController
├── DocumentController
└── hundreds more...
```

Business concepts become scattered.

A feature change requires searching many unrelated folders.

Prefer:

```text
modules/
├── user/
├── order/
├── payment/
├── workflow/
└── document/
```

Each business module contains its own layers.

---

# 6. Module Definition

A module represents one business capability.

Good examples:

```text
identity
customer
user
order
payment
inventory
document
workflow
notification
reporting
billing
```

Poor module definitions:

```text
service
repository
controller
database
helper
common
utils
```

Those are technical categories, not business capabilities.

---

# 7. Standard Module Structure

Default:

```text
modules/<module>/
│
├── domain/
├── application/
├── infrastructure/
├── interfaces/
├── public/
└── tests/
```

Do not create folders that have no content merely to satisfy architecture diagrams.

A small CRUD module may initially be:

```text
module/
├── application/
├── infrastructure/
├── interfaces/
└── tests/
```

Add `domain/` only when domain logic actually exists.

Architecture should allow growth without requiring fake complexity.

---

# 8. Domain Layer

`domain/` contains pure business concepts.

Typical contents:

```text
domain/
├── entities/
├── value_objects/
├── services/
├── events/
├── repositories/
├── policies/
└── errors/
```

Examples:

```text
Order
OrderId
Money
OrderStatus
OrderCreated
OrderRepository
OrderApprovalPolicy
OrderAlreadyApprovedError
```

Domain must not depend directly on:

```text
Spring MVC
Express
FastAPI
Django REST Framework
Entity Framework
Hibernate
SQLAlchemy
Prisma
Kafka
RabbitMQ
Redis
S3
HTTP clients
vendor SDKs
```

Bad:

```text
OrderDomainService
    -> RestTemplate
    -> RedisClient
    -> EntityManager
```

Good:

```text
OrderDomainService
    -> OrderRepository abstraction
    -> PricingPolicy
```

Infrastructure supplies implementations.

---

# 9. Application Layer

`application/` contains use cases and orchestration.

Typical:

```text
application/
├── commands/
├── queries/
├── use_cases/
├── dto/
├── ports/
└── mappers/
```

Example flow:

```text
CreateOrder
    validate business prerequisites
    load customer
    construct order
    save order
    publish event
```

Application may coordinate multiple domain concepts.

Application should not contain:

```text
raw HTTP parsing
framework route annotations
SQL strings
ORM-specific query builders
Kafka serialization details
provider-specific HTTP headers
```

---

# 10. Infrastructure Layer

`infrastructure/` contains vendor and technical details.

Typical:

```text
infrastructure/
├── persistence/
│   ├── models/
│   ├── mappers/
│   └── repositories/
├── messaging/
├── cache/
├── clients/
├── storage/
└── configuration/
```

Examples:

```text
PostgresOrderRepository
RedisOrderCache
KafkaOrderEventPublisher
StripePaymentClient
S3DocumentStorage
KeycloakIdentityClient
```

Infrastructure can change without rewriting the business logic.

Target:

```text
Postgres -> MongoDB
Kafka -> RabbitMQ
S3 -> MinIO
Provider A -> Provider B
```

should mainly affect infrastructure and composition.

---

# 11. Interfaces Layer

`interfaces/` contains inbound adapters.

Typical:

```text
interfaces/
├── http/
│   ├── routes/
│   ├── controllers/
│   ├── requests/
│   └── responses/
├── grpc/
├── messaging/
│   └── consumers/
├── websocket/
└── cli/
```

Controller responsibility:

```text
receive transport input
validate transport structure
authenticate/authorize through project policy
convert to command/query
call application
map result to transport response
```

Controller must not become a business service.

Bad:

```text
POST /orders
    validate customer status
    calculate price
    query inventory
    insert SQL
    call payment API
    publish Kafka
    build response
```

Good:

```text
POST /orders
    parse request
    command = CreateOrderCommand(...)
    result = createOrder.execute(command)
    return mapResponse(result)
```

---

# 12. Public Module Contract

Each module may expose:

```text
public/
├── api/
├── contracts/
└── events/
```

Other modules should consume only this public surface.

Allowed:

```text
Order -> User.Public.UserReader
Payment -> Order.Public.OrderReader
Notification -> public domain events
```

Avoid:

```text
Order -> User.Infrastructure.UserRepository
Order -> User.Domain.InternalUserEntity
Order -> User.PrivateService
```

Why:

- internal refactoring becomes safer;
- module ownership remains clear;
- coupling becomes visible;
- microservice extraction is easier later.

---

# 13. Dependency Direction

Default:

```text
interfaces
    ↓
application
    ↓
domain
```

Infrastructure points inward conceptually by implementing required abstractions.

Do not allow:

```text
domain -> infrastructure
domain -> HTTP
domain -> database driver
application -> controller
```

Composition root wires dependencies.

---

# 14. Apps Layer

`apps/` is the executable/composition layer.

Typical responsibilities:

```text
load configuration
initialize logging
initialize tracing
initialize database
initialize cache
initialize messaging
construct modules
register routes
register consumers
start process
graceful shutdown
```

`apps/api` must not contain feature business logic.

Bad:

```text
apps/api/services/UserService
apps/api/repositories/UserRepository
```

Good:

```text
apps/api/bootstrap
apps/api/main
modules/user/...
```

---

# 15. Module Dependency Rules

Maintain an explicit module dependency graph for large projects.

Example:

```text
User
 └── none

Order
 └── User.Public

Payment
 └── Order.Public

Notification
 └── events from User/Order/Payment
```

Avoid cycles:

```text
User -> Order -> Payment -> User
```

If a cycle appears, consider:

- moving the concept to the correct owner;
- using an event;
- introducing a small shared contract;
- separating orchestration from domain ownership.

Do not solve cycles with random dependency injection tricks.

---

# 16. Database Ownership

Every table/collection has one owner.

Example:

```text
users                 -> User
user_roles            -> User
orders                -> Order
order_items           -> Order
payments              -> Payment
payment_transactions  -> Payment
documents              -> Document
```

A module should not directly mutate another module's storage.

Bad:

```text
Payment module:
UPDATE orders SET status = 'PAID'
```

Good:

```text
Payment -> Order.Public.MarkPaid(...)
```

or:

```text
PaymentCompleted event
    -> Order subscriber
```

Cross-module reads may sometimes be acceptable, but must be intentional.

Do not normalize accidental coupling into the design.

---

# 17. Shared Folder Rules

`shared/` should reduce real duplication without becoming a dumping ground.

A practical structure may include:

```text
shared/
├── utils/
│   ├── StringUtil
│   ├── TimeUtil
│   ├── DateUtil
│   ├── CollectionUtil
│   ├── NumberUtil
│   ├── JsonUtil
│   └── EncodingUtil
├── kernel/
├── contracts/
├── observability/
├── security/
├── infrastructure/
└── testing/
```

Focused generic utilities are valid shared code.

Good candidates:

```text
StringUtil
TimeUtil
DateUtil
CollectionUtil
NumberUtil
JsonUtil
EncodingUtil
Pagination
Result
Clock
Identifier
BaseError
Tracing
Logging
Generic config helpers
Generic messaging envelope
```

Avoid vague catch-all names:

```text
CommonUtil
CommonUtils
CommonService
Helper
GeneralUtil
MiscUtil
AllInOneHelper
```

Also avoid business-specific utilities in global shared:

```text
UserUtils
OrderHelper
PaymentCommonService
DocumentUtils
```

The rule is not "Utils are forbidden". The rule is:

```text
StringUtil       -> bounded technical scope -> allowed
TimeUtil         -> bounded technical scope -> allowed
CommonUtil       -> unknown/unbounded scope -> avoid
OrderUtil        -> business-owned concept  -> keep in Order module
```

A shared utility should normally be business-neutral, narrow, stateless/pure when practical, and reusable by unrelated modules.

If behavior depends on infrastructure or runtime state, prefer a service/port rather than hiding it behind `*Util`.

Bad:

```text
PaymentUtil.charge()
EmailUtil.send()
DatabaseUtil.save()
```

Good:

```text
StringUtil.normalizeWhitespace()
TimeUtil.parseIsoDate()
CollectionUtil.chunk()
EncodingUtil.base64Encode()
```

If the code contains a strong business concept such as `User`, `Order`, `Payment`, `Document`, or `Workflow`, it probably belongs to that business module even if reused several times there.

Before moving code to shared, answer:

```text
Is it business-neutral?
Does the class/module name define a narrow technical scope?
Will unrelated modules reuse the same semantics?
Does it add consistency/reuse beyond merely wrapping the standard library?
Would a service/adapter be more accurate than a utility?
```

Foundational utilities such as `StringUtil`, `TimeUtil`, or a canonical `JsonUtil` may be created before duplicate use appears when they establish a project-wide convention. Ordinary helpers should usually be extracted only after reuse is real.

See `references/shared-utilities.md` for detailed rules and language examples.

---


## Shared utility placement decision

Use this quick decision tree:

```text
Does the code express a business concept/rule?
    YES -> owning module
    NO  -> continue

Is it a narrow technical transformation/helper?
    NO  -> choose a service/adapter/other explicit abstraction
    YES -> continue

Can unrelated modules use the same semantics?
    NO  -> keep local
    YES -> continue

Does it hide network/DB/broker/storage or mutable runtime state?
    YES -> service/client/repository/adapter
    NO  -> shared utility is appropriate
```

Examples:

```text
StringUtil.normalizeWhitespace      -> shared/utils
TimeUtil.parseIsoDate               -> shared/utils
JsonUtil.serializeCanonical         -> shared/utils
CollectionUtil.chunk                -> shared/utils

OrderNumberFormatter                -> Order module
OrderUtil.canApprove                -> Order module/domain policy
PaymentUtil.charge                  -> Payment service/gateway
EmailUtil.send                      -> Email service/adapter
DatabaseUtil.save                   -> Repository/infrastructure
CommonUtil                          -> split by technical responsibility
```

See `references/shared-utilities.md` for the full utility convention.


# 18. Duplication vs Abstraction

Do not abstract on first duplication.

Guideline:

```text
1 occurrence   local code
2 occurrences  observe pattern
3+ occurrences evaluate whether the behavior is truly the same
```

A little duplication is cheaper than a wrong shared abstraction.

Do not create:

```text
AbstractGenericBaseCrudService<T, ID, REQ, RES, REPO>
```

only to eliminate a few repeated CRUD lines.

---
