# OpenAI/Codex Engineering Standard Bundle

Structured for the current Codex skill + custom-subagent model.

## Tree

```text
.agents/skills/
├── engineering-standard/
│   ├── SKILL.md
│   └── references/
└── feature-review/
    ├── SKILL.md
    └── references/

.codex/
├── agents/
│   ├── architecture-reviewer.toml
│   ├── correctness-reviewer.toml
│   ├── maintainability-reviewer.toml
│   ├── test-reviewer.toml
│   ├── security-reviewer.toml
│   └── reliability-performance-reviewer.toml
└── config.toml.example

AGENTS.md.example
```

## Install

Copy `.agents/skills/` and `.codex/agents/` into the repository root.

Merge `.codex/config.toml.example` into an existing `.codex/config.toml`; do not overwrite unrelated settings.

If the repo has no `AGENTS.md`, copy `AGENTS.md.example` to `AGENTS.md`. If one exists, merge only the relevant instructions.

## Design

`engineering-standard` is intentionally small and uses progressive disclosure: detailed rules are in references and loaded only when relevant. Shared technical reuse has its own `references/shared-utilities.md` so utility rules do not pollute every coding task.

`feature-review` is a multi-agent review orchestrator. It runs six independent read-only reviews, then the parent agent validates, deduplicates, assigns final severity, and returns `PASS` or `CHANGES_REQUIRED`.

Reviewer TOML files intentionally do not pin a model, so they remain portable across model/provider setups. Add `model` or `model_reasoning_effort` only if your environment requires it.

## Suggested prompts

```text
Use engineering-standard and implement this feature. After implementation, run feature-review with all reviewers.
```

```text
Use feature-review to review this branch against main.
```

## Shared utilities convention

The engineering skill explicitly allows narrow generic utilities such as `StringUtil`, `TimeUtil`, `DateUtil`, `CollectionUtil`, and `JsonUtil`. It rejects vague catch-all classes such as `CommonUtil`, `CommonService`, and `Helper`, and keeps business-specific helpers inside their owning module.


### Utility placement summary

```text
shared/utils/StringUtil        -> OK: bounded technical concern
shared/utils/TimeUtil          -> OK: parsing/formatting/conversion
shared/utils/JsonUtil          -> OK: canonical project JSON behavior

shared/CommonUtil              -> avoid: unbounded concern
shared/OrderUtil               -> avoid: business owner is Order
shared/PaymentUtil.charge      -> avoid: integration/service hidden as util
```

`Util` is not considered an anti-pattern by itself. Scope and ownership decide whether it belongs in shared.
