# API Contract Design

Thiết kế REST/GraphQL contract, DTO, versioning, backward compatibility.

## Khi nào dùng
- Tạo/sửa API public giữa FE-BE hoặc service-service
- Define DTO/schema
- Review breaking changes
- Thiết kế error response

## REST Contract Rules
- Resource nouns, not verbs
- Stable DTOs; internal entity không leak ra API
- Backward compatible by default
- Pagination/filter/sort explicit
- Error response standardized
- Auth/permission documented per endpoint

## Output template
```md
## Endpoint
METHOD /path

## Purpose
...

## Auth
Role/permission required

## Request
Path params, query params, body schema

## Response
Success schema + examples

## Errors
400/401/403/404/409/422/500

## Compatibility
Breaking/non-breaking changes
```

## Checklist
- [ ] DTO không expose internal fields
- [ ] Validation rules rõ
- [ ] Error codes consistent
- [ ] Pagination defined for lists
- [ ] Idempotency considered for write APIs
- [ ] Versioning strategy clear
