# Backend API and Transport Boundaries

## Controller/transport responsibility

Controllers/handlers/adapters should primarily:

```text
parse transport input
apply boundary validation/auth context
call application/use-case API
map application result to transport response
```

Business rules/state transitions belong outside transport code.

## Central error mapping

Prefer the framework's centralized error boundary. Map stable application/domain errors to transport semantics there.

Examples:

```text
NotFound              -> 404
Validation            -> 400/422 per project contract
Conflict              -> 409
Unauthenticated       -> 401
Forbidden             -> 403
Dependency failure    -> 502/503/504 according to contract
Unexpected            -> 500
```

Do not make services depend on HTTP status codes.

## Public error shape

Keep a stable, safe response shape. Typical fields:

```text
error.code
error.message
requestId/correlationId when established
```

Never expose stack traces, SQL, internal class names, secret values, or raw sensitive upstream responses.

## Contract changes

Do not silently change status codes, required fields, field meanings/types, or error codes. A write task must explicitly authorize a public contract change and include compatibility/migration expectations.

## Validation

Validate untrusted transport input at the boundary or established validation layer. Domain invariants must still be enforced where domain/application truth lives; boundary validation alone is not a substitute for invariants.

## Shared Core Library & Common Utilities
- In multi-service repositories, check project note (CLAUDE.md/AGENTS.md) for the shared library (e.g. develop-tool-core-lib).
- Reusable utilities (e.g. StringUtil, DateUtil, JsonUtils, CacheUtil, RestTemplateUtil, common DTOs/Base classes) belong in develop-tool-core-lib/src/main/java/vn/devTool/core/utils/.
- Do not create duplicated util classes inside individual microservice modules (i-agent-mcrs, 	rade-bot-mcrs, etc.).
