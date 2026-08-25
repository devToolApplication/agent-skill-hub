# Security Testing

Auth, permission, token, input validation, basic abuse cases.

## Khi nào dùng
- Test auth/permission changes
- API accepts user input
- Token/service-to-service flow
- Sensitive data handling

## Coverage
- Missing/invalid/expired token
- Insufficient role/scope
- Horizontal privilege escalation
- Input validation/injection
- Sensitive data in logs/responses
- Rate limit/abuse basics
- File upload restrictions

## Checklist
- [ ] Unauthorized returns 401
- [ ] Forbidden returns 403
- [ ] Cross-user access blocked
- [ ] Input validation enforced
- [ ] No secrets/tokens in response/log
- [ ] File upload validates type/size
- [ ] Service-to-service auth checked
