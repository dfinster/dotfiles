(( $+commands[brew] )) || return 1  # exit if brew not installed
eval $(brew shellenv)               # configure Homebrew environment
