# Trade Analysis Skill Workflow

```text
REQUIREMENT -> DATA_DEFINITION -> STRATEGY_FORMALIZATION -> RISK_RULES -> EXECUTION_RULES -> BACKTEST_SPEC -> SELF_REVIEW -> HANDOFF
```

- REQUIREMENT: skill `requirement-analysis`.
- DATA_DEFINITION: skill `data-requirement-spec`; define instrument/timeframe/events/availability timing.
- STRATEGY_FORMALIZATION: convert prose into deterministic facts -> conditions -> signal.
- RISK_RULES: define per-trade and portfolio/session limits, stop/TP and sizing.
- EXECUTION_RULES: define action, duplicate/cooldown/state expiry and invalidation behavior.
- BACKTEST_SPEC: specify fees/spread/slippage/latency and anti-lookahead/survivorship checks.
- SELF_REVIEW: skill `technical-risk-assessment`; verify no future data and all execution assumptions are explicit.
- HANDOFF: machine-implementable rules plus risk/backtest acceptance criteria.
