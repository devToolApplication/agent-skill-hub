# Shared Utilities and Reusable Technical Classes

## Goal

Avoid rewriting the same generic technical logic across modules while preventing `shared/` from becoming a business dumping ground.

The rule is not "never use Utils".

The rule is:

```text
Scoped technical utility name   -> allowed
Vague catch-all common name     -> avoid
Business-specific utility       -> keep in owning module
```

Good shared utility names:

```text
StringUtil
TimeUtil
DateUtil
NumberUtil
CollectionUtil
JsonUtil
EncodingUtil
HashUtil
UrlUtil
FileNameUtil
PaginationUtil
```

Bad names:

```text
CommonUtil
CommonUtils
CommonService
Helper
Helpers
GeneralUtil
MiscUtil
AppUtil
BaseUtil
AllInOneUtil
```

The difference is scope. `StringUtil` tells the reader what kind of behavior belongs there. `CommonUtil` does not.

---

# 1. Recommended Shared Structure

A practical shared layout may be:

```text
shared/
├── utils/
│   ├── StringUtil
│   ├── TimeUtil
│   ├── DateUtil
│   ├── NumberUtil
│   ├── CollectionUtil
│   ├── JsonUtil
│   ├── EncodingUtil
│   └── UrlUtil
│
├── kernel/
│   ├── Result
│   ├── Identifier
│   └── Clock
│
├── contracts/
├── observability/
├── security/
├── infrastructure/
└── testing/
```

Do not force every project to create all of these. Add only what the repository uses.

---

# 2. Utility Class Requirements

A class/module may live in `shared/utils` when all of the following are true:

1. It is business-neutral.
2. Its responsibility is narrow and clear from the name.
3. It can be reused safely by unrelated modules.
4. It does not require knowledge of `User`, `Order`, `Payment`, or another business capability.
5. It does not hide a workflow or business service behind a utility name.
6. Its behavior is stable and unsurprising.

A utility should preferably be:

```text
pure
deterministic
stateless
small
well-named
easy to unit test
```

I/O is not automatically forbidden, but technical integrations usually belong in a client/service/adapter instead of `*Util`.

---

# 3. StringUtil

Good responsibilities:

```text
isBlank(value)
isNotBlank(value)
trimToNull(value)
trimToEmpty(value)
normalizeWhitespace(value)
truncate(value, maxLength)
mask(value, visiblePrefix, visibleSuffix)
toSnakeCase(value)
toCamelCase(value)
removeAccents(value)
```

Only add helpers that provide project value or standardize behavior.

Do not re-wrap the entire language standard library.

Bad:

```text
StringUtil.createOrderCode(order)
StringUtil.getUserDisplayName(user)
```

Those belong to business/domain code.

---

# 4. TimeUtil / DateUtil

Good responsibilities:

```text
parseIsoDate(value)
parseIsoDateTime(value)
formatIsoDate(value)
formatIsoDateTime(value)
toUtc(value)
startOfDay(value, zone)
endOfDay(value, zone)
isExpired(expireAt, now)
durationBetween(start, end)
```

Project-wide rules such as UTC normalization may be centralized here if that is the established convention.

However, current time itself should be testable.

For business logic, prefer an injectable `Clock`/`TimeProvider` rather than directly calling `TimeUtil.now()` everywhere.

Good:

```text
OrderService -> Clock.now()
TimeUtil -> parsing/formatting/conversion helpers
```

Avoid:

```text
TimeUtil.canCancelOrder(order)
```

That is a business rule.

---

# 5. CollectionUtil

Good generic responsibilities:

```text
isEmpty(collection)
isNotEmpty(collection)
chunk(collection, size)
distinctBy(collection, keySelector)
groupBy(...)
safeList(nullableCollection)
```

Do not add business filtering such as:

```text
CollectionUtil.getApprovedOrders(orders)
```

Prefer `Order` module logic.

---

# 6. JsonUtil

A shared `JsonUtil` is useful when it standardizes project-wide JSON behavior:

```text
serialize(value)
deserialize(text, type)
prettyPrint(value)
```

It may centralize:

```text
object mapper configuration
date/time format
unknown-field behavior
common modules/adapters
```

Do not put provider/business mappings inside it.

Bad:

```text
JsonUtil.toPaymentProviderRequest(payment)
```

That belongs to the payment provider adapter/mapper.

---

# 7. Validation Utilities

Be careful with `ValidationUtil`.

Generic technical validation can be shared:

```text
isValidEmailSyntax
isValidUuid
isValidUrl
requireRange
```

Business validation must not be moved there:

```text
canApproveOrder
canDeleteDocument
isEligibleForPayment
```

Those belong to domain/application policies.

---

# 8. Naming Rule

A utility name must define a bounded technical concern.

Allowed:

```text
StringUtil
TimeUtil
DateUtil
CollectionUtil
JsonUtil
```

Avoid:

```text
CommonUtil
CommonUtils
Helper
CommonHelper
GeneralUtil
SystemUtil
```

If the name cannot tell a developer what belongs in the class, the scope is too broad.

---

# 9. Static vs Injectable

Static/module-level functions are appropriate for pure deterministic utilities.

Examples:

```text
StringUtil.normalizeWhitespace
CollectionUtil.chunk
EncodingUtil.base64Encode
```

Prefer an injectable service/port when behavior depends on runtime state or infrastructure:

```text
Clock / TimeProvider
IdGenerator
PasswordHasher
FileStorage
JsonSerializer when runtime config varies
```

Do not use static global utilities to hide dependencies.

Bad:

```text
PaymentUtil.charge()
EmailUtil.send()
DatabaseUtil.save()
```

Those are services/adapters, not utilities.

---

# 10. Reuse Threshold

Two acceptable paths exist.

## Extract after reuse appears

For ordinary helpers:

```text
first use  -> keep local
second real use -> consider extracting
third use -> strongly evaluate shared utility
```

## Foundational utility from the beginning

It is acceptable to create a shared utility immediately when it is clearly project-wide and generic, for example:

```text
StringUtil
TimeUtil
JsonUtil
```

provided the class remains narrow and does not mirror the entire standard library.

The goal is to prevent repeated project-specific behavior such as inconsistent trimming, date parsing, masking, or JSON configuration.

---

# 11. Avoid Wrapper-For-Wrapper Utilities

Do not create a utility that simply renames standard-library calls without adding consistency or semantics.

Weak:

```text
StringUtil.length(s) -> s.length
CollectionUtil.size(x) -> x.size
```

Useful:

```text
StringUtil.trimToNull
StringUtil.normalizeWhitespace
TimeUtil.parseProjectDate
JsonUtil using the canonical project serializer
```

A shared utility should reduce duplication or enforce one consistent behavior.

---

# 12. Keep Utility APIs Small

If a utility grows continuously, split by responsibility.

Bad:

```text
StringUtil
  strings
  dates
  encryption
  file paths
  JSON
  HTTP headers
```

Better:

```text
StringUtil
DateUtil
EncodingUtil
PathUtil
JsonUtil
HttpHeaderUtil
```

A utility class should be easy to scan.

---

# 13. Business-Specific Reuse

Reusable business logic should also avoid duplication, but it stays with the owning module.

Example:

```text
modules/order/domain/OrderNumberFormatter
modules/order/domain/OrderStatusPolicy
modules/payment/application/PaymentReferenceFactory
```

Do not move these to global shared merely because several classes in the same module use them.

---

# 14. Examples Across Languages

## Java

```text
shared/utils/StringUtil.java
shared/utils/TimeUtil.java
shared/utils/CollectionUtil.java
```

Pure helpers may be final classes with private constructors and static methods, or follow the project's established style.

## TypeScript / Node.js

Prefer focused modules/functions:

```text
shared/utils/string.util.ts
shared/utils/time.util.ts
shared/utils/collection.util.ts
```

A class is not required when plain exported functions are clearer.

## Python

Prefer modules/functions rather than artificial utility classes:

```text
shared/utils/string_utils.py
shared/utils/time_utils.py
shared/utils/collection_utils.py
```

Do not force Java-style static classes into Python.

The architecture is shared; syntax follows the language.

---

# 15. Review Checklist

Before adding a shared utility:

- [ ] Name identifies one technical concern.
- [ ] No business-module knowledge.
- [ ] No hidden I/O/infrastructure dependency.
- [ ] Behavior is reusable across unrelated modules.
- [ ] Existing project utility does not already provide it.
- [ ] It adds semantics/consistency beyond trivial standard-library wrapping.
- [ ] Public methods are small and predictable.
- [ ] Important edge cases have tests.

Before adding a method to an existing utility:

- [ ] Method belongs to that utility's scope.
- [ ] It does not make the class a `CommonUtil` in disguise.
- [ ] It does not contain business rules.
- [ ] It does not hide a service/integration call.
