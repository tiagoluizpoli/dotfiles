# AI configuration

These are Stow source files. Deploy them only through the repository's
no-folding Stow command; they map to the matching paths below `~`.

Included:

- `.agents/guidance/` — shared policy and capability-gap checks used by the
  global Claude and Codex instructions.
- `.claude/CLAUDE.md`, `settings.json`, and `hooks/` — portable Claude
  instructions, presentation defaults, marketplace setting, and lightweight
  integration wrappers.
- `.codex/AGENTS.md` and `rules/default.rules` — portable Codex instructions
  and safe Git approval rules.
- `templates/codex/config.toml` — the secret-free baseline for the local Codex
  configuration, including the CodeGraph, Dokploy, and Homarr MCP definitions.
  It is deliberately not Stowed.

Skills and skill-specific agents are intentionally not in this repository.
They are installed and maintained by the separate skills repository.

Authentication, MCP tokens, project trust, permission allowlists, hooks
managed by external tools, session history, logs, caches, and the Anthropic
credential store are intentionally local. The Claude Orca and Herdr wrappers
are deliberately small: they call the integration installed on the machine and
otherwise become no-ops.

Run `scripts/bootstrap-zsh --init-local-config` (or `--apply`) to create
`~/.codex/config.toml` from the baseline only when it does not exist. Codex then
owns that local file: project trust and hook-review hashes stay machine-specific
and never dirty this repository. Existing local Codex configuration is never
overwritten.

The Dokploy MCP server inherits `DOKPLOY_API_KEY` from the process environment.
Set that value in the ignored `~/.zshenv.local` for shell-launched Codex rather
than placing it in `config.toml` or this repository. Codex project-trust and
hook-review state are likewise generated locally and are not canonical config.
