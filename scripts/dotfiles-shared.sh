#!/bin/zsh
#
# dotfiles-shared.sh - Shared utilities for dotfiles scripts
#

# Configuration file path
readonly _DOT_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/dotfiles.conf"

# Cache file paths
readonly _DOT_CACHE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/.last-check"
readonly _DOT_CACHE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/.cache"

# Configuration defaults - single source of truth
readonly _DOT_DEFAULT_SELECTED_BRANCH="main"
readonly _DOT_DEFAULT_CACHE_DURATION="172800"  # 2 days in seconds
readonly _DOT_DEFAULT_NETWORK_TIMEOUT="30"
readonly _DOT_DEFAULT_AUTO_UPDATE_ANTIDOTE="true"
readonly _DOT_DEFAULT_AUTO_UPDATE_DOTFILES="true"
readonly _DOT_GITHUB_URL="https://github.com/dfinster/dotfiles"

# Initialize with defaults
_DOT_SELECTED_BRANCH="$_DOT_DEFAULT_SELECTED_BRANCH"
_DOT_CACHE_DURATION="$_DOT_DEFAULT_CACHE_DURATION"
_DOT_NETWORK_TIMEOUT="$_DOT_DEFAULT_NETWORK_TIMEOUT"
_DOT_AUTO_UPDATE_ANTIDOTE="$_DOT_DEFAULT_AUTO_UPDATE_ANTIDOTE"
_DOT_AUTO_UPDATE_DOTFILES="$_DOT_DEFAULT_AUTO_UPDATE_DOTFILES"

# Get default value for a config key
_dot_get_default() {
    case "$1" in
        selected_branch) echo "$_DOT_DEFAULT_SELECTED_BRANCH" ;;
        cache_duration) echo "$_DOT_DEFAULT_CACHE_DURATION" ;;
        network_timeout) echo "$_DOT_DEFAULT_NETWORK_TIMEOUT" ;;
        auto_update_antidote) echo "$_DOT_DEFAULT_AUTO_UPDATE_ANTIDOTE" ;;
        auto_update_dotfiles) echo "$_DOT_DEFAULT_AUTO_UPDATE_DOTFILES" ;;
        *) echo "" ;;
    esac
}

# Get validator pattern for a config key
_dot_get_validator() {
    case "$1" in
        selected_branch) echo '^[a-zA-Z0-9._/-]+$' ;;
        cache_duration) echo '^[0-9]+$' ;;
        network_timeout) echo '^[0-9]+$' ;;
        auto_update_antidote) echo '^(true|false)$' ;;
        auto_update_dotfiles) echo '^(true|false)$' ;;
        *) echo "" ;;
    esac
}

# Color constants
readonly _DOT_RED='\033[91m'
readonly _DOT_YELLOW='\033[93m'
readonly _DOT_GREEN='\033[92m'
readonly _DOT_BLUE='\033[94m'
readonly _DOT_RESET='\033[0m'

# Shared validation helper functions
_dot_trim_whitespace() {
    local value="$1"
    value="${value#"${value%%[![:space:]]*}"}"  # trim leading
    value="${value%"${value##*[![:space:]]}"}"  # trim trailing
    echo "$value"
}

_dot_parse_config_line() {
    local line="$1"

    # Skip comments and empty lines
    [[ "$line" =~ ^[[:space:]]*# ]] && return 1
    [[ -z "$line" ]] && return 1
    [[ "$line" != *"="* ]] && return 1

    # Extract and trim key/value - output to stdout
    local key="$(_dot_trim_whitespace "${line%%=*}")"
    local value="$(_dot_trim_whitespace "${line#*=}")"

    [[ -n "$key" ]] || return 1

    # Output key and value separated by tab
    echo -e "$key\t$value"
    return 0
}

_dot_validate_config_value() {
    local key="$1"
    local value="$2"

    # Get validator pattern
    local pattern="$(_dot_get_validator "$key")"
    [[ -n "$pattern" ]] || return 1

    # Validate using the pattern
    [[ "$value" =~ $pattern ]] || return 1

    # Additional range checks for numeric values
    case "$key" in
        cache_duration)
            (( value > 0 && value < 86400000 )) || return 1
            ;;
        network_timeout)
            (( value >= 1 && value <= 300 )) || return 1
            ;;
    esac

    return 0
}

# Generate config file content - DRY shared function
_dot_generate_config_content() {
    local branch_override="${1:-$_DOT_DEFAULT_SELECTED_BRANCH}"
    local comment_line="${2:-}"

    echo "# Dotfiles Configuration"
    echo "# This file is not tracked in git and contains user-specific settings"
    if [[ -n "$comment_line" ]]; then
        echo "# $comment_line"
    fi
    echo
    echo "selected_branch=$branch_override"
    echo "cache_duration=$_DOT_DEFAULT_CACHE_DURATION"
    echo "network_timeout=$_DOT_DEFAULT_NETWORK_TIMEOUT"
    echo "auto_update_antidote=$_DOT_DEFAULT_AUTO_UPDATE_ANTIDOTE"
    echo "auto_update_dotfiles=$_DOT_DEFAULT_AUTO_UPDATE_DOTFILES"
}

# Create configuration file template if it doesn't exist
_dot_create_config_template() {
    if [[ ! -f "$_DOT_CONFIG_FILE" ]]; then
        _dot_generate_config_content > "$_DOT_CONFIG_FILE"
        echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Created config template at ${_DOT_BLUE}$_DOT_CONFIG_FILE${_DOT_RESET}"
        echo -e "${_DOT_GREEN}Info:${_DOT_RESET} Edit this file to customize your dotfiles settings"
    fi
}

# Check if config file is corrupted
_dot_is_config_corrupted() {
    local config_file="$1"

    # File doesn't exist - not corrupted, just missing
    [[ ! -f "$config_file" ]] && return 0

    # Check if file is writable
    if [[ ! -w "$_DOT_CONFIG_FILE" ]]; then
        echo -e "${_DOT_RED}Error:${_DOT_RESET} Cannot write to $_DOT_CONFIG_FILE" >&2
        return 1  # Not writable, consider it corrupted
    fi

    # Check for empty file or only whitespace
    if [[ ! -s "$config_file" ]] || ! grep -q '[^[:space:]]' "$config_file" 2>/dev/null; then
        return 1  # corrupted
    fi

    # Single pass validation - check all issues at once
    local valid_lines=0
    local parse_errors=0
    # Use simple variables to track found keys instead of associative arrays
    local found_selected_branch=0 found_cache_duration=0 found_network_timeout=0 found_auto_update_antidote=0 found_auto_update_dotfiles=0
    local key value

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Parse line and skip if not a config line
        if _dot_parse_config_line "$line" >/dev/null 2>&1; then
            local parse_result=$(_dot_parse_config_line "$line" 2>/dev/null)
            key="${parse_result%%$'\t'*}"
            value="${parse_result#*$'\t'}"

            ((valid_lines++))

            # Validate known keys
            if [[ -n "$(_dot_get_validator "$key")" ]]; then
                # Mark key as found
                case "$key" in
                    selected_branch) found_selected_branch=1 ;;
                    cache_duration) found_cache_duration=1 ;;
                    network_timeout) found_network_timeout=1 ;;
                    auto_update_antidote) found_auto_update_antidote=1 ;;
                    auto_update_dotfiles) found_auto_update_dotfiles=1 ;;
                esac

                if ! _dot_validate_config_value "$key" "$value"; then
                    return 1  # corrupted - invalid value
                fi
            fi
        else
            # Check for malformed non-comment lines
            if [[ ! "$line" =~ ^[[:space:]]*# ]] && [[ "$line" =~ [a-zA-Z] ]] && [[ "$line" != *"="* ]]; then
                ((parse_errors++))
            fi
        fi
    done < "$config_file"

    # Check for corruption conditions
    (( valid_lines == 0 )) && return 1  # no valid config lines
    (( parse_errors > 0 )) && return 1  # parse errors found

    # Check for missing required keys
    [[ $found_selected_branch -eq 0 ]] && return 1
    [[ $found_cache_duration -eq 0 ]] && return 1
    [[ $found_network_timeout -eq 0 ]] && return 1
    [[ $found_auto_update_antidote -eq 0 ]] && return 1
    [[ $found_auto_update_dotfiles -eq 0 ]] && return 1

    return 0  # not corrupted
}

# Load configuration from file and environment variables
_dot_load_config() {
    # Skip if already loaded recently (within same shell session)
    if [[ -n "$_DOT_CONFIG_LOADED" ]]; then
        return 0
    fi

    # Create config template if it doesn't exist
    _dot_create_config_template

    # Check for corruption and recover if needed
    if [[ -f "$_DOT_CONFIG_FILE" ]] && ! _dot_is_config_corrupted "$_DOT_CONFIG_FILE"; then
        # Show warning once per shell session during interactive startup
        if [[ -z "$_DOT_CONFIG_WARNED" ]]; then
            echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Config file appears corrupted, please run: ${_DOT_GREEN}dotfiles config help${_DOT_RESET}" >&2
            echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Using default configuration." >&2
            export _DOT_CONFIG_WARNED=1
        fi
        return 1
    fi

    # Load from config file if it exists
    if [[ -f "$_DOT_CONFIG_FILE" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            # Skip comments and empty lines
            [[ "$line" =~ ^[[:space:]]*# ]] && continue
            [[ -z "$line" ]] && continue

            # Only process lines containing '='
            [[ "$line" != *"="* ]] && continue

            # Split on first '=' only, preserving '=' in values
            key="${line%%=*}"
            value="${line#*=}"

            # Trim whitespace from key and value
            key="${key#"${key%%[![:space:]]*}"}"    # trim leading
            key="${key%"${key##*[![:space:]]}"}"    # trim trailing
            value="${value#"${value%%[![:space:]]*}"}"  # trim leading
            value="${value%"${value##*[![:space:]]}"}"  # trim trailing

            # Skip if key is empty after trimming
            [[ -z "$key" ]] && continue

            case "$key" in
                selected_branch) _DOT_SELECTED_BRANCH="$value" ;;
                cache_duration) _DOT_CACHE_DURATION="$value" ;;
                network_timeout) _DOT_NETWORK_TIMEOUT="$value" ;;
                auto_update_antidote) _DOT_AUTO_UPDATE_ANTIDOTE="$value" ;;
                auto_update_dotfiles) _DOT_AUTO_UPDATE_DOTFILES="$value" ;;
            esac
        done < "$_DOT_CONFIG_FILE"
    fi

    # Validate and sanitize loaded configuration values
    _dot_validate_config

    # Mark as loaded for this session
    export _DOT_CONFIG_LOADED=1
}

# Validate and reset invalid config values to defaults
_dot_validate_config() {
    # Validate each config key and reset to default if invalid
    if ! _dot_validate_config_value "selected_branch" "$_DOT_SELECTED_BRANCH"; then
        [[ "$_DOT_SELECTED_BRANCH" != "$_DOT_DEFAULT_SELECTED_BRANCH" ]] && \
            echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Invalid selected_branch '$_DOT_SELECTED_BRANCH', using default '$_DOT_DEFAULT_SELECTED_BRANCH'" >&2
        _DOT_SELECTED_BRANCH="$_DOT_DEFAULT_SELECTED_BRANCH"
    fi

    if ! _dot_validate_config_value "cache_duration" "$_DOT_CACHE_DURATION"; then
        [[ "$_DOT_CACHE_DURATION" != "$_DOT_DEFAULT_CACHE_DURATION" ]] && \
            echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Invalid cache_duration '$_DOT_CACHE_DURATION', using default '$_DOT_DEFAULT_CACHE_DURATION'" >&2
        _DOT_CACHE_DURATION="$_DOT_DEFAULT_CACHE_DURATION"
    fi

    if ! _dot_validate_config_value "network_timeout" "$_DOT_NETWORK_TIMEOUT"; then
        [[ "$_DOT_NETWORK_TIMEOUT" != "$_DOT_DEFAULT_NETWORK_TIMEOUT" ]] && \
            echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Invalid network_timeout '$_DOT_NETWORK_TIMEOUT', using default '$_DOT_DEFAULT_NETWORK_TIMEOUT'" >&2
        _DOT_NETWORK_TIMEOUT="$_DOT_DEFAULT_NETWORK_TIMEOUT"
    fi

    if ! _dot_validate_config_value "auto_update_antidote" "$_DOT_AUTO_UPDATE_ANTIDOTE"; then
        [[ "$_DOT_AUTO_UPDATE_ANTIDOTE" != "$_DOT_DEFAULT_AUTO_UPDATE_ANTIDOTE" ]] && \
            echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Invalid auto_update_antidote '$_DOT_AUTO_UPDATE_ANTIDOTE', using default '$_DOT_DEFAULT_AUTO_UPDATE_ANTIDOTE'" >&2
        _DOT_AUTO_UPDATE_ANTIDOTE="$_DOT_DEFAULT_AUTO_UPDATE_ANTIDOTE"
    fi

    if ! _dot_validate_config_value "auto_update_dotfiles" "$_DOT_AUTO_UPDATE_DOTFILES"; then
        [[ "$_DOT_AUTO_UPDATE_DOTFILES" != "$_DOT_DEFAULT_AUTO_UPDATE_DOTFILES" ]] && \
            echo -e "${_DOT_YELLOW}Warning:${_DOT_RESET} Invalid auto_update_dotfiles '$_DOT_AUTO_UPDATE_DOTFILES', using default '$_DOT_DEFAULT_AUTO_UPDATE_DOTFILES'" >&2
        _DOT_AUTO_UPDATE_DOTFILES="$_DOT_DEFAULT_AUTO_UPDATE_DOTFILES"
    fi
}

# Git command wrappers to eliminate repetition
_dot_git() {
    git -C "$DOTFILES" "$@"
}

_dot_git_quiet() {
    _dot_git "$@" >/dev/null 2>&1
}

# Get file modification time (cross-platform)
_dot_get_file_mtime() {
    local file="$1"
    if [[ "$OSTYPE" == darwin* ]]; then
        stat -f %m "$file" 2>/dev/null || echo 0
    else
        stat -c %Y "$file" 2>/dev/null || echo 0
    fi
}

# Common setup function
_dot_setup() {
    # Load configuration, exit early if corrupted
    if ! _dot_load_config; then
        return 1
    fi

    # Exit early if DOTFILES environment variable is not set
    if [[ -z "$DOTFILES" ]]; then
        return 1
    fi

    # Exit early if dotfiles directory doesn't exist
    if [[ ! -d "$DOTFILES" ]]; then
        return 1
    fi

    # Exit early if $DOTFILES is not a git repository
    if ! _dot_git_quiet rev-parse --git-dir; then
        return 1
    fi

    # Determine target branch from config (with env var override)
    _DOT_TARGET_BRANCH="$_DOT_SELECTED_BRANCH"

    # Get current branch
    _DOT_CURRENT_BRANCH=$(_dot_git branch --show-current)

    return 0
}
