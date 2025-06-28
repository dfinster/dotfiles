# Dotfiles Concepts Guide

This guide explains the key concepts and organization of the [dotfiles repository]().
## Architecture Overview

### File Organization

**dotfiles** is designed to be installed in `~/.config/dotfiles` on macOS and Linux. It uses a single bootstrap file in your home directory (`~/.zshenv`) to load the entire system. The content of `~/.zshenv` is minimal, simply redirecting Zsh to source the corresponding `.zshenv` file in the dotfiles directory:

```zsh
. ~/.config/dotfiles/zsh/.zshenv
```

This keeps your home directory clean and allows for easy version control.

### Modular Structure

This project has a modular structure that separates concerns for easy customization and maintenance. The main directories are:

- **`atuin/`** - Enhanced command history configuration
- **`git/`** - Git configuration and global ignore patterns
- **`zsh/`** - All shell-related configuration

### Loading Order

The shell configuration loads in a specific order to ensure dependencies are met:

1. **`zsh/.zshenv`** - Always loaded first, sets up environment
2. **`zsh/.zprofile`** - Login shells only, minimal setup
3. **`zsh/.zshrc`** - Interactive shells, loads plugins and features
4. **`zsh/.zshrc.d/*.zsh`** - Modular configurations loaded alphabetically

This layered approach ensures that environment variables are available when needed, and interactive features only load when appropriate.

## Environment Foundation

### XDG Base Directory Compliance

The configuration follows the XDG Base Directory Specification for clean organization:

- **Config Directory** (`XDG_CONFIG_HOME`): Where applications store configuration
- **Data Directory** (`XDG_DATA_HOME`): Where applications store persistent data
- **Cache Directory** (`XDG_CACHE_HOME`): Where applications store temporary cache files

This separation keeps your home directory clean and makes it easier to backup or migrate configurations.

### ZDOTDIR Redirection

Instead of cluttering your home directory with Zsh files, the configuration redirects Zsh to use the repository's `zsh/` directory. This means:

- All Zsh configs live in one place
- Easy to version control and share
- Home directory stays clean
- Portable across machines

### PATH Management
The PATH is carefully constructed to prioritize user tools while maintaining system functionality:

1. **User binaries** (`~/bin`, `~/.local/bin`) - Highest priority
2. **Package managers** (Homebrew, MacPorts) - Medium priority
3. **System binaries** - Lowest priority but preserved

This ensures your custom tools take precedence while keeping the system functional.

### Fallback Safety
If the dotfiles directory doesn't exist, the configuration provides a minimal fallback environment instead of breaking the shell. This defensive approach ensures you always have a working terminal.

---

## Shell Configuration

### Core Shell Behavior
The shell is configured with quality-of-life improvements:

- **Auto-cd**: Type a directory name to change to it (no `cd` needed)
- **Spelling correction**: Suggests fixes for command typos
- **Extended globbing**: Advanced pattern matching with `**`, `~`, `^`
- **Smart history**: Removes duplicates, saves immediately

### Modular Configuration System
Instead of one massive `.zshrc` file, configuration is split into logical modules in `.zshrc.d/`:

- **`aliases.zsh`** - Command shortcuts and convenience aliases
- **`brew.zsh`** - Homebrew package manager integration
- **`options.zsh`** - Core shell behavior settings
- **`orbstack.zsh`** - Container platform integration

This modular approach makes it easy to:
- Add new functionality without cluttering
- Disable specific features by removing files
- Understand what each piece does
- Share specific modules with others

### Custom Functions
The `.zfunctions/` directory contains utility functions that are auto-loaded:

- **`is-macos`** - Detect macOS for conditional logic
- Functions are loaded on-demand for performance
- Easy to add new utilities

---

## Git Integration

### Managed Configuration
Instead of manually editing `~/.gitconfig`, this system:

- Stores Git config in the repository for version control
- Automatically creates/updates symlinks
- Backs up existing config with timestamps
- Works across multiple machines

### Security-First Approach
Git is configured with security best practices:

- **SSH commit signing** using 1Password integration
- **Automatic signing** for all commits
- **Credential storage** in macOS Keychain
- **URL rewriting** to use SSH instead of HTTPS for GitHub

### Developer Workflow Enhancements
Git behavior is optimized for modern development:

- **Rebase by default** for cleaner history
- **VS Code integration** for diffs and editing
- **Helpful aliases** for common operations
- **Smart conflict resolution** with rerere

### Global Ignore Patterns
The `.gitignore_global` file automatically ignores common files across all repositories:
- Files starting with `local-*` for temporary/local configurations
- Prevents accidentally committing sensitive or temporary files

---

## Plugin System

### Antidote Plugin Manager
The configuration uses Antidote for plugin management because it's:
- **Fast** - Doesn't slow down shell startup
- **Simple** - Plugins defined in one text file
- **Self-bootstrapping** - Installs itself automatically

### Curated Plugin Selection
Plugins are carefully chosen for specific purposes:

**Productivity Enhancements:**
- **Syntax highlighting** - Visual feedback for commands
- **Auto-suggestions** - Command completion from history
- **Enhanced completions** - Better tab completion

**Developer Tools:**
- **Git integration** - Git-aware features and shortcuts
- **VS Code integration** - Terminal-editor connectivity
- **Package manager support** - npm, yarn, etc.

**Visual Improvements:**
- **Powerlevel10k theme** - Fast, informative prompt
- **256-color support** - Better terminal colors
- **File icons** - Visual file type indicators

### Performance Focus
Plugin loading is optimized to maintain fast shell startup:
- Instant prompt for immediate responsiveness
- Lazy loading where possible
- Minimal plugin overhead

---

## Developer Tools

### VS Code Integration
The configuration is designed around VS Code as the primary editor:

- **`code-wait` wrapper** - Makes VS Code work properly in terminal
- **Editor variables** - VISUAL, EDITOR, GIT_EDITOR all point to VS Code
- **Git integration** - Commit messages, diffs, merges open in VS Code

### Enhanced Command History
Atuin replaces the default shell history with advanced features:

- **Searchable history** - Find commands by prefix or content
- **Cross-machine sync** - Share history across devices
- **Context-aware search** - Directory-specific history with arrow keys
- **Privacy controls** - Filters out sensitive commands

### Package Manager Support
Automatic integration with common development tools:
- **Homebrew** - macOS package manager
- **Node.js tools** - npm, yarn, nvm
- **Container tools** - OrbStack integration

---

## System Integration

### macOS Optimizations
The configuration includes macOS-specific features:
- **Homebrew environment setup** - Automatic PATH configuration
- **Keychain integration** - Secure credential storage
- **1Password SSH signing** - Leverages 1Password for Git security
- **OrbStack support** - Modern container platform

### Cross-Platform Considerations
While optimized for macOS, the configuration handles other systems gracefully:
- **Conditional loading** - Features only load if tools are available
- **Fallback behavior** - Degrades gracefully on unsupported systems
- **Standard compliance** - Uses XDG and POSIX standards where possible

### Application Integration
Seamless integration with development tools:
- **Terminal applications** respect environment variables
- **Git tools** use consistent configuration
- **Editors** work properly as terminal editors

---

## Security Features

### Commit Signing
All Git commits are automatically signed using SSH keys:
- **Authentication** - Proves commits came from you
- **Non-repudiation** - Can't deny making signed commits
- **GitHub/GitLab integration** - Platforms show "Verified" badges

### Credential Management
Secure handling of authentication:
- **macOS Keychain** - System-level secure storage
- **SSH key management** - Leverages 1Password's SSH agent
- **No plaintext secrets** - Credentials encrypted at rest

### Safe Defaults
Configuration choices prioritize security:
- **Automatic signing** - Can't forget to sign commits
- **SSH over HTTPS** - Uses key-based auth instead of tokens
- **Backup preservation** - Never overwrites existing config without backup

---

## Customization Points

### Easy Modifications
The modular structure makes customization straightforward:

**Adding Aliases**: Create or edit files in `.zshrc.d/`
**New Plugins**: Add entries to `.zsh_plugins.txt`
**Git Settings**: Modify `git/.gitconfig`
**Shell Options**: Edit `.zshrc.d/options.zsh`

### Local Overrides
Support for machine-specific configuration:
- **`~/.gitconfig.local`** - Git settings that override global config
- **Environment variables** - Can override default paths and behaviors
- **Conditional includes** - Load different configs based on context

### Plugin Management
Easy to add or remove functionality:
- **Add plugins** by editing `.zsh_plugins.txt`
- **Remove plugins** by deleting lines
- **Plugin updates** handled automatically by Antidote

### Editor Integration
While optimized for VS Code, easy to change:
- **Modify EDITOR variables** in `.zshenv`
- **Update wrapper scripts** in `plugins/code-wait/`
- **Adjust Git integration** in `.gitconfig`

---

## Understanding the Benefits

### Productivity Gains
- **Faster command entry** with auto-suggestions and history
- **Visual feedback** with syntax highlighting and themes
- **Quick navigation** with aliases and auto-cd
- **Enhanced completion** for better tab completion

### Consistency Across Machines
- **Version-controlled configuration** ensures consistency
- **Automatic setup** reduces manual configuration
- **Portable environment** works the same everywhere

### Security by Default
- **Signed commits** for authentication
- **Secure credential storage** in system keychain
- **Safe configuration** that backs up existing settings

### Maintainability
- **Modular structure** makes it easy to understand and modify
- **Self-documenting** with clear organization and comments
- **Defensive programming** handles edge cases gracefully

---

## Getting Started

### Understanding Your Environment
1. **Check what's loaded** - Use `echo $ZDOTDIR` to see where configs live
2. **Explore the structure** - Look through `.zshrc.d/` to see what's available
3. **Test features** - Try auto-suggestions, syntax highlighting, Git integration

### Making Changes
1. **Start small** - Add an alias or modify an existing setting
2. **Use the modular system** - Create new files in `.zshrc.d/` for new functionality
3. **Test thoroughly** - Open a new shell to test changes

### Troubleshooting
1. **Check for errors** - Shell errors usually indicate syntax issues
2. **Disable problematic modules** - Remove or rename files in `.zshrc.d/`
3. **Use fallback mode** - Rename the dotfiles directory to get minimal shell

This dotfiles configuration provides a solid foundation for a productive development environment while remaining customizable and maintainable.
