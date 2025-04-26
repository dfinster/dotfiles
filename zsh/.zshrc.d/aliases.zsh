#!/bin/zsh
#
# .aliases - Set whatever shell aliases you want.
#

# Common options
alias du="du -ach"
alias ps="ps aux"

# find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# misc
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
alias zdot='cd ${ZDOTDIR:-~}'
alias ldot='ls -ld .*'
