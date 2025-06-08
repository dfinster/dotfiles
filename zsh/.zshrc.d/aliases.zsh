#!/bin/zsh
#
# .aliases - Set whatever shell aliases you want.
#

# Common options
alias du="du -ach"                                # show dir sizes in human form
alias ps="ps aux"                                 # full process list

# find
alias fd='find . -type d -name'                    # find directories
alias ff='find . -type f -name'                    # find files

# misc
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'  # edit zshrc
alias zdot='cd ${ZDOTDIR:-~}'                             # cd to ZDOTDIR
alias ldot='ls -ld .*'                                    # list dotfiles
