# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). 

This repository contains configurations for Zsh, including theme and plugin setups to provide a productive terminal experience.

## ✨ Features

- **Shell**: [Zsh](https://www.zsh.org/) with [Oh My Zsh](https://ohmyz.sh/) framework.
- **Theme**: [Powerlevel10k](https://github.com/romkatv/powerlevel10k) for a highly customizable and fast prompt.
- **Plugin Management**: 
  - [Zinit](https://github.com/zdharma-continuum/zinit) for fast and flexible plugin loading.
  - Native Oh My Zsh plugins.
- **Zsh Plugins**:
  - `zsh-syntax-highlighting`
  - `zsh-autosuggestions`
  - `zsh-completions`
  - `fzf-tab`
- **Version Management**: Automated [asdf-vm](https://asdf-vm.com/) binary installation with staged shell completions.
- **Aliases & Utilities**: Custom aliases for `kubectl`, `docker`, `ranger`, and more.

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your system:

- `git`
- `zsh`
- `stow` (GNU Stow)

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/tiagoluizpoli/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Deploy dotfiles using Stow**:

   GNU Stow uses symlinks to manage configurations. To link the configurations in this repo to your home directory:

   ```bash
   stow .
   ```

   *Note: If you have an existing `.zshrc`, Stow might fail. Back up your existing file before running the command.*

3. **Reload your shell**:

   ```bash
   source ~/.zshrc
   ```

   The first time you run Zsh, it will automatically download [Zinit](https://github.com/zdharma-continuum/zinit), [Oh My Zsh](https://ohmyz.sh/), and the configured plugins.

   #### 📦 Staged asdf Installation
   The `asdf` version manager is installed in stages for performance:
   - **Phase 1**: Downloads the latest binary to `~/.local/bin`.
   - **Phase 2**: Generates shell completions in `~/.zsh/completions/`.
   - **Phase 3**: Fully initializes the environment (shims and fpath).

## 🛠 Usage

To add new configurations, simply create the files in this repository following the directory structure you want in your `$HOME`, and run `stow .` again.

To remove the symlinks created by Stow:

```bash
stow -D .
```

## 📄 License

This project is open-source. Feel free to use and modify it.
