# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tiago.poli/.local/share/.oh-my-zsh/custom/plugins/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/tiago.poli/.local/share/.oh-my-zsh/custom/plugins/fzf/bin"
fi

eval "$(fzf --bash)"
