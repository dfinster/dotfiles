# Dotfiles Repository Documentation

This document provides a detailed walkthrough of the configuration files in this repository. Each section explains what every line in the corresponding file does so you can easily add inline comments or modify the behavior.

## Table of Contents
- [Atuin configuration](#atuin-configuration)
- [Git configuration](#git-configuration)
- [Zsh environment](#zsh-environment)
- [Zsh profile](#zsh-profile)
- [Zsh runtime configuration](#zsh-runtime-configuration)
- [Zsh styles](#zsh-styles)
- [Powerlevel10k theme](#powerlevel10k-theme)
- [Zsh plugin list](#zsh-plugin-list)
- [Zsh custom functions](#zsh-custom-functions)
- [Zsh plugin scripts](#zsh-plugin-scripts)

Each section lists the file path followed by line–by–line notes.

## Atuin configuration
File: `atuin/config.toml`

Most lines in this file are commented examples provided by Atuin. Only a few settings are active.

| Line | Content | Explanation |
|----|---------|-------------|
| 41 | `search_mode = "prefix"` | Use prefix matching when searching history |
| 45 | `filter_mode = "global"` | Search across all hosts and sessions |
| 55 | `filter_mode_shell_up_key_binding = "directory"` | Up arrow searches only within the current directory |
| 64 | `style = "compact"` | Use the compact terminal UI style |
| 75 | `show_preview = false` | Disable preview window of the selected command |
|124 | `show_help = false` | Do not show the help row in the UI |
|127 | `show_tabs = false` | Hide search/inspect tabs |
|139 | `enter_accept = false` | Pressing enter does not immediately run the command |
|164 | `[stats]` | Begin statistics configuration section |
|198 | `[keys]` | Begin key handling configuration section |
|200 | `scroll_exits = false` | Up/down at the end of the list doesn't exit the TUI |
|202 | `[sync]` | Begin sync configuration section |
|206 | `records = true` | Enable sync v2 records |
|208 | `[preview]` | Begin preview configuration section |
|215 | `[daemon]` | Begin daemon configuration section |

All other lines in this file are comments that describe available options. They remain commented out and therefore use Atuin defaults.

## Git configuration
File: `git/.gitconfig`

This file defines global Git behavior. Empty lines separate logical sections.

| Line | Content | Explanation |
|----|---------|-------------|
|1-3|`# ==================================================` lines|Introductory comment banner|
|5|`# Include additional local configuration if inside ~/`|Comment explaining conditional include|
|6-7|`[includeIf "gitdir:~/"]` and `path = ~/.gitconfig.local`|Use ~/.gitconfig.local when operating inside the home directory|
|9-11|Comment banner for the Core Behavior section|
|13-19|`[core]` block|Sets global ignore file, default editor and line-ending handling|
|21-23|`[color]` block|Enable color output|
|25-27|`[init]` block|Default branch name is `main`|
|29-31|Comment banner for commit signing|
|33-35|`[gpg]` block|Use SSH format for signing|
|37-41|`[commit]` block|Always sign commits and show verbose diff when composing messages|
|43-47|`[gpg "ssh"]` block|Use 1Password for SSH signing and list allowed signers|
|49-58|`[filter "lfs"]` block|Configure Git LFS filter process|
|60-88|`[alias]` block|Define numerous Git command aliases|
|90-100|`[push]` and `[pull]` blocks|Push current branch and rebase on pull|
|102-116|`[merge]`, `[rebase]`, `[rerere]`|Conflict handling, autosquash and reuse recorded resolutions|
|118-128|`[diff]` and `[difftool "vscode"]`|Use VS Code as diff tool|
|130-136|`[credential]`|Use the macOS keychain for credentials|
|138-142|`[url "git@github.com:"]`|Rewrite GitHub URLs to SSH|

### Global Git ignore
File: `git/.gitignore.global`

| Line | Content | Explanation |
|----|---------|-------------|
|1|`# Ignore files in all repositories`|Section header|
|2|`# macOS system files`|Comment|
|3|`.DS_Store`|Ignore macOS Finder metadata|
|4|`dfinster.*`|Ignore any personal files starting with this prefix|

## Zsh environment
File: `zsh/.zshenv`

This file is sourced by every zsh invocation. It sets up paths and ensures the rest of the configuration exists.

| Line | Explanation |
|----|-------------|
|1|Shebang using `/bin/zsh`|
|2|File description comment|
|4-5|Enable extended globbing with `setopt EXTENDED_GLOB`|
|7-11|Define XDG base directories and `DOTFILES` location|
|13-20|If `$DOTFILES` doesn't exist, warn and start a minimal shell|
|22-23|Set `ZDOTDIR` to point to the repo's `zsh` directory|
|25-26|Export `GIT_CONFIG_GLOBAL` path|
|28-83|Interactive block that ensures `~/.gitconfig` is a symlink to this repo. It resolves the target path, backs up any existing file, and creates the link if needed|
|85-89|Set `$VISUAL`, `$EDITOR`, `$GIT_EDITOR`, `$KUBE_EDITOR` to the `code-wait` helper|
|91-92|Set `ATUIN_CONFIG_DIR`|
|94-95|Deduplicate `$path` and `$fpath` arrays|
|97-104|Populate `$path` with standard bin directories|

## Zsh profile
File: `zsh/.zprofile`

This file runs for login shells and sources OrbStack's initialization script.

| Line | Content | Explanation |
|----|---------|-------------|
|2|`# Added by OrbStack: command-line tools and integration`|Comment|
|3|`# This won't be added again if you remove it.`|Comment|
|4|`source ~/.orbstack/shell/init.zsh 2>/dev/null || :`|Load OrbStack integration if present|

## Zsh runtime configuration
File: `zsh/.zshrc`

This file is executed for interactive shells and loads plugins.

| Line | Explanation |
|----|-------------|
|1|Shebang line|
|5-8|Load the Powerlevel10k instant prompt if the cached file exists|
|10-13|Lazy-load custom functions from `.zfunctions`|
|15-16|Source `.zstyles` if present|
|18-21|Clone Antidote (plugin manager) if missing|
|23-25|Load Antidote and installed plugins|
|27-33|Source every `.zshrc.d/*.zsh` file except backups|
|34|Unset temporary variable|
|36-37|Source Powerlevel10k theme if present|

## Zsh styles
File: `zsh/.zstyles`

Zstyles allow fine-grained control over Zsh plugins and completion.

| Line | Explanation |
|----|-------------|
|1-2|Shebang and file description|
|4|Set human-friendly clone names for Antidote bundles|
|5|Show header row in eza listings|
|6|Enable icons for eza|
|7|Use binary size units in eza|
|8|Format completion group headers in green|
|9|Case-insensitive completion matching|
|10|Remove default "group:" labels|
|11|List directories before files|
|12|Enter menu selection after one Tab|
|13|Use LS_COLORS in completion lists|

## Powerlevel10k theme
File: `zsh/.p10k.zsh`

This is an auto-generated configuration for the Powerlevel10k prompt theme. It mainly consists of style variables. Key sections:

| Lines | Explanation |
|----|-------------|
|1-22|Header comments from the configuration wizard|
|24-29|Temporary option changes during configuration|
|31-48|Function that sets color variables and prompt segments|
|49-60|Definition of left prompt elements|
|61-90|Definition of right prompt elements|
|91-188|Numerous style options for segments, colors and prompt behavior|
|189-199|Reload the theme if already loaded and export config file path|

## Zsh plugin list
File: `zsh/.zsh_plugins.txt`

This file lists Antidote bundles to install.

| Line | Plugin | Purpose |
|----|-------|---------|
|4|`mattmc3/ez-compinit`|Fast completion initialization|
|5|`zsh-users/zsh-completions kind:fpath path:src`|Additional completions|
|6|`ohmyzsh/ohmyzsh path:plugins/vscode`|VS Code shell helpers|
|7|`belak/zsh-utils path:editor`|Key bindings for zsh line editor|
|8|`chrissicool/zsh-256color`|Enable 256 color support|
|9|`romkatv/powerlevel10k`|Prompt theme|
|10|`zdharma-continuum/fast-syntax-highlighting`|Syntax highlighting|
|11|`zsh-users/zsh-autosuggestions`|Command suggestions|
|12|`ohmyzsh/ohmyzsh path:plugins/git`|Git plugin|
|13|`lukechilds/zsh-nvm`|nvm integration|
|14|`ohmyzsh/ohmyzsh path:plugins/yarn`|Yarn plugin|
|15|`ohmyzsh/ohmyzsh path:plugins/iterm2`|iTerm2 integration|
|16|`ohmyzsh/ohmyzsh path:plugins/eza`|eza listings|
|17|`ohmyzsh/ohmyzsh path:plugins/direnv`|direnv integration|
|18|`atuinsh/atuin`|Atuin history manager|
|21|`file:$ZDOTDIR/plugins/code-wait kind:path`|Local helper for VS Code as `$EDITOR`|

## Zsh custom functions
File: `zsh/.zfunctions/is-macos`

| Line | Content | Explanation |
|----|---------|-------------|
|1|`#!/bin/zsh`|Shebang|
|2|`[[ $OSTYPE == *darwin* ]]`|Returns success if running on macOS|

## Zsh plugin scripts

### `zsh/plugins/code-wait/code-wait`
| Line | Content | Explanation |
|----|---------|-------------|
|1|`#!/usr/bin/env sh`|Portable shebang|
|2|`exec code --wait "$@"`|Runs Visual Studio Code and waits for it to exit|

### `zsh/.zshrc.d/aliases.zsh`
Defines shell aliases used interactively.

### `zsh/.zshrc.d/brew.zsh`
Initializes Homebrew in the current shell if `brew` is available.

### `zsh/.zshrc.d/options.zsh`
Sets several useful shell options like `autocd` and history settings.

---
This documentation should help you understand what every configuration file does so you can add comments directly in the dotfiles if desired.
