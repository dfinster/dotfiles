#!/bin/zsh
#
# dotfiles-update - Update dotfiles from remote repository
#

# Source shared utilities
script_dir="$(cd "$(dirname "$0")" && pwd)"
source "$script_dir/dotfiles-shared.sh"

# Switch to target branch if needed
_dot_switch_branch() {
    if [[ "$_DOT_CURRENT_BRANCH" != "$_DOT_TARGET_BRANCH" ]]; then
        echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Switching to branch ${_DOT_BLUE}'$_DOT_TARGET_BRANCH'${_DOT_RESET}..."

        # Fetch to ensure we have the latest remote refs
        _dot_git_quiet fetch origin

        # Try to checkout existing local branch, or create tracking branch if it doesn't exist
        if ! _dot_git_quiet checkout "$_DOT_TARGET_BRANCH"; then
            # If checkout failed, try to create a new tracking branch
            if ! _dot_git_quiet checkout -b "$_DOT_TARGET_BRANCH" "origin/$_DOT_TARGET_BRANCH"; then
                echo -e "${_DOT_RED}Error:${_DOT_RESET} Failed to switch to branch ${_DOT_BLUE}'$_DOT_TARGET_BRANCH'${_DOT_RESET}." >&2
                return 1
            fi
        fi
        # Update _DOT_CURRENT_BRANCH after successful switch and validate
        local new_current=$(_dot_git branch --show-current)
        if [[ "$new_current" == "$_DOT_TARGET_BRANCH" ]]; then
            _DOT_CURRENT_BRANCH="$_DOT_TARGET_BRANCH"
        else
            echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Branch switch may have failed (expected '$_DOT_TARGET_BRANCH', got '$new_current')" >&2
            return 1
        fi
    fi
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} On branch ${_DOT_BLUE}'$_DOT_CURRENT_BRANCH'${_DOT_RESET}."
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Restart your terminal to apply changes."
    return 0
}

# Handle branch mismatch between environment and git repository
_dot_handle_branch_mismatch() {
    if [[ "$_DOT_TARGET_BRANCH" == "$_DOT_CURRENT_BRANCH" ]]; then
        return 0  # No mismatch, continue processing (success)
    fi

    echo
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} dotfiles configuration mismatch detected."
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} dotfiles is on the ${_DOT_BLUE}'$_DOT_CURRENT_BRANCH'${_DOT_RESET} branch."
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} dotfiles config is set to the ${_DOT_BLUE}'$_DOT_TARGET_BRANCH'${_DOT_RESET} branch."
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Please use ${_DOT_BLUE}'dotfiles branch <branchname>'${_DOT_RESET} to choose a branch."
    return 1  # Mismatch detected, stop processing (failure)
}



# Stash local changes before update
_dot_stash_local_changes() {
    # Check if there are any local changes
    if _dot_git_quiet diff-index --quiet HEAD --; then
        return 1  # No changes to stash
    fi

    # Attempt to stash changes
    if ! _dot_git_quiet stash push -m "Auto-stash before dotfiles update $(date)"; then
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Failed to stash local changes (git stash failed)" >&2
        return 1
    fi

    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Local changes stashed."
    return 0  # Stash created successfully
}

# Perform git pull and update plugins
_dot_perform_update() {
    # Pull latest changes from remote
    if ! _dot_git_quiet pull origin "$_DOT_TARGET_BRANCH"; then
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Update failed" >&2
        return 1
    fi

    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Dotfiles updated successfully."

    # Update antidote plugins if enabled and available
    if [[ "$_DOT_AUTO_UPDATE_ANTIDOTE" == "true" ]]; then
        # Try to load antidote if not already available
        if ! type antidote >/dev/null 2>&1; then
            local antidote_script="${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"
            if [[ -f "$antidote_script" ]]; then
                source "$antidote_script" 2>/dev/null || true
            fi
        fi

        if type antidote >/dev/null 2>&1; then
            echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Updating antidote plugins..."
            if antidote update >/dev/null 2>&1; then
                echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Antidote plugins updated successfully."
            else
                echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Antidote plugin update failed, but dotfiles update succeeded."
            fi
        else
            echo -e "${_DOT_YELLOW}Info:${_DOT_RESET} Antidote not available, skipping plugin updates."
        fi
    else
        echo -e "${_DOT_YELLOW}Info:${_DOT_RESET} Antidote auto-update is disabled (auto_update_antidote=false)."
    fi

    return 0
}

# Restore previously stashed changes
_dot_restore_stash() {
    if _dot_git_quiet stash pop; then
        echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Local stash restored successfully."
    else
        echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Local stash could not be restored; you may need to resolve conflicts manually."
        echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} You can view the stash with 'git stash list' and apply it manually if needed."
    fi
}

# Update function
_dot_update() {
    # Always run setup first for config loading and corruption detection
    if ! _dot_setup; then
        return 1
    fi

    # Handle branch mismatch between environment and repository
    if ! _dot_handle_branch_mismatch; then
        return 0
    fi

    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Updating dotfiles..."

    # Stash any local changes
    local stash_created=false
    if _dot_stash_local_changes; then
        stash_created=true
    fi

    # Perform the actual update
    if ! _dot_perform_update; then
        return 1
    fi

    # Restore stashed changes if we created a stash
    if [[ "$stash_created" == "true" ]]; then
        _dot_restore_stash
    fi

    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Please restart your terminal to apply all changes."
}

# Main script execution
_dot_update
