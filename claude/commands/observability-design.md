# Observability Design

Logging, tracing, metrics, correlation ID, dashboard strategy.

## Khi nào dùng
- Thiết kế observability cho service/feature
- Debug production flow
- Define logs/metrics/traces
- Setup dashboard/alerts

## Required Signals
- Logs: structured JSON, correlationId, userId/serviceId, action, result
- Metrics: latency, error rate, throughput, saturation
- Traces: cross-service request path
- Events: important business/audit actions

## Project Rules
- Propagate correlationId across FE → MCRS → execute-service
- Use requestFilter.get() for request data in Java services
- Mask secrets/tokens/PII in logs

## Output
- Log fields
- Metrics list
- Trace spans
- Dashboard panels
- Alert thresholds

## Checklist
- [ ] CorrelationId propagated
- [ ] Sensitive data masked
- [ ] RED metrics for APIs
- [ ] Consumer lag metrics for Kafka
- [ ] Agent run lifecycle observable
