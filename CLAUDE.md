# CLAUDE.md

Personal dotfiles repository managing macOS shell environment with modular Zsh + Antidote plugins.

## Key Files

- `zsh/.zshrc` - Main shell config, loads plugins and modular configs
- `zsh/.zshenv` - Environment setup, Git symlink management (lines 34-83)
- `git/.gitconfig` - Global Git with SSH signing, VS Code integration
- `zsh/.zsh_plugins.txt` - Antidote plugin definitions
- `zsh/.zshrc.d/*.zsh` - Auto-sourced modular configurations
- `zsh/.zfunctions/*` - Auto-loaded custom Zsh functions
- `scripts/dotfiles-*.sh` - Modular management scripts for config, diagnostics, help, etc.
- `dotfiles.conf` - User configuration file (not tracked in git)

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
- `dotfiles branch <branch>` - Switch to different branch
- `dotfiles config` - Display current configuration
- `dotfiles config edit` - Edit configuration safely with validation and backup
- `dotfiles config validate` - Validate current configuration
- `dotfiles config reset` - Reset configuration to defaults (with backup)
- `dotfiles doctor` - Comprehensive system diagnostics
- `dotfiles doctor <section>` - Run specific diagnostic section (system, dotfiles, dependencies, plugins, performance)
- `dotfiles help [topic]` - Show help information (supports topics: config, doctor, update, troubleshooting)

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

## Testing and Diagnostics

- `scripts/dotfiles-test.sh` - Comprehensive test suite for all functionality
- `dotfiles doctor` - System health check and diagnostics
- `dotfiles config validate` - Configuration validation

## Configuration Management

- **Config file**: `~/.config/dotfiles/dotfiles.conf` (auto-created)
- **Settings**: `selected_branch`, `cache_duration`, `network_timeout`, `auto_update_antidote`
- **Safety**: All operations include backups, validation, and rollback capabilities
- **Commands**: `config show`, `config edit`, `config validate`, `config reset`

## Documentation Policy

Documentation is **allowed and encouraged** in this project. Feel free to:
- Create or update .md files as needed
- Add README files for new components
- Write inline code documentation
- Update existing documentation to reflect changes