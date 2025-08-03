# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal macOS dotfiles configuration repository that manages shell environment, development tools, and system configurations. The project is built around Zsh with Powerlevel10k and uses a modular script-based architecture for updates and management.

## Core Commands

### Dotfiles Management
- `dotfiles update` - Apply dotfiles updates from remote repository
- `dotfiles check` - Check for available updates without applying
- `dotfiles branch <name>` - Switch to a different branch
- `dotfiles doctor` - Run system diagnostics and health checks
- `dotfiles config` - Display current configuration
- `dotfiles config edit` - Edit configuration with validation
- `dotfiles config reset` - Reset configuration to defaults
- `dotfiles help` - Show help and usage information

### Development Workflow
- No build system (shell scripts and configuration files)
- No tests or linting commands (pure shell configuration)
- Configuration validation is handled by `dotfiles config validate`

## Architecture

### Core Components

**Configuration Management (`scripts/dotfiles-shared`)**
- Centralized configuration loading and validation system
- Shared utilities for all dotfiles commands
- Configuration file: `~/.config/dotfiles/dotfiles.conf`
- Default branch management and corruption detection
- Color constants and helper functions for consistent output

**Command Scripts (`scripts/`)**
- `dotfiles-update` - Handles git pull, stashing, and plugin updates
- `dotfiles-doctor` - System diagnostics and environment validation
- `dotfiles-help` - Command documentation and usage
- `dotfiles-config` - Configuration management interface
- `dotfiles-branch` - Branch switching functionality
- `dotfiles-check` - Update checking without applying changes

**Shell Environment (`zsh/`)**
- Modular Zsh configuration with plugin management
- Antidote plugin manager integration
- Custom plugins including `code-wait` for VS Code integration

**Git Configuration (`git/`)**
- SSH commit signing with 1Password integration
- Comprehensive aliases and smart defaults
- GitHub SSH URL rewriting

### Key Environment Variables
- `DOTFILES` - Path to dotfiles directory (required)
- `XDG_CONFIG_HOME` - Configuration directory (defaults to `~/.config`)

### Configuration System
- Main config: `dotfiles.conf` with validation and defaults
- Branch selection: `selected_branch` (default: main)
- Auto-update settings: `auto_update_dotfiles`, `auto_update_antidote`
- Network settings: `cache_duration`, `network_timeout`

### Error Handling
- Comprehensive configuration validation with automatic fallback to defaults
- Corruption detection and recovery for config files
- Git repository health checking in `dotfiles-doctor`
- Stashing of local changes before updates

## Important Patterns

**Script Organization**
- All scripts source `dotfiles-shared` for common functionality
- `_dot_setup()` function provides standardized initialization
- Color-coded output using `_DOT_*` color constants
- Git operations use `_dot_git()` wrapper functions

**Configuration Management**
- Configuration loaded once per shell session with `_DOT_CONFIG_LOADED`
- Validation functions for each config key with regex patterns
- Default value system with `_dot_get_default()` function
- Template generation for missing config files

**Update Process**
- Branch mismatch detection between config and current branch
- Automatic stashing of uncommitted changes
- Antidote plugin updates when enabled
- Cache management for update checking

## Development Guidelines

- All scripts are written in Zsh and follow the existing patterns
- Use `_dot_` prefix for internal functions to avoid namespace conflicts
- Leverage shared utilities in `dotfiles-shared` rather than duplicating code
- Follow the color-coded output patterns for consistency
- Test configuration changes with `dotfiles config validate`
- Use `dotfiles doctor` to verify system health after changes