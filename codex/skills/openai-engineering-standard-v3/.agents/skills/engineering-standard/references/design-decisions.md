# Documentation, Compatibility, Exceptions, and Design Decisions

# 118. Documentation

Documentation should explain:

```text
architecture
public contracts
non-obvious operational behavior
deployment requirements
important decisions
```

Do not duplicate every code detail into docs.

Code is the source for implementation behavior.

---

# 119. ADR

Use Architecture Decision Records for important decisions such as:

```text
database choice
messaging model
module boundary
authentication strategy
multi-tenancy
event sourcing
major migration approach
```

An ADR should capture:

```text
context
decision
alternatives
consequences
```

---

# 120. Existing Project Compatibility

Do not automatically rewrite a mature codebase into this exact folder structure.

When a project has stable conventions:

```text
follow them
preserve consistency
improve incrementally
avoid a second architecture
```

Architecture purity is less important than coherent maintainability.

---

# 121. Small Project Exception

For a small service, simpler structure may be better.

Example:

```text
src/
├── users/
├── orders/
├── shared/
└── main.*
```

Do not force six nested layers when there are only five endpoints.

The important rules remain:

```text
clear ownership
business logic not mixed with transport
dependency direction
readability
testability
```

---

# 122. CRUD Exception

Simple CRUD does not require elaborate domain modeling.

Do not create:

```text
AggregateRoot
DomainEvent
Policy
Factory
RepositoryPort
Adapter
```

when the feature simply stores a lookup table with no meaningful business rules.

Introduce complexity only as requirements demand it.

---

# 123. When to Create Domain Layer

Create richer domain code when behavior includes:

```text
state transitions
invariants
business calculations
business policies
complex validation
cross-field rules
domain events
```

Do not create domain objects that merely mirror a DB row without behavior unless that abstraction serves a real purpose.

---

# 124. When to Use Events

Use events for:

```text
side effects
loose coupling
asynchronous workflows
multiple independent reactions
integration boundaries
```

Do not use events when a direct call is clearer and synchronous behavior is required.

---

# 125. When to Use Message Broker

Use Kafka/RabbitMQ/NATS/etc. when there is a real need:

```text
asynchrony
buffering
decoupling
independent scaling
durability
fan-out
integration
```

Do not introduce a broker simply because microservices often have one.

---

# 126. When to Use Shared Kernel / Shared Utilities

Use the shared kernel only for highly stable, truly cross-cutting concepts.

Use `shared/utils` for narrow, generic technical helpers such as:

```text
StringUtil
TimeUtil
DateUtil
CollectionUtil
JsonUtil
EncodingUtil
```

Do not treat all `*Util` classes as an anti-pattern. A focused utility with clear technical scope is preferable to copying the same generic behavior into many modules.

Avoid vague catch-all names such as `CommonUtil`, `CommonService`, `Helper`, or `MiscUtil`.

Keep both the shared kernel and shared utilities bounded. A utility that starts accumulating business rules or unrelated concerns should be split or moved to its owning module.

---

# 156. Decision Heuristic: Where Does Code Belong?

Ask:

```text
Is it business truth?
    -> domain

Is it a use case/orchestration?
    -> application

Is it DB/vendor/framework implementation?
    -> infrastructure

Is it HTTP/gRPC/consumer input-output?
    -> interfaces

Is it a stable contract other modules consume?
    -> public

Is it generic and business-neutral?
    -> shared
```

---

# 157. Decision Heuristic: Should I Create an Interface?

Create one if:

```text
there are multiple implementations
it isolates an external boundary
it improves testability materially
it protects business logic from a vendor/framework
```

Do not create one merely because:

```text
"clean architecture says everything needs an interface"
```

---

# 158. Decision Heuristic: Should I Move It to Shared?

Move to shared when:

```text
it is business-neutral
it has a narrow technical scope
unrelated modules can reuse the same semantics
it improves consistency or removes real duplication
the abstraction is stable enough for shared ownership
```

A foundational utility such as `StringUtil`, `TimeUtil`, or a canonical `JsonUtil` may be shared from the start if it defines a project-wide convention.

Do not move business-specific helpers such as `OrderUtil` or `UserHelper` to global shared merely because several classes call them. Keep those in the owning module.

If the utility name would have to be `CommonUtil`, the responsibility is probably too broad.

---

# 159. Decision Heuristic: Should I Split a Function?

Split when:

```text
it performs multiple conceptual steps
nesting is difficult to follow
the name no longer describes everything it does
part of the logic has independent meaning
testing a part independently adds value
```

Do not split when the extracted function would be meaningless:

```text
doStep1()
doStep2()
doStep3()
```

---

# 160. Decision Heuristic: Should I Add a New Module?

Create a module when the capability has:

```text
clear business ownership
its own lifecycle/rules
meaningful internal cohesion
need for a stable boundary
```

Do not create a module for every entity/table.

---

# 161. Decision Heuristic: Should I Add an Event?

Use an event when:

```text
a business fact occurred
multiple consumers may react
publisher should not own all reactions
asynchrony is acceptable/useful
```

Use a direct call when:

```text
caller requires immediate result
workflow is simple
extra indirection hurts clarity
```

---

# 162. Decision Heuristic: Should I Add Cache?

Add cache when:

```text
there is a measured or obvious repeated expensive read
staleness semantics are understood
invalidation strategy is clear
```

Do not add cache before deciding what happens when it is stale.

---

# 163. Decision Heuristic: Should I Optimize?

Only after:

```text
measuring
profiling
identifying actual bottleneck
```

Do not optimize just because a loop "looks slow".

---
