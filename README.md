# dotfiles

Personal macOS dotfiles configuration for a modern shell environment with enhanced productivity features.

## Main Features

### Shell Environment
- **Zsh with Powerlevel10k**: Modern shell with a fast, customizable prompt featuring Git integration and visual indicators, such as Python virtual environments
- **Modular Configuration**: Organized .zshrc.d/ directory for easy management of shell configurations
- **XDG Base Directory Support**: Follows XDG standards for clean home directory organization

### Plugin Management
- **Antidote Plugin Manager**: Lightning-fast plugin loading with automatic installation
- **Curated Plugin Collection**: Includes syntax highlighting, autosuggestions, completions, and development tools
- **Tool Integration**: Native support for Git, NVM, Yarn, direnv, and more

### Enhanced Terminal Experience
- **Atuin History**: Intelligent command history with search, sync, and filtering capabilities
- **256 Color Support**: Rich terminal colors for better visual experience
- **Smart Completions**: Fast completion system with additional Zsh completions

### Development Tools Integration
- **VS Code Integration**: Seamless editor integration with proper terminal behavior via code-wait wrapper
- **Git Configuration**: Comprehensive Git setup with SSH signing, aliases, and VS Code as diff tool

### Advanced Git Features
- **SSH Commit Signing**: Automatic commit signing with SSH keys via 1Password
- **Comprehensive Aliases**: Extensive Git aliases for common workflows
- **Smart Defaults**: Rebase on pull, auto-squash, conflict resolution memory (rerere)
- **GitHub SSH Rewriting**: Automatic HTTPS-to-SSH URL conversion for GitHub repos

### Security & Privacy
- **Credential Management**: macOS Keychain integration for secure credential storage
- **Secret Filtering**: Atuin automatically filters sensitive information from history
- **Secure Defaults**: Security-focused Git and shell configurations

### System Integration
- **Homebrew Support**: Automatic Homebrew environment setup when available
- **OrbStack Integration**: Container development environment support
- **Path Management**: Intelligent PATH configuration for user and system binaries

### Auto-update
- **Easy-update**: Gives user a single command to update dotfiles
- **Update Notifications**: Notifies user of available updates with details on commits and changes
- **Cached results**: Only checks once every 12 hours to improve terminal startup time

For more information, see the [documentation](docs/index.md).
