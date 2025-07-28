---
title: Linux Dotfiles Installation
sidebar:
  label: Linux Installation
  order: 3
description: How to install dotfiles on Linux systems
---
**Dotfiles is only designed and supported on macOS.**

However, it should work on most Linux distributions with some minor adjustments. You'll need to fork the repository and make some changes to the configuration files.

The installation process is similar to macOS, but there are a few differences in the setup, especially regarding package management and SSH key management. In particular, Dotfiles uses 1Password on macOS as the ssh key manager. On Linux, you'll need to change this even if you use 1Password because the link to 1Password integration is different. The rest of the setup should work as expected.

I have only tested this on Ubuntu, and it works for me. The instructions for other distributions were written by AI, and I haven't tested them. They may work, but I can't guarantee it. If you use a different distribution, you may need to adjust the instructions accordingly.

If you have problems, please [open an issue](https://github.com/dfinster/dotfiles/issues) and I'll consider how to fix it. No promises.

## Prerequisites

Dotfiles assumes there are several tools already installed on your system:

- **Zsh**: The default shell for Dotfiles.
- **Curl**: For downloading scripts and packages.
- **Git**: For version control and managing dotfiles.
- **Homebrew**: A package manager for Linux, used to install additional tools and dependencies.
- **Atuin, direnv, eza, and pyenv**: Essential tools for managing shell history, environment variables, file listings, and Python versions.
- **Visual Studio Code**: The primary code editor for Dotfiles.
- **Node.js and Yarn**: For JavaScript development (optional, but recommended).

If you don't have these, install them using the instructions below.

### Install Zsh and basic tools

Install Zsh, Curl, and Git if they are not already installed.

#### Ubuntu/Debian

```bash
$ sudo apt update
$ sudo apt install zsh curl git
$ chsh -s $(which zsh)
```

Logout and log back in to apply the changes.

#### Fedora

```bash
$ sudo dnf install zsh curl git
$ chsh -s $(which zsh)
```

Logout and log back in to apply the changes.

#### Arch Linux

```bash
$ sudo pacman -S zsh curl git
$ chsh -s $(which zsh)
```

Logout and log back in to apply the changes.

### Intial configuration for Zsh

When you first log in, Zsh will prompt you to configure it. You can skip this step by pressing `q`, as Dotfiles will handle the configuration for you. If you want to proceed with the initial configuration, you can follow the prompts.

Example output when you first log in:

```txt
This is the Z Shell configuration function for new users,
zsh-newuser-install.
You are seeing this message because you have no zsh startup files
(the files .zshenv, .zprofile, .zshrc, .zlogin in the directory
~).  This function can help you with a few settings that should
make your use of the shell easier.

You can:

(q)  Quit and do nothing.  The function will be run again next time.

(0)  Exit, creating the file ~/.zshrc containing just a comment.
     That will prevent this function being run again.

(1)  Continue to the main menu.

(2)  Populate your ~/.zshrc with the configuration recommended
     by the system administrator and exit (you will need to edit
     the file by hand, if so desired).

--- Type one of the keys in parentheses ---
```

If you skip the Zsh configuration, you'll have a minimal Zsh shell with almost no features during this installation. This is fine, because Dotfiles will set up everything you need.

### Install Homebrew for Linux


Homebrew is a package manager that simplifies the installation of software on Linux systems.

```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Activate Homebrew in your current session. (This is a temporary setup step. When Dotfiles is fully installed, it will automatically activate Homebrew in future sessions.)

```bash
$ eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### Atuin, direnv, eza, and pyenv

- `atuin` is a command-line tool for managing your shell history.
- `direnv` allows you to set up environment variables per directory.
- `eza` is a modern replacement for `ls`.
- `pyenv` helps manage multiple Python versions.

```bash
$ brew install atuin direnv eza pyenv
```

### Visual Studio Code

Dotfiles assumes that VS Code is the primary code editor. If you prefer another editor, you should consider forking this repo and modifying it to suit your needs.

#### Ubuntu/Debian

```bash
$ wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
$ sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
$ sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
$ sudo apt update && sudo apt install code
```

#### Fedora

```bash
$ sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
$ sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
$ sudo dnf install code
```

#### Arch Linux

```bash
$ yay -S visual-studio-code-bin
```

### Node.js and Yarn

Dotfiles assumes you'll want to use Node.js and Yarn for JavaScript development. If you don't need these, you can skip this section.

Install Node Version Manager (nvm), a tool that allows you to manage multiple versions of Node.js easily.

```bash
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

Run the following command to load nvm into your current shell session. This is a temporary setup step. When Dotfiles is fully installed, it will automatically load nvm in future sessions.

```bash
$ export NVM_DIR="$HOME/.nvm"
$ [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
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

Enable Yarn v4 (Berry).

```bash
$ corepack enable
```

## Local Git configuration

Dotfiles uses a Git configuration split between a local file and a global file. The local file is for user and machine specific settings, while the global file contains shared settings.

Dotfiles assumes you'll sign commits with SSH keys. This is a secure way to verify the authenticity of your commits.

<Note>
If you don't have an SSH key, see the [GitHub documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#gpg-commit-signature-verification) to generate a new SSH key and add it to your SSH agent.
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

## Install Dotfiles

To install Dotfiles, you'll back up your existing dotfiles, clone the Dotfiles repository, and set up the configuration files. This process will ensure that your environment is ready to use the Dotfiles setup.

### Backup Existing Dotfiles

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

Restart your terminal to activate the new configuration. You should see Dotfiles bootstrap itself by:

- Creating a new symlink from `~/.gitconfig` to `~/.config/dotfiles/git/.gitconfig`
- Cloning the Antidote repo

You may be promoted to accept the host fingerprint for `github.com`. If you are, type `yes` to continue. Cloning Antidote and the plugins may take a few minutes, depending on your internet connection.

Next, restart your terminal again to load the new configuration. You should see the multi-line PowerLevel10k prompt with your current working directory on the first line and a `$` prompt on the second line.

## Optional Linux-Specific Setup

### Terminal emulator

Consider installing a terminal emulator with better features like ligatures, transparency, and GPU acceleration. Popular choices include:

- **Alacritty**: A fast, GPU-accelerated terminal emulator.
- **Kitty**: A feature-rich terminal emulator with support for ligatures and graphics.
- **Tilix**: A tiling terminal emulator that supports multiple panes and tabs.

### Nerd font

Install a nerd font for proper icon display.

```bash
$ wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
$ unzip FiraCode.zip -d ~/.local/share/fonts/
$ fc-cache -fv
```

Configure your terminal to use the nerd font and set it in VS Code preferences.

### Configure PowerLevel10k

PowerLevel10k is a theme for Zsh that provides a beautiful and informative prompt. If you don't like the configuration generated by Dotfiles, you can customize it.

```bash
$ p10k configure
```
