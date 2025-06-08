#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.

# Powerlevel10k instant prompt should load at the top of .zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"  # load cached prompt
fi

# Lazy-load Zsh function files from `.zfunctions` directory
ZFUNCDIR=${ZDOTDIR:-$HOME}/.zfunctions
fpath=($ZFUNCDIR $fpath)                       # search path for functions
autoload -Uz $ZFUNCDIR/*(.:t)                  # autoload all functions

# Set any zstyles
[[ ! -f ${ZDOTDIR:-$HOME}/.zstyles ]] || source ${ZDOTDIR:-$HOME}/.zstyles  # load styles

# Clone antidote if necessary
if [[ ! -d ${ZDOTDIR:-$HOME}/.antidote ]]; then
  git clone https://github.com/mattmc3/antidote ${ZDOTDIR:-$HOME}/.antidote  # install antidote
fi

# Load antidote plugins
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh  # load plugin manager
antidote load                                     # install plugins

# Source anything in .zshrc.d.
for _rc in ${ZDOTDIR:-$HOME}/.zshrc.d/*.zsh; do   # source plugin configs
  # But ignore tilde files (also .gitignored)
  if [[ $_rc:t != '~'* ]]; then
    source "$_rc"                               # skip backup files
  fi
done
unset _rc

# To customize prompt, run `p10k configure` or edit .p10k.zsh.
[[ ! -f ${ZDOTDIR:-$HOME}/.p10k.zsh ]] || source ${ZDOTDIR:-$HOME}/.p10k.zsh  # theme config
