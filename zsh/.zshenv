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

# Set Git configuration directory (must be absolute or resolvable)
export GIT_CONFIG_GLOBAL="$DOTFILES/git/.gitconfig"

# ─────────────────────────────────────────────────────────────────────────────
# Only run this in interactive shells to avoid slowing down scripts or CI.
# zsh sets the “interactive” option when it’s an interactive session.
if [[ -o interactive ]]; then

  # ───────────────────────────────────────────────────────────────────────────
  # 1. Ensure GIT_CONFIG_GLOBAL is defined and non-empty before proceeding.
  if [[ -z "${GIT_CONFIG_GLOBAL-}" ]]; then
    echo "Warning: GIT_CONFIG_GLOBAL is not set; skipping ~/.gitconfig symlink." >&2
    return
  fi

  # ───────────────────────────────────────────────────────────────────────────
  # 2. Resolve the “true” absolute path of the target, if possible, to avoid
  #    comparing apples to oranges when relpaths are used.
  if command -v realpath >/dev/null 2>&1; then
    target="$(realpath -- "$GIT_CONFIG_GLOBAL")"
  else
    # fallback to what we have; readlink -f isn’t portable on macOS by default
    target="$GIT_CONFIG_GLOBAL"
  fi

  # ───────────────────────────────────────────────────────────────────────────
  # 3. Make sure the target actually exists *and* is a regular file
  #    (avoids pointing at a missing file or a directory).
  if [[ ! -e "$target" ]]; then
    echo "Warning: target '$target' does not exist; skipping ~/.gitconfig symlink." >&2
    return
  elif [[ ! -f "$target" ]]; then
    echo "Warning: target '$target' is not a regular file; skipping ~/.gitconfig symlink." >&2
    return
  fi

  # ───────────────────────────────────────────────────────────────────────────
  # 4. Determine current ~/.gitconfig state
  link="$HOME/.gitconfig"
  if [[ -L "$link" ]]; then
    # it’s a symlink — normalize it too (if possible) for accurate comparison
    if command -v realpath >/dev/null 2>&1; then
      current="$(realpath -- "$link")"
    else
      current="$(readlink -- "$link")"
    fi
  else
    # either missing or a plain file/directory
    current=""
  fi

  # ───────────────────────────────────────────────────────────────────────────
  # 5. Only (re)create the symlink if:
  #      • there is no symlink, or
  #      • the existing symlink points somewhere else
  if [[ ! -L "$link" || "$current" != "$target" ]]; then

    # 5a. If ~/.gitconfig exists but is NOT a symlink, back it up to avoid data loss
    if [[ -e "$link" && ! -L "$link" ]]; then
      mv -- "$link" "${link}.backup"
      echo "Backed up existing '$link' to '${link}.backup'." >&2
    fi

    # 5b. Create the new symlink, forcing overwrite if necessary
    ln -sf -- "$target" "$link" \
      && echo "Linked '$link' → '$target'."
  fi

fi

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
