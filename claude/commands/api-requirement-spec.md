# API Requirement Specification

Đặc tả nghiệp vụ cho API: input/output, validation, permission, error behavior.

## Khi nào dùng
- BA cần handoff yêu cầu API cho Dev BE
- Feature có integration hoặc public contract

## Output Template
```md
## Capability
Business purpose

## Actor & Permission
Who can call, required role/scope

## Input
Fields, types, required/optional, validation

## Output
Expected business response

## Business Errors
Condition → expected error code/message

## Idempotency
Duplicate request behavior
```

## Checklist
- [ ] Required/optional fields rõ
- [ ] Validation và business errors rõ
- [ ] Permission rules rõ
- [ ] Duplicate handling rõ
- [ ] Không leak implementation details
