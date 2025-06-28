# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages shell environment configuration for macOS. The repository uses a modular Zsh configuration system with Antidote plugin management.

## Architecture

### Core Components

- **Environment Setup** (`zsh/.zshenv`): Sets XDG directories, configures Git, manages VS Code editor integration, and ensures ~/.gitconfig symlink
- **Interactive Shell** (`zsh/.zshrc`): Loads Powerlevel10k prompt, manages Antidote plugins, sources modular configurations
- **Git Configuration** (`git/.gitconfig`): Global Git settings with SSH signing, VS Code integration, and security-focused defaults
- **Plugin Management**: Uses Antidote to manage Zsh plugins defined in `zsh/.zsh_plugins.txt`

### Directory Structure

```
├── atuin/           # Shell history manager configuration
├── git/             # Git global configuration and ignore rules
├── zsh/             # Zsh shell configuration
│   ├── .zshrc.d/    # Modular shell configurations loaded automatically
│   ├── .zfunctions/ # Custom Zsh functions (auto-loaded)
│   └── plugins/     # Local plugins (code-wait helper)
└── docs/            # Comprehensive line-by-line documentation
```

### Configuration Loading Order

1. `zsh/.zshenv` - Always loaded, sets up environment and Git symlink
2. `zsh/.zprofile` - Login shells only, loads OrbStack integration  
3. `zsh/.zshrc` - Interactive shells, loads plugins and modular configs
4. `zsh/.zshrc.d/*.zsh` - Auto-sourced modular configurations

## Common Operations

### Editing Configuration Files

- **Main Zsh config**: `$EDITOR ~/.config/dotfiles/zsh/.zshrc`
- **Environment variables**: `$EDITOR ~/.config/dotfiles/zsh/.zshenv`
- **Git configuration**: `$EDITOR ~/.config/dotfiles/git/.gitconfig`
- **Add new aliases**: Create or edit files in `zsh/.zshrc.d/`

### Managing Plugins

- **Add plugin**: Add to `zsh/.zsh_plugins.txt` using Antidote bundle format
- **Reload plugins**: `antidote load` or restart shell
- **Plugin documentation**: See existing entries in `.zsh_plugins.txt` for format examples

### Key Integrations

- **VS Code as Editor**: Uses `code-wait` wrapper script for proper terminal editor behavior
- **Git SSH Signing**: Configured with 1Password integration 
- **Shell History**: Atuin provides enhanced command history with sync capabilities
- **Homebrew**: Auto-configured when available via `zsh/.zshrc.d/brew.zsh`

## Important Files

- `zsh/.zshenv:28-83` - Git configuration symlink management logic
- `zsh/.zshrc:18-25` - Antidote plugin manager setup
- `git/.gitconfig:33-47` - SSH commit signing configuration
- `documentation/README.md` - Comprehensive line-by-line documentation

## Shell Functions and Utilities

- `is-macos` - Function to detect macOS environment
- `code-wait` - VS Code wrapper for terminal editor use
- Standard aliases in `zsh/.zshrc.d/aliases.zsh`

This repository focuses on shell environment enhancement rather than application development, so there are no build, test, or deployment commands.