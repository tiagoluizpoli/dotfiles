# AI configuration

These are Stow source files. Deploy them only through the repository's
no-folding Stow command; they map to the matching paths below `~`.

Included:

- `.agents/guidance/` — shared policy and capability-gap checks used by the
  global Claude and Codex instructions.
- `.claude/CLAUDE.md`, `settings.json`, and `agents/` — portable Claude
  instructions, presentation defaults, Worktrunk marketplace setting, and
  helper-agent definitions.
- `.codex/AGENTS.md`, `config.toml`, and `rules/default.rules` — portable
  Codex instructions, defaults, plugin marketplace setting, and safe Git
  approval rules.

Skills are intentionally not in this repository. They are installed and
maintained by the separate skills repository.

Authentication, MCP tokens, project trust, permission allowlists, hooks
managed by external tools, session history, logs, caches, and the Anthropic
credential store are intentionally local. The current Codex source config is
a portable baseline; use an explicit local Codex profile or command-line
override for a machine-specific integration rather than putting a secret in
this repository.
