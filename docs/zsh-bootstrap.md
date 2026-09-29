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
an operating-system package manager, or edits `.zshrc`.

The host must already provide `zsh`, `git`, `curl`, and GNU `stow`. Review the script
before using `--apply`, as it downloads installer scripts and clones the
listed upstream repositories.
