# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal macOS dotfiles configuration repository focused on creating a modern shell environment with enhanced productivity features. The architecture is modular and follows XDG Base Directory standards.

## Core Architecture

### Directory Structure
- `/scripts/` - Dotfiles management utilities (dotfiles-update, dotfiles-check, etc.)
- `/zsh/` - Zsh configuration and plugins
- `/git/` - Git configuration files
- `/atuin/` - Atuin command history configuration
- `/docs/` - Documentation and installation guides
- `dotfiles.conf` - User-specific configuration (not tracked in git)

### Management System
The dotfiles use a custom management system built around shell scripts that handle:
- Branch switching and version management
- Auto-updates with change detection
- Plugin management via Antidote
- Configuration caching and network timeouts

## Common Commands

### Dotfiles Management
```bash
dotfiles update          # Update from remote repository
dotfiles check           # Check for updates without applying
dotfiles branch <name>   # Switch to a different branch
dotfiles show            # Display current config
dotfiles edit            # Edit config file
dotfiles reset           # Reset config to default
dotfiles help            # Show all available commands
```

### Development Workflow
Since this is a dotfiles repository, there are no traditional build/test commands. Instead:
- Test changes by sourcing updated configuration files
- Use `git` commands directly for version control
- Configuration changes take effect on next shell restart

## Key Features and Integration Points

### Shell Environment
- Uses Zsh with Powerlevel10k prompt and Antidote plugin manager
- Modular configuration system in `.zshrc.d/` directories
- XDG Base Directory support for clean home organization

### Version Control Integration
- Git configuration with SSH signing via 1Password
- Comprehensive aliases and smart defaults (rebase on pull, auto-squash, rerere)
- Automatic HTTPS-to-SSH URL conversion for GitHub repos

### Development Tools
- VS Code integration with code-wait wrapper for proper terminal behavior
- Homebrew and OrbStack environment support
- NVM, Yarn, and direnv integration

### Security Features
- macOS Keychain integration for credential management
- Atuin automatic filtering of sensitive information from history
- SSH commit signing configuration

### Auto-Update System
- Configurable update checking (default: every 12 hours)
- Branch mismatch detection and resolution
- Automatic stashing/unstashing of local changes during updates
- Plugin update integration with antidote

## Configuration Files

### Primary Config (`dotfiles.conf`)
- `auto_update_dotfiles`: Enable/disable automatic updates
- `auto_update_antidote`: Enable/disable plugin updates  
- `selected_branch`: Target branch for updates
- `cache_duration`: Update check frequency (seconds)
- `network_timeout`: Network operation timeout

### Environment Integration
- Respects `DOTFILES` environment variable for installation path
- Uses XDG configuration directories when available
- Integrates with system PATH and shell environments

## Working with This Repository

When making changes:
1. Test configuration changes by restarting shell or sourcing files
2. Use branch switching for major changes: `dotfiles branch <branch-name>`
3. Configuration is applied immediately on shell restart
4. No compilation or build steps required - changes are live configuration files

The repository follows a clean, modular approach where each tool/feature has its own configuration space and the management scripts handle integration and updates automatically.

## Code Style and Best Practices

- Do not use associative arrays.