#!/bin/zsh
# .zshenv - Zsh environment file, loaded always.

setopt EXTENDED_GLOB                                # allow advanced globs

# Set the configuration directories.
export XDG_CONFIG_HOME="$HOME/.config"              # base config dir
export XDG_DATA_HOME="$HOME/.local/share"           # base data dir
export XDG_CACHE_HOME="$HOME/.cache"                # base cache dir

export DOTFILES="$XDG_CONFIG_HOME/dotfiles"         # location of this repo

export ZDOTDIR="$DOTFILES/zsh"                      # Set ZDOTDIR to re-home Zsh.
export GIT_CONFIG_GLOBAL="$DOTFILES/git/.gitconfig" # Set Git configuration directory
export ATUIN_CONFIG_DIR="$DOTFILES/atuin"           # Set Atuin configuration directory.

# Make VS Code behave as terminal editor
export VISUAL=code-wait                 # VS Code helper script
export EDITOR="$VISUAL"                 # default editor
export GIT_EDITOR="$VISUAL"             # git editor
export KUBE_EDITOR="$VISUAL"            # kubectl editor

# Set the list of directories that zsh searches for commands.
path=(
  "$HOME"/{,s}bin(N)                    # user binaries
  "$HOME"/.local/{,s}bin(N)             # local binaries
  /opt/{homebrew,local}/{,s}bin(N)      # optional binaries
  /usr/local/{,s}bin(N)                 # local system binaries
  $path
)

typeset -gU path fpath                  # Ensure path arrays have no duplicates.

setup_gitconfig_symlink() {
  # Create a symlink for ~/.gitconfig for better Git compatibility.

  local link="$HOME/.gitconfig"

  # Resolve target path
  local target
  if command -v realpath >/dev/null 2>&1; then
    target="$(realpath -- "$GIT_CONFIG_GLOBAL")"
  else
    target="$GIT_CONFIG_GLOBAL"
  fi

  # Check if symlink already exists and points to correct target
  if [[ -L "$link" ]]; then
    local current
    if command -v realpath >/dev/null 2>&1; then
      current="$(realpath -- "$link")"
    else
      current="$(readlink "$link")"
    fi
    [[ "$current" == "$target" ]] && return
  fi

  # Validate target exists and is a regular file
  [[ ! -e "$target" ]] && {
    echo "Warning: target '$target' does not exist; skipping ~/.gitconfig symlink." >&2
    return
  }
  [[ ! -f "$target" ]] && {
    echo "Warning: target '$target' is not a regular file; skipping ~/.gitconfig symlink." >&2
    return
  }

  echo "$DOTFILES needs a symlink for Git compatibility.\n"

  # Backup existing file if it's not a symlink
  if [[ -e "$link" && ! -L "$link" ]]; then
    local timestamp="$(date +%Y%m%dT%H%M%S)"
    local backup="${link}.backup.${timestamp}"
    mv "$link" "$backup"
    echo "Backed up existing '$link' to '$backup'." >&2
  fi

  # Create the symlink
  ln -sf "$target" "$link" && echo "Linked '$link' -> '$target'."
}

if [[ -o interactive ]]; then
  setup_gitconfig_symlink
fi
