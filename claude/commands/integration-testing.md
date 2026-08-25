# Integration Testing

Test liên service: FE→MCRS→execute-service, Kafka, DB.

## Khi nào dùng
- Cross-service feature
- Kafka/event flow
- DB + service interaction
- External dependency integration

## Project Critical Flows
- FE → ai-agent-mcrs → ai-agent-excute-service
- trade-bot-mcrs → Kafka → develop-tool-consumer
- craw-service → Kafka → trade-bot-mcrs
- file upload/download via file-mcrs

## Checklist
- [ ] Service contract compatible
- [ ] Auth/token propagated
- [ ] CorrelationId propagated
- [ ] Retry/failure behavior tested
- [ ] DB state verified
- [ ] Event consumed idempotently
