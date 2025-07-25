# CLAUDE.md

Personal dotfiles repository managing macOS shell environment with modular Zsh + Antidote plugins.

## Key Files

- `zsh/.zshrc` - Main shell config, loads plugins and modular configs
- `zsh/.zshenv` - Environment setup, Git symlink management (lines 34-83)
- `git/.gitconfig` - Global Git with SSH signing, VS Code integration
- `zsh/.zsh_plugins.txt` - Antidote plugin definitions
- `zsh/.zshrc.d/*.zsh` - Auto-sourced modular configurations
- `zsh/.zfunctions/*` - Auto-loaded custom Zsh functions

## Operations

**Editing configs:**
- Main Zsh: `zsh/.zshrc`
- Environment: `zsh/.zshenv`  
- Git settings: `git/.gitconfig`
- Add aliases/configs: Create files in `zsh/.zshrc.d/`

**Plugin management:**
- Add plugins: Append to `zsh/.zsh_plugins.txt` using Antidote bundle format
- Reload: `antidote load` or restart shell

**Dotfiles management:**
- `dotfiles update` - Pull latest changes, stash/restore local changes, update plugins
- `dotfiles check` - Check for available updates from GitHub
- `dotfiles switch <branch>` - Switch to different branch, updates $DOTFILES_BRANCH in ~/.zshenv
- Uses $DOTFILES_BRANCH env var (defaults to 'main')

**Key functions:**
- `is-macos` - Detect macOS environment
- `code-wait` - VS Code wrapper for terminal editor use
- `dotfiles` - Manage dotfiles repository (update, check, switch branches)

## Directory Layout

- `atuin/` - Shell history manager config
- `git/` - Git config and ignore rules
- `zsh/` - Shell configs, plugins in `plugins/`, functions in `.zfunctions/`

## Integrations

- **Editor**: Uses `code-wait` for VS Code terminal integration
- **Git**: SSH signing with 1Password, VS Code as default editor
- **History**: Atuin enhanced command history with sync
- **Homebrew**: Auto-configured via `zsh/.zshrc.d/brew.zsh`

No build/test commands - shell environment configuration only.

## Documentation Policy

Documentation is **allowed and encouraged** in this project. Feel free to:
- Create or update .md files as needed
- Add README files for new components
- Write inline code documentation
- Update existing documentation to reflect changes