# Shared cross-runtime content

Everything under `shared/skills` is canonical for both Claude Code and Codex CLI.

The sync scripts install platform-specific content first, then delete any local skill directory with the same name and copy the canonical shared version into both runtimes. This prevents stale files from older platform-specific copies.

Cross-runtime workflow files must not contain model/provider selection. Runtime-specific agent/model/MCP settings remain outside this directory.
