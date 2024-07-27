export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

# "random" loads a random theme each time Oh My Zsh is loaded.
# See which was loaded: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="mira"
CASE_SENSITIVE="true"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 13

# Disable marking untracked files under VCS as dirty.
# This makes repository status check for large repositories faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Standard plugins are in $ZSH/plugins/
# Custom plugins are in $ZSH_CUSTOM/plugins/
plugins=(
  brew
  direnv
  eza
  fast-syntax-highlighting
  fzf
  fzf-tab
  git
  iterm2
  nvm
  yarn
  zsh-autosuggestions
  )

zstyle ':omz:plugins:yarn' 'berry' yes
zstyle ':omz:plugins:iterm2' 'shell-integration' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'size-prefix' binary

FPATH="$(/opt/homebrew/bin/brew --prefix)/share/zsh/site-functions:${FPATH}"

source $ZSH/oh-my-zsh.sh

#################################
######### User configuration
#################################

# Interactive Shell Environment Variables
export LANG=en_US.UTF-8
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.cache/zsh-history
export KEYTIMEOUT=1
export PAGER="less -RF"
export TERM=xterm-256color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# 1Password agent
export SSH_AUTH_SOCK="~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Man pages
export MANPATH="/usr/local/man:$MANPATH"

# set vscode as default editor
VSCODE_BIN="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
export EDITOR="$VSCODE_BIN"
export KUBE_EDITOR="$VSCODE_BIN -w"
export GIT_EDITOR="$VSCODE_BIN -w"
sucode() {
  EDITOR="$VSCODE_BIN -w" command -- sudo -e "$@"
}

# Atuin
eval "$(atuin init zsh --disable-up-arrow)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias code=$VSCODE_BIN
alias tree="$(printf 'eza --tree' || printf 'tree -C')"
alias du="du -ach"
alias ps="ps aux"
