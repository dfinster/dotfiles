#!/bin/zsh
# .zshenv - Zsh environment file, loaded always.

# Enable extended globbing for advanced pattern matching.
setopt EXTENDED_GLOB

# Set the configuration directories.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export DOTFILES="$XDG_CONFIG_HOME/dotfiles"

if [[ ! -d "$DOTFILES" ]]; then
  echo "Warning: \$DOTFILES directory ($DOTFILES) does not exist." >&2
  echo "Starting a minimal shell..." >&2
  # Reset important variables to minimal defaults
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
  unset ZDOTDIR
  return 0
fi

# Set ZDOTDIR to re-home Zsh.
export ZDOTDIR="$DOTFILES/zsh"

# Set Git configuration directory.
export GIT_CONFIG_GLOBAL="$DOTFILES/git/.gitconfig"

# Make VS Code behave as terminal editor
# Also requires the local `code-wait` plugin, found in .zsh_plugins.txt
export VISUAL=code-wait
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"
export KUBE_EDITOR="$VISUAL"

# Set Atuin configuration directory.
export ATUIN_CONFIG_DIR="$DOTFILES/atuin"

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

# Set the list of directories that zsh searches for commands.
path=(
  "$HOME"/{,s}bin(N)
  "$HOME"/.local/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)
