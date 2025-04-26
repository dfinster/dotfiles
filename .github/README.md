# dotfiles

This is my version of [`getantidote/zdotdir`](https://github.com/getantidote/zdotdir).

## Prerequisites

Install the following tools before proceeding with the setup:

> **Note:**
> Ignore any post-installation configuration instructions displayed by the tools listed below.
> Antidote plugins will handle all necessary setup automatically.

1. Install these by following the links:

   - [![Homebrew](https://img.shields.io/badge/Homebrew-Install-blue?logo=homebrew&logoColor=white)](https://brew.sh)
   - [![Visual Studio Code](https://img.shields.io/badge/VS_Code-Install-blue?logo=visualstudiocode&logoColor=white)](https://code.visualstudio.com/download)
   - [![nvm](https://img.shields.io/badge/nvm-Install-blue?logo=nvm&logoColor=white)](https://github.com/nvm-sh/nvm)

2. Install these with Homebrew.
    ```zsh
    brew install nvm atuin direnv eza
    brew install --cask iterm2
    ```

3. Install Node.js with nvm.
    ```zsh
    nvm install --lts
    nvm use --lts
    ```

4. Install Yarn v4 (Berry) globally.
    ```zsh
    corepack enable
    npm install -g yarn
    ```

## Install dotfiles

Run these commands in your terminal:

1. Make a backup directory:
    ```zsh
    mkdir -p ~/dotfiles_backup
    ```

1. Back up existing dotfiles:

    ```zsh
    find ~ -maxdepth 1 '(' \
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
        ')' -exec mv {} ~/zsh_backup/ \;
    ```

1. Clone this project into `~/.config/dotfiles`:

    ```zsh
    git clone https://github.com/dfinster/dotfiles ~/.config/dotfiles
    ```

1. Source this in your `~/.zshenv` to bootstrap everything.
    ```zsh
    echo ". ~/.config/dotfiles/zsh/.zshenv" > ~/.zshenv
    ```

## Git Configuration

Git configuration is split between a local file and a global file.
The local file is for user and machine specific settings, while the global file contains shared settings.

1. Create `~/.gitconfig.local` with a user section containing your `name`, `email`, and `signingkey`.
    ```zsh
    [user]
        name = Your Name
        email = you@example.com
        signingkey = ssh-ed25519 AAAAC3 ...
    ```

    All other git options are found in `$ZDOTDIR/.gitconfig`.

1. Create `~/.ssh/allowed_signers` with your SSH public key to sign commits.
    ```zsh
    you@example.com ssh-ed25519 AAAAC3 ...
    ```

## Optional Setup

- Set your preferred iTerm2 theme.
- Install a [nerd font](https://www.nerdfonts.com/), then set it in iTerm2 preferences and VS Code settings.
- Run `p10k configure` to customize your PowerLevel10k prompt.
