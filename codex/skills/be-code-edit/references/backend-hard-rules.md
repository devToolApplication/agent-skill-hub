# BE Edit Guard & Coding Rules

Before PASS verify:

- no generic catch/log/rethrow introduced;
- final logging ownership remains single and intentional;
- expected business rejection is not incorrectly promoted to ERROR unless policy says so;
- no HTTP semantics leaked into service/domain;
- transaction boundary did not silently expand;
- integration retry/fallback behavior follows existing policy;
- no security/validation/test weakening;
- all changed files are exactly authorized.

## Core Library & Utility Boundary Policy:
1. **Locate Utilities**:
   - Check project note (CLAUDE.md/AGENTS.md) for shared core library: develop-tool-core-lib (n.devTool.core.utils.*).
   - Reuse existing utilities: CacheUtil, MapperUtil, RestTemplateUtil, JsonUtils, DateUtil, CommonUtil, StringUtils, ListUtil.
2. **When to put in Util vs Class/Service**:
   - **Put into Core Lib Util (develop-tool-core-lib)**: Pure technical, deterministic, business-neutral helpers (string format, date/time calculation, json parsing, cache access, generic collections) usable across microservices.
   - **Keep in Service/Class**: Business rules, stateful workflows, domain validations (e.g. isOrderCancelable, calculateAgentFee), or repository-bound operations.
3. **Object & DTO Mapping Policy (Mapper First)**:
   - **Always prioritize MapperUtil / ModelMapper first** (mapperUtil.map(source, Target.class), mapList, mapPage, mapTo).
   - **Only do manual mapping (builder / setters)** when properties diverge drastically or require complex custom computations.
   - **Hybrid mapping**: Even when custom field logic is required, use MapperUtil to map matching fields first, then selectively override only the special fields. Never write boilerplate manual setters for 10+ matching fields.
