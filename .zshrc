# --- 1. Instant Prompt (P10K) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- 2. Path & Function Setup ---
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
fpath=(~/.zsh/functions $fpath)

# --- 3. Self-Installing Plugin Logic ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d "$ZINIT_HOME" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

OH_MY_ZSH_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/.oh-my-zsh"
[[ ! -d "$OH_MY_ZSH_HOME" ]] && git clone https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_HOME"
export ZSH="$OH_MY_ZSH_HOME"

# Helper for manual plugin clones
install_plugin() {
    local dir="$1" url="$2"
    [[ ! -d "$dir" ]] && git clone --depth 1 "$url" "$dir"
}

install_plugin "$ZSH/custom/plugins/fzf" "https://github.com/junegunn/fzf.git"
if [[ ! -f "$ZSH/custom/plugins/fzf/bin/fzf" ]]; then
    "$ZSH/custom/plugins/fzf/install" --bin > /dev/null 2>&1
fi
install_plugin "$ZSH/custom/plugins/task" "https://github.com/go-task/task.git"
install_plugin "$ZSH/custom/plugins/pnpm" "https://github.com/ntnyq/omz-plugin-pnpm.git"

# --- 4. Zinit Lights ---
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# --- 5. Oh My Zsh Loading ---
plugins=(git docker docker-compose dotnet flutter git-commit aws dnf asdf yarn npm nats github node z bgnotify pnpm task kubectl)
source $ZSH/oh-my-zsh.sh

# --- 6. Environment & Aliases ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if [[ -d "$ZSH/custom/plugins/fzf/bin" ]]; then
    export PATH="$ZSH/custom/plugins/fzf/bin:$PATH"
    eval "$(fzf --zsh 2>/dev/null)"
fi
. "$HOME/.asdf/asdf.sh" 2>/dev/null

# Custom Script Sources
[[ -f "$HOME/.zsh/scripts/ssh-connect.zsh" ]] && source "$HOME/.zsh/scripts/ssh-connect.zsh"
[[ -f "$HOME/.zsh/_kubectl" ]] && source "$HOME/.zsh/_kubectl"

# --- 7. Load Git Tag Utilities ---
if [[ -f "$HOME/.zsh/functions/git-tag-utils" ]]; then
    source "$HOME/.zsh/functions/git-tag-utils"
fi


# Functions
# create directories recursively and cd into it.
mkdircd() {
    mkdir -p "$1" && cd "$1"
}

# cd into the last directory visited by ranger (when pressing "q" to leave the tool)
ranger_cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}

# Aliases
alias ls='ls --color'
alias ks='kubectl -n solutions'
alias kl='kubectl --context lunalabs'
alias kls='kubectl --context lunalabs -n solutions'
alias mkcd='mkdircd'
alias ranger='ranger_cd'
alias r='ranger_cd'

# Zsh fixes
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# certs
export NODE_EXTRA_CA_CERTS="$HOME/01-dev-env/work/tivit/bastion ssh private keys/certadmin.pem"

# settings
# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'