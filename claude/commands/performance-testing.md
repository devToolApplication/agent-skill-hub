# Performance Testing

Load/performance test, Core Web Vitals, API latency.

## Khi nào dùng
- Test response time/API latency
- Validate Core Web Vitals
- Check load under concurrency
- Regression after performance-sensitive change

## FE Metrics
- LCP <= 2.5s
- INP <= 200ms
- CLS <= 0.1
- Bundle size within budget

## BE Metrics
- p95 latency
- error rate
- throughput
- DB query latency
- Kafka lag
- memory/CPU saturation

## Checklist
- [ ] Baseline captured
- [ ] p95/p99 latency measured
- [ ] Core Web Vitals checked if FE
- [ ] Slow queries identified
- [ ] Resource saturation checked
- [ ] Performance regression documented
