# Make Cargo-installed tools available to interactive and non-interactive Zsh.
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Non-interactive, host-local environment overrides. This is read before
# .zshrc, so it is suitable for SSH-launched tools such as Codex.
local_zshenv="${ZDOTDIR:-$HOME}/.zshenv.local"
[[ -r "$local_zshenv" ]] && source "$local_zshenv"
unset local_zshenv
