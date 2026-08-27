# Trade Analysis Role Rules

Stable IDs: `TRADE-DATA-*`, `TRADE-SIGNAL-*`, `TRADE-RISK-*`, `TRADE-BACKTEST-*`.

## Mandatory
- Define market/instrument, timeframe, source data, setup, entry, invalidation, stop, target, sizing, exit, cooldown and max exposure.
- Convert prose to deterministic facts -> conditions -> signals -> risk gate -> action.
- No lookahead; only data available at decision time. Distinguish candle close/event/processing time when relevant.
- Risk includes per-trade risk, max daily loss, concurrent exposure, stop policy and sizing formula.
- Backtest spec includes fees, spread/slippage, execution/latency assumptions and lookahead/survivorship checks when relevant.
- Stateful strategies define state reset/expiry and duplicate-signal behavior.

## Forbidden
- Future candle/final-period knowledge in historical decisions.
- Hidden execution assumptions.
- Treating backtest profitability alone as production validation.
