#!/bin/zsh
#
# dotfiles-branch - Branch management for dotfiles
#

# Source shared utilities
script_dir="$(cd "$(dirname "$0")" && pwd)"
source "$script_dir/dotfiles-shared.sh"

# Validate branch name to prevent command injection
_dot_validate_branch_name() {
    local branch="$1"

    # Check for empty input
    if [[ -z "$branch" ]]; then
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Branch name is required" >&2
        return 1
    fi

    # Prevent shell metacharacters that could cause command injection
    if [[ "$branch" =~ [\$\`\;\|\&\<\>\(\)] ]]; then
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Branch name contains invalid characters" >&2
        return 1
    fi

    return 0
}

# Verify branch exists on remote GitHub repository
_dot_verify_remote_branch() {
    local branch="$1"

    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Checking if branch ${_DOT_BLUE}'$branch'${_DOT_RESET} exists on GitHub..."

    # Check network connectivity
    if ! _dot_git_quiet ls-remote origin; then
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Cannot connect to GitHub" >&2
        return 1
    fi

    # Check if branch exists
    if ! _dot_git_quiet ls-remote --exit-code --heads origin "$branch"; then
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Branch '$branch' does not exist on GitHub" >&2
        return 1
    fi

    return 0
}

# Update default branch in configuration file
_dot_update_config_file() {
    local new_branch="$1"

    echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Updating default branch to ${_DOT_BLUE}'$new_branch'${_DOT_RESET} in config file..."

    # Ensure config file exists
    _dot_create_config_template

    # Check if file is writable
    if [[ ! -w "$_DOT_CONFIG_FILE" ]]; then
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Cannot write to $_DOT_CONFIG_FILE" >&2
        return 1
    fi

    # Atomic config update using temporary file
    local temp_file="${_DOT_CONFIG_FILE}.tmp.$$"
    local updated=false

    # Create new config with updated value
    if [[ -f "$_DOT_CONFIG_FILE" ]]; then
        # Process existing config line by line
        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ "$line" =~ ^[[:space:]]*selected_branch[[:space:]]*= ]]; then
                echo "selected_branch=$new_branch"
                updated=true
            else
                echo "$line"
            fi
        done < "$_DOT_CONFIG_FILE" > "$temp_file"
    fi

    # Add selected_branch if it wasn't found in existing config
    if [[ "$updated" == "false" ]]; then
        echo "selected_branch=$new_branch" >> "$temp_file"
    fi

    # Atomically replace the original file
    if ! mv "$temp_file" "$_DOT_CONFIG_FILE"; then
        # Cleanup on failure
        rm -f "$temp_file" 2>/dev/null || true
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Failed to update config file" >&2
        return 1
    fi

    # Update the variables for this session
    _DOT_SELECTED_BRANCH="$new_branch"
    _DOT_TARGET_BRANCH="$new_branch"

    return 0
}

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

# Set branch function
_dot_branch() {
    local new_branch="$1"

    # Validate branch name to prevent command injection
    if ! _dot_validate_branch_name "$new_branch"; then
        echo "Usage: dotfiles branch <branchname>"
        return 1
    fi

    # Setup common variables
    if ! _dot_setup; then
        return 1
    fi

    # Verify branch exists on remote
    if ! _dot_verify_remote_branch "$new_branch"; then
        return 1
    fi

    # Update configuration file
    if ! _dot_update_config_file "$new_branch"; then
        return 1
    fi

    # Switch to the branch
    _dot_switch_branch
}

# Check if we have a branch argument
if [[ -z "$1" ]]; then
    echo -e "${_DOT_RED}Error:${_DOT_RESET} Branch name is required" >&2
    echo "Usage: dotfiles branch <branchname>"
    exit 1
fi

# Run the branch command
_dot_branch "$1"
