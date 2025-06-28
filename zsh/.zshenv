#!/bin/zsh
# .zshenv - Zsh environment file, loaded always.

# Enable extended globbing for advanced pattern matching.
setopt EXTENDED_GLOB                        # allow advanced globs

# Set the configuration directories.
export XDG_CONFIG_HOME="$HOME/.config"      # base config dir
export XDG_DATA_HOME="$HOME/.local/share"   # base data dir
export XDG_CACHE_HOME="$HOME/.cache"        # base cache dir
export DOTFILES="$XDG_CONFIG_HOME/dotfiles" # location of this repo
export ZDOTDIR="$DOTFILES/zsh"              # Set ZDOTDIR to re-home Zsh.

# Set Git configuration directory
export GIT_CONFIG_GLOBAL="$DOTFILES/git/.gitconfig"

# Create a symlink for ~/.gitconfig to the global Git config file.
# This allows for a single Git configuration file to be used across all repositories.
# It is only created if the target exists and is a regular file.
# Only runs in interactive shells to avoid slowing down scripts or CI.
if [[ -o interactive ]]; then

  # 1. Ensure GIT_CONFIG_GLOBAL is defined and non-empty before proceeding.
  if [[ -z "${GIT_CONFIG_GLOBAL-}" ]]; then
    echo "Warning: GIT_CONFIG_GLOBAL is not set; skipping ~/.gitconfig symlink." >&2
    return
  fi

  # 2. Resolve the “true” absolute path of the target, if possible.
  if command -v realpath >/dev/null 2>&1; then
    target="$(realpath -- "$GIT_CONFIG_GLOBAL")"
  else
    target="$GIT_CONFIG_GLOBAL"
  fi

  # 3. Make sure the target actually exists *and* is a regular file.
  if [[ ! -e "$target" ]]; then
    echo "Warning: target '$target' does not exist; skipping ~/.gitconfig symlink." >&2
    return
  elif [[ ! -f "$target" ]]; then
    echo "Warning: target '$target' is not a regular file; skipping ~/.gitconfig symlink." >&2
    return
  fi

  # 4. Determine current ~/.gitconfig state
  link="$HOME/.gitconfig"                    # user gitconfig path
  if [[ -L "$link" ]]; then
    if command -v realpath >/dev/null 2>&1; then
      current="$(realpath -- "$link")"
    else
      current="$(readlink -- "$link")"
    fi
  else
    current=""
  fi

  # 5. Only (re)create the symlink if needed
  if [[ ! -L "$link" || "$current" != "$target" ]]; then

    # 5a. If ~/.gitconfig exists but is NOT a symlink, back it up with a timestamp
    if [[ -e "$link" && ! -L "$link" ]]; then
      # generate timestamp
    timestamp="$(date +%Y%m%dT%H%M%S)"        # unique timestamp
      backup="${link}.backup.${timestamp}"
      mv -- "$link" "$backup"
      echo "Backed up existing '$link' to '$backup'." >&2
    fi

    # 5b. Create the new symlink, forcing overwrite if necessary
    ln -sf -- "$target" "$link" \
      && echo "Linked '$link' → '$target'."
  fi

fi

# Make VS Code behave as terminal editor
export VISUAL=code-wait                         # VS Code helper script
export EDITOR="$VISUAL"                         # default editor
export GIT_EDITOR="$VISUAL"                     # git editor
export KUBE_EDITOR="$VISUAL"                    # kubectl editor
export ATUIN_CONFIG_DIR="$DOTFILES/atuin"       # Set Atuin configuration directory.

typeset -gU path fpath                          # Ensure path arrays do not contain duplicates.

# Set the list of directories that zsh searches for commands.
path=(
  "$HOME"/{,s}bin(N)                            # user binaries
  "$HOME"/.local/{,s}bin(N)                     # local binaries
  /opt/{homebrew,local}/{,s}bin(N)              # optional binaries
  /usr/local/{,s}bin(N)                         # local system binaries
  $path
)
