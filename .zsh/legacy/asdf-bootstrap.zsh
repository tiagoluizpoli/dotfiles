# Deprecated asdf bootstrap retained as an opt-in reference while Mise is used.
# This file is deliberately not sourced by .zshrc. It will be replaced by a
# deterministic bootstrap command before asdf is re-enabled.

ASDF_BIN="$HOME/.local/bin/asdf"
ASDF_COMPLETIONS="$HOME/.zsh/completions/_asdf"

if [[ ! -f "$ASDF_BIN" || ! -f "$ASDF_COMPLETIONS" ]]; then
  if [[ ! -f "$ASDF_BIN" ]]; then
    echo 'asdf binary missing. Downloading latest...'
    LATEST_TAG="$(curl -s https://api.github.com/repos/asdf-vm/asdf/releases/latest | grep -oE 'v[0-9.]+' | head -1)"
    mkdir -p "${ASDF_BIN%/*}"
    curl -sL "https://github.com/asdf-vm/asdf/releases/download/${LATEST_TAG}/asdf-${LATEST_TAG}-linux-amd64.tar.gz" | tar -xzC "${ASDF_BIN%/*}"
    echo "asdf ${LATEST_TAG} installed. Please restart shell."
  else
    echo 'Generating asdf completions...'
    mkdir -p "${ASDF_COMPLETIONS%/*}" && "$ASDF_BIN" completion zsh > "$ASDF_COMPLETIONS" 2>/dev/null
    echo 'asdf completions ready. Please restart shell.'
  fi
  return
fi

export PATH="$HOME/.asdf/shims:$PATH"
fpath=("$HOME/.zsh/completions" $fpath)
