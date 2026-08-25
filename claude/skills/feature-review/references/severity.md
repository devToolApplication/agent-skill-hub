# Severity

## P0 — Critical

Severe immediate risk such as likely destructive data loss, serious auth bypass/secret exposure, injection/RCE, production-wide outage path, or irreversible financial/security impact. Blocks merge.

## P1 — High

Concrete serious defect likely to affect users/system integrity: incorrect business state, major authorization flaw, broken public compatibility, duplicate financial transaction risk, common-path runtime failure, race causing incorrect persisted state. Blocks merge.

## P2 — Medium

Real narrower defect/risk: important edge case, credible missing regression coverage, unsafe module coupling, timeout/resource issue under realistic conditions, N+1/unbounded query with production impact, misleading error translation. Normally blocks production merge unless consciously accepted.

## P3 — Low / non-blocking

Useful maintainability, observability, defensive, naming, or low-risk test improvement with limited immediate impact.

## Not a finding

Do not report subjective style preferences, merely different architecture, hypothetical risks with no plausible path, unrelated legacy debt, or formatter-only issues.
