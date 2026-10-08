# Powerlevel10k instant prompt. Keep this at the top of the file.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Shared paths and completion locations. `typeset -U` keeps repeated shell
# initialisation from adding duplicate entries.
typeset -U path PATH fpath
path=(
  "$HOME/.opencode/bin"
  "$HOME/bin"
  "$HOME/.local/bin"
  /usr/local/bin
  $path
)
fpath=(
  "$HOME/.zsh/functions"
  "$HOME/.zsh/completions"
  "$HOME/.local/.zfunc"
  "$HOME/.zfunc"
  $fpath
)

# Plugin managers are installed by the bootstrap phase, not while starting a
# shell. A missing manager leaves a usable plain Zsh session and a clear hint.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
OH_MY_ZSH_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/.oh-my-zsh"

if [[ -r "$ZINIT_HOME/zinit.zsh" ]]; then
  source "$ZINIT_HOME/zinit.zsh"

  zinit ice depth=1
  zinit light romkatv/powerlevel10k
  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-autosuggestions
fi

if [[ -r "$OH_MY_ZSH_HOME/oh-my-zsh.sh" ]]; then
  export ZSH="$OH_MY_ZSH_HOME"
  plugins=(
    git
    gh
    direnv
    docker
    docker-compose
    dotnet
    flutter
    git-commit
    aws
    dnf
    mise
    fzf
    yarn
    npm
    pnpm
    bun
    nats
    github
    node
    z
    zoxide
    bgnotify
    task
    kubectl
  )
  source "$ZSH/oh-my-zsh.sh"
fi

# Oh My Zsh owns compinit. Keep every shared completion directory above its
# initialization and do not run compinit again below.
unalias pi 2>/dev/null

if (( $+commands[wt] )); then
  eval "$(command wt config shell init zsh)"
fi

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Custom scripts managed with these dotfiles.
[[ -r "$HOME/.zsh/scripts/ssh-connect.zsh" ]] && source "$HOME/.zsh/scripts/ssh-connect.zsh"
[[ -r "$HOME/.zsh/_kubectl" ]] && source "$HOME/.zsh/_kubectl"
[[ -r "$HOME/.zsh/functions/git-tag-utils" ]] && source "$HOME/.zsh/functions/git-tag-utils"

mkdircd() {
  mkdir -p -- "$1" && cd -- "$1"
}

ranger_cd() {
  local temp_file chosen_dir
  temp_file="$(mktemp -t 'ranger_cd.XXXXXXXXXX')" || return 1
  ranger --choosedir="$temp_file" -- "${@:-$PWD}"
  if chosen_dir="$(<"$temp_file")" && [[ -n "$chosen_dir" && "$chosen_dir" != "$PWD" ]]; then
    cd -- "$chosen_dir"
  fi
  rm -f -- "$temp_file"
}

alias ls='ls --color=auto'
alias mkcd='mkdircd'
alias ranger='ranger_cd'
alias r='ranger_cd'
alias h='herdr'

# Change the current shell directory to the directory selected when Yazi exits.
unalias y 2>/dev/null
y() {
  local cwd_file exit_code cwd
  cwd_file="$(mktemp -t 'yazi-cwd.XXXXXXXXXX')" || return 1
  yazi "$@" --cwd-file="$cwd_file"
  exit_code=$?
  cwd="$(<"$cwd_file")"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
  rm -f -- "$cwd_file"
  return "$exit_code"
}

if [[ -o interactive && -t 0 ]]; then
  autoload -Uz url-quote-magic
  zle -N self-insert url-quote-magic
fi

HISTSIZE=10000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

if [[ -n ${TILIX_ID:-} || -n ${VTE_VERSION:-} ]] && [[ -r /etc/profile.d/vte.sh ]]; then
  source /etc/profile.d/vte.sh
fi

export BUN_INSTALL="$HOME/.bun"
path=("$BUN_INSTALL/bin" $path)
[[ -r "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Put personal aliases, host-specific paths, and one-machine integrations in
# ~/.zshrc.local. It is intentionally not tracked.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Load syntax highlighting last so it observes widgets created by the rest of
# the startup file.
if (( $+functions[zinit] )); then
  zinit light zsh-users/zsh-syntax-highlighting
fi
