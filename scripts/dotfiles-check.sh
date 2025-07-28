#!/bin/bash
#
# dotfiles-autocheck - Automatic update checking for shell startup
#

# Source shared utilities
script_dir="$(cd "$(dirname "$0")" && pwd)"
source "$script_dir/dotfiles-shared.sh"

# Check if cache is recent enough to skip remote check
_dot_check_cache_validity() {
    local check_type="$1"

    # Manual checks always bypass cache (when not autocheck)
    if [[ "$check_type" != "autocheck" ]]; then
        return 1  # Force cache to return invalid, continue processing
    fi

    # Skip fetch if we've checked recently
    if [[ -f "$_DOT_CACHE_FILE" ]]; then
        local cache_time=$(_dot_get_file_mtime "$_DOT_CACHE_FILE")
        local current_time=$(date +%s)
        if (( current_time - cache_time < _DOT_CACHE_DURATION )); then
            return 0  # Cache valid, skip remote check
        fi
    fi

    return 1  # Cache invalid, continue processing
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

# Perform remote update check and display results
_dot_perform_remote_check() {
    local check_type="$1"

    # Check if we can reach GitHub (fail silently if offline)
    if ! _dot_git_quiet ls-remote origin; then
        return 0
    fi

    # Fetch latest remote information
    _dot_git_quiet fetch origin "$_DOT_TARGET_BRANCH"

    # Update cache file to record successful check
    touch "$_DOT_CACHE_FILE"

    # Check if local branch is behind remote
    local commits_behind
    if ! commits_behind=$(_dot_git rev-list --count HEAD..origin/"$_DOT_TARGET_BRANCH" 2>/dev/null) || [[ -z "$commits_behind" ]]; then
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Failed to check for updates (git rev-list failed)" >&2
        return 1
    fi

    # Exit early if up to date (most common case)
    if [[ "$commits_behind" -eq 0 ]]; then
        echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Your dotfiles are up to date."
        return 0
    fi

    # Show what's new and prompt user to run update
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Newer dotfiles are available."
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} You are ${_DOT_BLUE}${commits_behind}${_DOT_RESET} commit(s) behind the remote."
    echo
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} - See changelog at '${_DOT_BLUE}$_DOT_GITHUB_URL/blob/$_DOT_TARGET_BRANCH/CHANGELOG.md${_DOT_RESET}' for details."
    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} - Run '${_DOT_BLUE}dotfiles update${_DOT_RESET}' to update."
}

# Check for updates function
_dot_check() {
    # Always run setup first for config loading and corruption detection
    if ! _dot_setup; then
        return 0
    fi

    # Check cache validity and skip remote check if recent
    if _dot_check_cache_validity "$1"; then
        return 0
    fi

    # Display info for autocheck (automatic checks)
    if [[ "$1" == "autocheck" ]]; then
        echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Checking the ${_DOT_BLUE}$_DOT_CURRENT_BRANCH${_DOT_RESET} branch for updates."
    fi

    # Handle branch mismatch between environment and repository
    if ! _dot_handle_branch_mismatch; then
        return 0
    fi

    # Perform remote check and display results
    _dot_perform_remote_check "$1"

    # Display info for autocheck (automatic checks)
    if [[ "$1" == "autocheck" ]]; then
        echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Run ${_DOT_BLUE}dotfiles help${_DOT_RESET} for options."
    fi
}

# Run the check
_dot_check "$@"
