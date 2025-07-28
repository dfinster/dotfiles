---
title: macOS Dotfiles Installation
sidebar:
  label: macOS Installation
  order: 2
description: How to install dotfiles on macOS systems
---
**Dotfiles is designed and fully supported on macOS.** This guide provides step-by-step instructions for installing dotfiles on macOS systems.

## Prerequisites

Dotfiles assumes there are several tools already installed on your system:

- **Zsh**: The default shell for Dotfiles (pre-installed on macOS).
- **Curl**: For downloading scripts and packages (pre-installed on macOS).
- **Git**: For version control and managing dotfiles (pre-installed on macOS).
- **1Password**: For secure SSH key management. If you don't have 1Password, you should fork this repo and modify it to use your preferred SSH key management solution.

The guide explains how to install the following tools, which are essential for Dotfiles:

- **Homebrew**: A package manager for macOS, used to install additional tools and dependencies.
- **Atuin, direnv, eza, and pyenv**: Essential tools for managing shell history, environment variables, file listings, and Python versions.
- **Visual Studio Code**: The primary code editor for Dotfiles.
- **Node.js and Yarn**: For JavaScript development (optional, but recommended).

If you don't have these, install them using the instructions below.

### Install Homebrew

Homebrew is a package manager that simplifies the installation of software on macOS systems.

```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Activate Homebrew in your current session. (This is a temporary setup step. When Dotfiles is fully installed, it will automatically activate Homebrew in future sessions.)

```bash
$ eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Install atuin, direnv, eza, and pyenv

- `atuin` is a command-line tool for managing your shell history.
- `direnv` allows you to set up environment variables per directory.
- `eza` is a modern replacement for `ls`.
- `pyenv` helps manage multiple Python versions.

```bash
$ brew install atuin direnv eza pyenv
```

### Install OrbStack (optional)

OrbStack is a lightweight container development environment for macOS. It provides a fast and efficient way to run containers on macOS.

It's preferred to install Orbstack _**before**_ dotfiles. If you install Orbstack _**after**_ dotfiles, it will add itself to `zsh/.zprofile` automatically. You can revert this, because dotfiles already has Orbstack support built-in.

### Install Visual Studio Code

Dotfiles assumes that VS Code is the primary code editor. If you prefer another editor, you should consider forking this repo and modifying it to suit your needs.

```bash
$ brew install --cask visual-studio-code
```

### Install iTerm2 (optional)

For a better terminal experience with advanced features:

```bash
$ brew install --cask iterm2
```

### Install Node.js and Yarn

Dotfiles assumes you'll want to use Node.js and Yarn for JavaScript development. If you don't need these, you can skip this section.

Install Node Version Manager (nvm), a tool that allows you to manage multiple versions of Node.js easily.

```bash
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

Install Node.js with nvm. This ensures you have the latest LTS version of Node.js, which is often required for many development tools and frameworks.

```bash
$ nvm install --lts
$ nvm use --lts
```

Upgrade npm to the latest version.

```bash
$ npm install -g npm
```

Install Yarn v4 (Berry) globally.

```bash
$ corepack enable
$ npm install -g yarn
```

## Local Git configuration

Dotfiles uses a Git configuration split between a local file and a global file. The local file is for user and machine specific settings, while the global file contains shared settings.

Dotfiles assumes you'll sign commits with SSH keys. This is a secure way to verify the authenticity of your commits.

<Note>
If you don't have an SSH key, see the [GitHub documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#gpg-commit-signature-verification) to generate a new SSH key and adding it to your SSH agent.
</Note>

Create `~/.gitconfig.local` with your user information. This file is used for user-specific settings that should not be shared across machines. All other Git options are found in the main Dotfiles Git config, `~/.config/dotfiles/git/.gitconfig`.

```bash
[user]
      name = Your Name
      email = you@example.com
      signingkey = ssh-ed25519 AAAAC3...
```

Next, create `~/.ssh/allowed_signers` with your SSH public key to sign commits.

```bash
you@example.com ssh-ed25519 AAAAC3...
```

## Set up 1Password SSH integration

1Password manages your SSH keys and provides an SSH agent, allowing you to use your SSH keys securely without needing to store them in plaintext on your machine. To set up 1Password for SSH key management:

1. Enable the SSH agent in 1Password (Settings → Developer → SSH Agent)
1. Configure SSH to use 1Password by adding to `~/.ssh/config`:

```bash
Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

## Install a nerd font

Install a nerd font to enable icons in your terminal and VS Code. Nerd fonts are patched fonts that include additional glyphs and icons, making them suitable for use with PowerLevel10k and other terminal themes. Fira Code is a popular choice, but you can choose any nerd font you prefer. You can install Fira Code with Homebrew, or [download a different one manually](https://www.nerdfonts.com).

```bash
$ brew install --cask font-fira-code-nerd-font
```

Next, [configure iTerm](https://iterm2.com/documentation-fonts.html) to use the nerd font, and [configure VS Code](https://code.visualstudio.com/docs/terminal/appearance).

## Install Dotfiles

To install Dotfiles, you'll back up your existing dotfiles, clone the Dotfiles repository, and set up the configuration files. This process will ensure that your environment is ready to use the Dotfiles setup.

### Backup existing files

Before installing Dotfiles, it's a good idea to back up your existing dotfiles. The following commands create a backup directory and move your existing dotfiles into it.

Make a backup directory.

```bash
$ mkdir -p ~/dotfiles_backup
```

Back up existing dotfiles.

```bash
$ find ~ -maxdepth 1 '(' \
    -name ".gitconfig" -o \
    -name ".zshrc" -o \
    -name ".zshenv" -o \
    -name ".zprofile" -o \
    -name ".zlogin" -o \
    -name ".zlogout" -o \
    -name ".zsh_sessions" -o \
    -name ".zsh_history" -o \
    -name ".zsh_history.*" -o \
    -name ".zcompdump*" \
    ')' -exec mv {} ~/dotfiles_backup/ \;
```

### Clone the Dotfiles repository

Clone the dotfiles repository into your `~/.config/dotfiles` directory.

```bash
$ git clone https://github.com/dfinster/dotfiles ~/.config/dotfiles
```

### Create Dotfiles hook

To hook Dotfiles into your Zsh configuration, create a `.zshenv` file in your home directory that sources the main configuration file. This loads Dotfiles every time you start a new Zsh session.

```bash
$ echo "source ~/.config/dotfiles/zsh/.zshenv" > ~/.zshenv
```

### Activate Dotfiles

Restart your terminal to activate the new configuration. If everything is set up correctly, you should see the PowerLevel10k prompt and have access to all the tools installed by Dotfiles.

## Optional: Configure PowerLevel10k

PowerLevel10k is a theme for Zsh that provides a beautiful and informative prompt. If you don't like the configuration generated by Dotfiles, you can customize it.

```bash
$ p10k configure
```

## Troubleshooting

- If you encounter issues with Homebrew permissions, run `sudo chown -R $(whoami) /usr/local/var/homebrew`
- If zsh doesn't activate after installation, restart your terminal or log out and log back in
- For 1Password SSH integration issues, ensure 1Password is running and SSH agent is enabled in preferences
