# Backend Policy Routing

Parent selects exact files, not logical labels.

| Change touches | Required/typical policy refs |
|---|---|
| catch/throw/error type/global handler | `exception-strategy.md` |
| log statement/level/error logging | `logging-policy.md` + often `exception-strategy.md` |
| controller/route/status/error response | `api-boundaries.md` + often `exception-strategy.md` |
| repository/ORM/query/transaction/locking | `persistence-transactions.md` |
| HTTP/RPC/vendor client/retry/timeout/consumer/job | `integrations-reliability.md` |
| auth/authz/input/upload/secret/security event | `security-validation.md` |

For a task spanning several concerns, include only the relevant files. Example error-handler edit:

```text
exception-strategy.md
logging-policy.md
api-boundaries.md
```

Example payment retry edit:

```text
integrations-reliability.md
exception-strategy.md
logging-policy.md
security-validation.md   (only if auth/secret handling changes)
```
