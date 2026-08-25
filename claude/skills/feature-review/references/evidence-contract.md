# Review Evidence Contract v4

BE/FE evidence workers return the standard `worker-result-v5` with concrete facts. The strong parent validates/deduplicates, assigns severity, chooses fix direction, and creates any write-task-v5.

Recommended finding fact shape inside `facts[]`:

```json
{
  "rule_id": "BE-ERR-001",
  "file": "src/order/OrderService.java",
  "line": "82-86",
  "symbol": "OrderService.approve",
  "fact": "The catch logs ERROR and rethrows the same exception.",
  "confidence": "high"
}
```

Evidence workers do not assign final severity or verdict.

UIUX design-contract checking does not use this evidence shape as a substitute for UX judgment; use `uiux_spec_verify` and requirement coverage in `worker-result-v5`.
