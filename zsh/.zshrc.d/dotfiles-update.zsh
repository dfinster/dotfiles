#!/bin/zsh
#
# dotfiles-update.zsh - Auto-check for dotfiles updates on shell startup
#

# Run update check on interactive shell startup
if [[ -o interactive ]]; then
    dotfiles-check-update
fi