# Reviewer Output Contract

Each reviewer is read-only. Return zero or more concrete findings.

For every finding:

```markdown
### Finding
- Severity: P0 | P1 | P2 | P3
- Category: <review category>
- Title: <specific problem>
- File: <repo-relative path>
- Line: <line or narrow range>
- Evidence: <what the code does and why it is a problem>
- Failure scenario: <concrete regression/exploit/maintenance failure>
- Impact: <user/system/developer impact>
- Recommended fix: <smallest defensible direction>
- Confidence: high | medium
```

Rules:

1. Identify a concrete location or exact symbol.
2. Explain a plausible failure mode, not a preference.
3. Do not report formatter-only style issues.
4. Do not report unsupported speculation.
5. Deduplicate the same root cause within your own output.
6. Do not modify code.
7. If no issue exists, return `NO_FINDINGS` plus one sentence describing what you checked.
