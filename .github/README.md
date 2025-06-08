# dotfiles

This is my customized version of [`getantidote/zdotdir`](https://github.com/getantidote/zdotdir), extended to manage as many of my personal dotfiles as possible. See the project on [GitHub](https://github.com/dfinster/dotfiles).

If you aren't using Zsh, this won't work for you. To switch to Zsh on Ubuntu:

```bash
$ sudo apt update && \
  sudo apt install zsh && \
  chsh -s $(which zsh)
```

## Prerequisites

Ignore any post-installation configuration instructions displayed by the tools listed below.
The Antidote plugins handle all necessary setup steps automatically.

Install the following tools before proceeding with the setup:

1. Install these by following the links:

   - [![Homebrew](https://img.shields.io/badge/Homebrew-Install-blue?logo=homebrew&logoColor=white)](https://brew.sh)
   - [![Visual Studio Code](https://img.shields.io/badge/VS_Code-Install-blue?logo=visualstudiocode&logoColor=white)](https://code.visualstudio.com/download)
   - [![nvm](https://img.shields.io/badge/nvm-Install-blue?logo=nvm&logoColor=white)](https://github.com/nvm-sh/nvm)

1. Temporarily activate brew in your terminal session. (The Antidote plugins handle this permanently in a later step.)

    ```zsh
    $ eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ```
1. Install nvm, atuin, direnv, eza, and pyenv with Homebrew.

   ```zsh
   $ brew install nvm atuin direnv eza pyenv
   ```

1. (optional) If you want iTerm2, install it with Homebrew Cask.

    ```zsh
    $ brew install nvm atuin direnv eza pyenv
    $ brew install --cask iterm2
    ```

1. Install Node.js with nvm.

    ```zsh
    $ nvm install --lts
    $ nvm use --lts
    ```

1. Upgrade npm to the latest version.

    ```zsh
    $ npm install -g npm
    ```

1. Install Yarn v4 (Berry) globally.
    ```zsh
    $ corepack enable
    $ npm install -g yarn
    ```

## Install dotfiles

Run these commands in your terminal:

1. Make a backup directory:
    ```zsh
    $ mkdir -p ~/dotfiles_backup
    ```

1. Back up existing dotfiles:

    ```zsh
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
        ')' -exec mv {} ~/zsh_backup/ \;
    ```

1. Clone this project into `~/.config/dotfiles`:

    ```zsh
    $ git clone https://github.com/dfinster/dotfiles ~/.config/dotfiles
    ```

1. Bootstrap the dotfiles from your `~/.zshenv`.
    ```zsh
    $ echo ". ~/.config/dotfiles/zsh/.zshenv" > ~/.zshenv
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
- Install a [nerd font](https://www.nerdfonts.com/), then set it in iTerm2 and VS Code.
- Run `p10k configure` to customize your PowerLevel10k prompt.
