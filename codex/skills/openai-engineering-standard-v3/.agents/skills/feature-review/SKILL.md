---
name: feature-review
description: Run a structured multi-agent review of a completed feature, branch, pull request diff, refactor, API change, persistence change, or risky code modification. Spawn specialized read-only reviewers in parallel for architecture, correctness, maintainability, tests, security, and reliability/performance; deduplicate findings and return a severity-ranked verdict with file and line evidence. Do not use for trivial one-line changes unless explicitly requested.
---

# Feature Review

Use after implementation and before considering a non-trivial feature complete.

## 1. Determine review scope

Prefer:

1. User-specified files/commit/PR range.
2. Current branch vs merge-base with target branch.
3. Staged + unstaged changes when no branch range is available.
4. Explicit feature files.

Inspect enough surrounding code, callers, contracts, migrations, and tests to validate behavior. Do not expand into unrelated legacy cleanup.

## 2. Build a shared review brief

Give every reviewer:

- requested feature intent;
- review range/diff;
- changed files;
- relevant constraints;
- instruction to read `.agents/skills/engineering-standard/SKILL.md`;
- output contract from `references/review-contract.md`.

## 3. Spawn six reviewers in parallel

Use these custom agents:

```text
architecture_reviewer
correctness_reviewer
maintainability_reviewer
test_reviewer
security_reviewer
reliability_performance_reviewer
```

They are independent read-only reviews. Do not ask them to edit code.

If named project agents cannot be selected in the current runtime, spawn generic read-only subagents and instruct each one to read the matching `.codex/agents/*.toml` file before reviewing.

## 4. Collect all results

Wait for all requested reviewers before synthesis. `NO_FINDINGS` is valid. Do not invent findings to fill a quota.

## 5. Validate and deduplicate

For every finding:

1. Verify file/line or symbol evidence.
2. Merge findings with the same root cause.
3. Preserve the strongest evidence from all reviewers.
4. Use the highest justified severity, not automatically the highest claimed severity.
5. Drop speculation without a plausible failure mode.
6. Keep distinct consequences separate when fixes differ.

Use `references/severity.md`.

## 6. Verdict

`PASS` only when there are no justified blocking P0/P1/P2 findings.

`CHANGES_REQUIRED` when at least one blocking P0/P1/P2 finding should be fixed before merge.

P3 is normally non-blocking.

## 7. Final output

```markdown
# Feature Review

Verdict: PASS | CHANGES_REQUIRED

## Blocking findings

1. [P1][correctness] Short title — `path/file.ext:123`
   - Evidence:
   - Failure scenario:
   - Impact:
   - Recommended fix:
   - Confidence: high|medium

## Non-blocking findings

...

## Review coverage

- Architecture: ...
- Correctness: ...
- Maintainability: ...
- Tests: ...
- Security: ...
- Reliability/Performance: ...

## Verification notes

- Review range:
- Tests/build inspected or run:
- Assumptions:
```

Do not hide reviewer findings behind a vague summary.
