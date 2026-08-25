# Security Architecture

AuthN/AuthZ, Keycloak, token flow, service-to-service security.

## Khi nào dùng
- Thiết kế login/auth flow
- Review permission model
- Service-to-service calls
- Token/session design
- Security boundary review

## Areas
- Authentication: who are you?
- Authorization: what can you do?
- Token propagation: user token vs service token
- Network boundary: internal/external APIs
- Secrets management
- Audit logging

## Output
- Trust boundaries
- Actor/service matrix
- Token flow diagram
- Permission model
- Threats + mitigations
- Audit requirements

## Checklist
- [ ] External/internal endpoints separated
- [ ] Least privilege roles/scopes
- [ ] Service-to-service auth defined
- [ ] Token validation/audience checked
- [ ] Sensitive data masked in logs
- [ ] Audit events for privileged actions
- [ ] No secrets in repo/config output
