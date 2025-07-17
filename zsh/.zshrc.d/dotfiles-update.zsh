#!/bin/zsh
#
# dotfiles-update.zsh - Auto-check for dotfiles updates on shell startup
#

# Run update check on interactive shell startup (deferred)
if [[ -o interactive ]]; then
    # Defer execution to allow shell to fully initialize
    zle -N check-dotfiles-update
    check-dotfiles-update() { dotfiles-update }
    
    # Schedule to run after shell is ready
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd check-dotfiles-update-once
    check-dotfiles-update-once() {
        add-zsh-hook -d precmd check-dotfiles-update-once
        dotfiles-update
    }
fi