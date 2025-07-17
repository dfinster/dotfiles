#!/bin/zsh
#
# dotfiles-update.zsh - Auto-check for dotfiles updates on shell startup
#

# Run update check on interactive shell startup
if [[ -o interactive ]]; then
    # Check if background mode is enabled (set DOTFILES_CHECK_BACKGROUND=1 to enable)
    if [[ "$DOTFILES_CHECK_BACKGROUND" == "1" ]]; then
        # Run check in background to avoid blocking terminal startup
        dotfiles-check-update &!
    else
        # Run synchronously (default behavior)
        dotfiles-check-update
    fi
fi