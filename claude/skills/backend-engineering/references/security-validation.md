# Backend Security and Validation Policy

Treat HTTP/RPC input, headers/cookies, JWT claims, queue/webhook payloads, uploads, external API responses, and user-provided URLs as untrusted until validated/verified as appropriate.

## Authentication vs authorization

Authentication answers who the caller is. Authorization answers whether that caller may perform the action on the target resource.

Do not scatter magic-role checks across unrelated services. Prefer established permission/policy mechanisms.

## Validation

Use allowlists/bounds for fields, sizes, batches, date ranges, query sizes, uploads, and URLs where resource abuse or unsafe input is possible.

## Secrets and logs

Never hard-code or log credentials, tokens, passwords, keys, OTPs, authorization headers, or secret-bearing payloads.

## Injection and unsafe execution

Use parameterized queries/ORM APIs, safe command/process construction, path normalization, and output encoding appropriate to the context. Do not concatenate untrusted input into SQL, shell commands, filesystem paths, or executable templates.

## Security/audit events

Sensitive actions such as permission changes, administrative overrides, security configuration changes, payment/approval actions, or repeated suspicious auth failures may require durable audit/security records. Follow the project policy; do not replace audit records with ordinary debug logs.
