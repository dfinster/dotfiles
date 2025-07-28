#!/bin/zsh
#
# dotfiles-help - Help system for dotfiles management
#

# Source shared utilities
script_dir="$(cd "$(dirname "$0")" && pwd)"
source "$script_dir/dotfiles-shared.sh"

# Enhanced help function with comprehensive information
_dot_help() {
    echo -e "${_DOT_BLUE}Dotfiles Management System${_DOT_RESET}"
    echo
    echo -e "${_DOT_BLUE}USAGE:${_DOT_RESET}"
    echo -e "  ${_DOT_BLUE}dotfiles${_DOT_RESET} <command> [options]"
    echo
    echo -e "${_DOT_BLUE}CORE COMMANDS:${_DOT_RESET}"
    echo -e "  ${_DOT_BLUE}update${_DOT_RESET}               Apply dotfiles updates from remote repository"
    echo -e "  ${_DOT_BLUE}check${_DOT_RESET}                Check for available updates without applying"
    echo -e "  ${_DOT_BLUE}branch${_DOT_RESET} <name>        Switch to a different branch"
    echo -e "  ${_DOT_BLUE}doctor${_DOT_RESET}               Run system diagnostics"
    echo -e "  ${_DOT_BLUE}help${_DOT_RESET}                 Show this help message"
    echo
    echo -e "${_DOT_BLUE}CONFIGURATION MANAGEMENT:${_DOT_RESET}"
    echo -e "  ${_DOT_BLUE}config${_DOT_RESET}               Display current configuration"
    echo -e "  ${_DOT_BLUE}config edit${_DOT_RESET}          Edit configuration in \$EDITOR with validation"
    echo -e "  ${_DOT_BLUE}config validate${_DOT_RESET}      Validate current configuration"
    echo -e "  ${_DOT_BLUE}config reset${_DOT_RESET}         Reset configuration to defaults (with backup)"
    echo
    echo -e "${_DOT_BLUE}EXAMPLES:${_DOT_RESET}"
    echo -e "  ${_DOT_GREEN}dotfiles update${_DOT_RESET}             # Update to latest version"
    echo -e "  ${_DOT_GREEN}dotfiles branch feature${_DOT_RESET}     # Switch to 'feature' branch"
    echo -e "  ${_DOT_GREEN}dotfiles config edit${_DOT_RESET}        # Edit configuration safely"
    echo
    echo -e "${_DOT_BLUE}CONFIGURATION:${_DOT_RESET}"
    echo -e "  Config file: ${_DOT_BLUE}$_DOT_CONFIG_FILE${_DOT_RESET}"
    echo -e "  Dotfiles dir: ${_DOT_BLUE}${DOTFILES:-<not set>}${_DOT_RESET}"
    echo
}

# Main script execution
_dot_help
