# Business Process Modeling

Flow nghiệp vụ, state machine, actor/system interaction.

## Khi nào dùng
- Quy trình nhiều bước
- State transition phức tạp
- Có nhiều actor/system tham gia

## Output options
- Process flow
- State machine
- Sequence diagram
- Actor interaction matrix

## State Machine Template
```md
## States
Draft → Submitted → Approved → Executed → Completed

## Transitions
| From | Event | To | Guard | Side effects |
|---|---|---|---|---|
```

## Flow Template
```md
1. Actor action
2. System validation
3. System processing
4. External integration
5. Result/notification
```

## Checklist
- [ ] All actors identified
- [ ] Start/end states clear
- [ ] Error/rollback flows included
- [ ] State transitions have guards
