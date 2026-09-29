# asdf fallback

Mise is the active version manager in `.zshrc`. The prior automatic asdf
routine is retained, but disabled, at `.zsh/legacy/asdf-bootstrap.zsh`.

Do not source that script from `.zshrc`: it downloads a latest release at
shell startup and assumes Linux amd64. It exists only as a migration reference
until the bootstrap phase defines a deterministic asdf installer.

To return to asdf later, remove `mise` from the Oh My Zsh plugin list, restore
the `asdf` plugin, and design the bootstrap command around the current asdf
installation guidance. Choose either Oh My Zsh's asdf plugin or manually
managed completions, not both.
