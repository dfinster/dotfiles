# Dotfiles Architecture Documentation

## Overview

This repository implements a modular, plugin-based shell environment configuration system for macOS using Zsh, Antidote plugin management, and comprehensive tooling integration.

## System Architecture

```mermaid
graph TB
    subgraph "User Environment"
        USER[User Login]
        SHELL[Zsh Shell Instance]
    end

    subgraph "Configuration Entry Points"
        ZSHENV[.zshenv<br/>Always Loaded]
        ZPROFILE[.zprofile<br/>Login Shells]
        ZSHRC[.zshrc<br/>Interactive Shells]
    end

    subgraph "Core Systems"
        XDG[XDG Base Directories]
        GIT[Git Configuration]
        ANTIDOTE[Antidote Plugin Manager]
        ATUIN[Atuin History Manager]
    end

    subgraph "Modular Configurations"
        OPTIONS[options.zsh<br/>Shell Behavior]
        ALIASES[aliases.zsh<br/>Command Shortcuts]
        BREW[brew.zsh<br/>Homebrew Integration]
        ORBSTACK[orbstack.zsh<br/>Container Integration]
    end

    subgraph "Plugin Ecosystem"
        P10K[Powerlevel10k Theme]
        HIGHLIGHTING[Syntax Highlighting]
        AUTOSUGGESTIONS[Auto-suggestions]
        COMPLETIONS[Enhanced Completions]
        TOOLS[Tool Plugins<br/>Git, NVM, Yarn, etc.]
    end

    subgraph "External Tools"
        VSCODE[VS Code Editor]
        ONEP[1Password SSH Signing]
        HOMEBREW[Homebrew Package Manager]
        DOCKER[OrbStack/Docker]
    end

    USER --> SHELL
    SHELL --> ZSHENV
    SHELL --> ZPROFILE
    SHELL --> ZSHRC

    ZSHENV --> XDG
    ZSHENV --> GIT
    ZSHENV --> VSCODE

    ZSHRC --> ANTIDOTE
    ZSHRC --> OPTIONS
    ZSHRC --> ALIASES
    ZSHRC --> BREW
    ZSHRC --> ORBSTACK

    ANTIDOTE --> P10K
    ANTIDOTE --> HIGHLIGHTING
    ANTIDOTE --> AUTOSUGGESTIONS
    ANTIDOTE --> COMPLETIONS
    ANTIDOTE --> TOOLS
    ANTIDOTE --> ATUIN

    GIT --> ONEP
    BREW --> HOMEBREW
    ORBSTACK --> DOCKER

    classDef entryPoint fill:#e1f5fe
    classDef core fill:#f3e5f5
    classDef modular fill:#e8f5e8
    classDef plugin fill:#fff3e0
    classDef external fill:#fce4ec

    class ZSHENV,ZPROFILE,ZSHRC entryPoint
    class XDG,GIT,ANTIDOTE,ATUIN core
    class OPTIONS,ALIASES,BREW,ORBSTACK modular
    class P10K,HIGHLIGHTING,AUTOSUGGESTIONS,COMPLETIONS,TOOLS plugin
    class VSCODE,ONEP,HOMEBREW,DOCKER external
```

## Configuration Loading Flow

```mermaid
sequenceDiagram
    participant User
    participant Zsh
    participant ZshEnv as .zshenv
    participant ZshProfile as .zprofile
    participant ZshRC as .zshrc
    participant Antidote
    participant Modules as .zshrc.d/*

    User->>Zsh: Login/Start Shell
    
    Note over Zsh,ZshEnv: Always Loaded (all zsh invocations)
    Zsh->>ZshEnv: Source .zshenv
    ZshEnv->>ZshEnv: Set XDG directories
    ZshEnv->>ZshEnv: Configure DOTFILES path
    ZshEnv->>ZshEnv: Setup Git symlink
    ZshEnv->>ZshEnv: Configure VS Code as editor
    ZshEnv->>ZshEnv: Set Atuin config path
    ZshEnv->>ZshEnv: Configure PATH

    alt Login Shell
        Note over Zsh,ZshProfile: Login Shells Only
        Zsh->>ZshProfile: Source .zprofile
        ZshProfile->>ZshProfile: Load OrbStack integration
    end

    alt Interactive Shell
        Note over Zsh,Modules: Interactive Shells Only
        Zsh->>ZshRC: Source .zshrc
        ZshRC->>ZshRC: Load P10k instant prompt
        ZshRC->>ZshRC: Setup custom functions
        ZshRC->>ZshRC: Load zstyles
        
        ZshRC->>Antidote: Clone if missing
        ZshRC->>Antidote: Load plugin manager
        Antidote->>Antidote: Install/load all plugins
        
        ZshRC->>Modules: Source .zshrc.d/*.zsh
        Modules->>Modules: Load options.zsh
        Modules->>Modules: Load aliases.zsh
        Modules->>Modules: Load brew.zsh (if available)
        Modules->>Modules: Load orbstack.zsh (if available)
        
        ZshRC->>ZshRC: Load P10k theme
    end

    Zsh-->>User: Ready shell environment
```

## Component Details

### Core Configuration Files

#### `.zshenv` - Environment Setup
- **Purpose**: Universal environment configuration loaded by all Zsh instances
- **Key Responsibilities**:
  - XDG Base Directory specification compliance
  - DOTFILES path configuration and validation
  - Git configuration symlink management
  - VS Code editor integration via `code-wait`
  - PATH configuration with user and system directories

#### `.zshrc` - Interactive Shell Configuration
- **Purpose**: Configuration for interactive shell sessions
- **Key Responsibilities**:
  - Powerlevel10k instant prompt loading
  - Custom function auto-loading from `.zfunctions`
  - Antidote plugin manager initialization
  - Modular configuration loading from `.zshrc.d/`
  - Theme configuration

#### `.zprofile` - Login Shell Setup
- **Purpose**: Login shell specific configuration
- **Key Responsibilities**:
  - OrbStack shell integration
  - Login-specific environment setup

### Plugin Management System

```mermaid
graph LR
    subgraph "Plugin Definition"
        PLUGINTXT[.zsh_plugins.txt<br/>Plugin List]
    end

    subgraph "Antidote Manager"
        ANTIDOTE[Antidote Core]
        CACHE[Plugin Cache]
        LOADER[Dynamic Loader]
    end

    subgraph "Plugin Categories"
        CORE[Core Functionality<br/>completions, colors]
        THEME[Theme & UI<br/>powerlevel10k, highlighting]
        TOOLS[Tool Integration<br/>git, nvm, yarn, direnv]
        HISTORY[History Management<br/>atuin]
        LOCAL[Local Plugins<br/>code-wait]
    end

    PLUGINTXT --> ANTIDOTE
    ANTIDOTE --> CACHE
    ANTIDOTE --> LOADER
    LOADER --> CORE
    LOADER --> THEME
    LOADER --> TOOLS
    LOADER --> HISTORY
    LOADER --> LOCAL

    classDef definition fill:#e3f2fd
    classDef manager fill:#f1f8e9
    classDef category fill:#fff8e1

    class PLUGINTXT definition
    class ANTIDOTE,CACHE,LOADER manager
    class CORE,THEME,TOOLS,HISTORY,LOCAL category
```

### Modular Configuration System

The `.zshrc.d/` directory contains specialized configuration modules:

1. **`options.zsh`** - Shell behavior configuration
   - Auto-cd functionality
   - Command correction
   - Extended globbing
   - History management

2. **`aliases.zsh`** - Command shortcuts and utilities
   - System utility aliases
   - File finding shortcuts
   - Configuration management helpers

3. **`brew.zsh`** - Homebrew integration
   - Conditional Homebrew environment setup
   - PATH and environment variable configuration

4. **`orbstack.zsh`** - Container platform integration
   - OrbStack shell initialization
   - Docker environment setup

### Tool Integrations

#### Git Configuration
- Global configuration with SSH signing via 1Password
- VS Code as default editor and diff tool
- Security-focused defaults (auto-signing, HTTPS→SSH rewriting)
- Comprehensive alias system

#### Atuin History Management
- Enhanced command history with sync capabilities
- Prefix-based search with directory-specific up-arrow behavior
- Compact UI with disabled previews for minimal distraction
- Privacy-focused with secrets filtering

#### VS Code Integration
- Custom `code-wait` wrapper for proper terminal editor behavior
- Configured as default editor for Git, Kubernetes, and system operations
- Seamless integration with shell workflows

## Directory Structure

```
dotfiles/
├── atuin/                    # Atuin history manager config
│   └── config.toml          # History search and sync settings
├── docs/                     # Documentation (this directory)
│   ├── README.md            # Repository overview
│   └── architecture.md      # This file
├── git/                      # Git configuration
│   ├── .gitconfig           # Global Git settings
│   └── .gitignore_global    # Global ignore patterns
└── zsh/                      # Zsh configuration
    ├── .zshenv              # Environment setup (always loaded)
    ├── .zprofile            # Login shell configuration
    ├── .zshrc               # Interactive shell setup
    ├── .zstyles             # Zsh completion and plugin styles
    ├── .p10k.zsh            # Powerlevel10k theme configuration
    ├── .zsh_plugins.txt     # Antidote plugin definitions
    ├── .zfunctions/         # Custom Zsh functions
    │   └── is-macos         # macOS detection utility
    ├── .zshrc.d/            # Modular configurations
    │   ├── aliases.zsh      # Command aliases
    │   ├── brew.zsh         # Homebrew integration
    │   ├── options.zsh      # Shell options
    │   └── orbstack.zsh     # Container integration
    └── plugins/             # Local plugins
        └── code-wait/       # VS Code editor wrapper
            └── code-wait    # Executable script
```

## Security Considerations

- **SSH Commit Signing**: All commits are automatically signed using SSH keys managed by 1Password
- **Secrets Filtering**: Atuin automatically filters common secrets (AWS keys, GitHub tokens, etc.) from history
- **HTTPS to SSH Rewriting**: GitHub URLs are automatically rewritten to use SSH for enhanced security
- **Environment Isolation**: Configuration respects XDG Base Directory specification for clean separation

## Performance Optimizations

- **Lazy Loading**: Heavy operations are deferred or conditionally loaded
- **Plugin Caching**: Antidote caches plugin installations for faster startup
- **Instant Prompt**: Powerlevel10k instant prompt provides immediate shell availability
- **Conditional Loading**: Tool integrations only load when tools are available
- **Deduplicated Paths**: PATH and FPATH arrays are automatically deduplicated

## Extensibility

The modular design allows for easy extension:

1. **New Plugins**: Add to `.zsh_plugins.txt` using Antidote bundle format
2. **Additional Modules**: Create new `.zsh` files in `.zshrc.d/`
3. **Custom Functions**: Add to `.zfunctions/` for automatic loading
4. **Tool Integration**: Follow existing patterns in modular configurations

This architecture provides a robust, maintainable, and extensible foundation for shell environment management.