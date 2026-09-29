# Zsh bootstrap

The managed `.zshrc` never installs software during shell startup. Prepare a
machine explicitly from this repository instead:

```sh
scripts/bootstrap-zsh --check
scripts/bootstrap-zsh --apply
```

`--check` is read-only. `--apply` installs only into the user account: Mise,
Rustup/Cargo, Zinit, Oh My Zsh, the pnpm Oh My Zsh plugin, the pinned tools in
`.tool-versions`, and the generated Caddy completion. It never uses `sudo`,
an operating-system package manager, or edits tracked shell configuration. If
`~/.zshenv.local` is absent, it creates a mode-600 copy of
`.zshenv.local.example` for the host-specific values; an existing local file is
never overwritten. It likewise creates `~/.codex/config.toml` from the ignored
`templates/codex/config.toml` baseline only when absent. Use
`--init-local-config` to create both local files without downloading tools.

The host must already provide `zsh`, `git`, `curl`, and GNU `stow`. Review the script
before using `--apply`, as it downloads installer scripts and clones the
listed upstream repositories.
