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
- **Version Management**: [Mise](https://mise.jdx.dev/) with pinned tool versions in `.tool-versions`.
- **Worktrees**: [Worktrunk](https://worktrunk.dev/) with a consistent global layout.
- **GNOME Extensions**: Automated setup script for Dash to Panel, gTile, Copyous, and more.
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

2. **Bootstrap user-space shell tools**:

   First preview what a machine needs; this makes no changes:

   ```bash
   ./scripts/bootstrap-zsh --check
   ```

   After reviewing the output, install the required user-space tools:

   ```bash
   ./scripts/bootstrap-zsh --apply
   ```

   The bootstrap never uses `sudo`, an OS package manager, or edits tracked
   shell configuration. It creates `~/.zshenv.local` and
   `~/.codex/config.toml` from secret-free templates only when absent; existing
   local files are never overwritten. It expects `zsh`, `git`, `curl`, and GNU
   `stow` to be installed already; it reports any missing prerequisite before
   making a deployment possible. During `--apply`, Worktrunk is installed
   through Cargo when missing and uses
   `~/workspaces/repos/05-worktrees/<repository>/<branch>` for new worktrees.

3. **Deploy dotfiles using Stow**:

   GNU Stow uses symlinks to manage configurations. Start with a no-folding
   simulation: this maps individual curated files while leaving runtime state
   in existing directories such as `~/.codex` and `~/.claude` untouched.

   ```bash
   stow --simulate --verbose=2 --no-folding .
   ```

   When the proposed links look right, apply the same mapping:

   ```bash
   stow --no-folding .
   ```

   *Note: If a curated target file already exists, Stow will report a conflict.
   Inspect and migrate that one file before running the non-simulated command;
   do not use `--adopt` on agent configuration or credentials.*

4. **Reload your shell**:

   ```bash
   source ~/.zshrc
   ```

   Zsh loads the tools prepared by the explicit bootstrap; it does not download
   or install software during shell startup.

## 🛠 Usage

To add new configurations, simply create the files in this repository following the directory structure you want in your `$HOME`, and run `stow .` again.

To remove the symlinks created by Stow:

```bash
stow -D .
```

### 📦 GNOME Shell Extensions
To automatically install and enable all required GNOME extensions (Dash to Panel, gTile, Copyous, etc.) on a new system:

1. Ensure `jq` and `unzip` are installed.
2. Run the specialized installation script from the root of this repository:
   ```bash
   ./configFiles/scripts/gnome-extensions/install.sh
   ```

## 📄 License

This project is open-source. Feel free to use and modify it.
