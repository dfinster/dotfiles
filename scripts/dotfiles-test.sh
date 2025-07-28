#!/bin/zsh
#
# dotfiles-test.sh - Comprehensive testing suite for dotfiles functionality
#

# Source shared utilities
script_dir="$(cd "$(dirname "$0")" && pwd)"
source "$script_dir/dotfiles-shared.sh"

# Test results tracking
TEST_TOTAL=0
TEST_PASSED=0
TEST_FAILED=0
TEST_ERRORS=()

# Test helper functions
_test_start() {
    echo -e "${_DOT_BLUE}🧪 Testing: $1${_DOT_RESET}"
    ((TEST_TOTAL++))
}

_test_pass() {
    echo -e "  ${_DOT_GREEN}✓${_DOT_RESET} $1"
    ((TEST_PASSED++))
}

_test_fail() {
    echo -e "  ${_DOT_RED}✗${_DOT_RESET} $1"
    TEST_ERRORS+=("$1")
    ((TEST_FAILED++))
}

_test_skip() {
    echo -e "  ${_DOT_YELLOW}⚠${_DOT_RESET} $1 (skipped)"
}

# Environment validation tests
_test_environment() {
    _test_start "Environment Setup"
    
    # Test DOTFILES variable
    if [[ -n "$DOTFILES" ]]; then
        _test_pass "DOTFILES environment variable is set"
    else
        _test_fail "DOTFILES environment variable is not set"
    fi
    
    # Test dotfiles directory
    if [[ -d "$DOTFILES" ]]; then
        _test_pass "Dotfiles directory exists"
    else
        _test_fail "Dotfiles directory does not exist: $DOTFILES"
    fi
    
    # Test git repository
    if [[ -d "$DOTFILES/.git" ]]; then
        _test_pass "Dotfiles is a git repository"
    else
        _test_fail "Dotfiles directory is not a git repository"
    fi
    
    # Test scripts directory
    if [[ -d "$DOTFILES/scripts" ]]; then
        _test_pass "Scripts directory exists"
    else
        _test_fail "Scripts directory does not exist"
    fi
    
    # Test essential scripts
    local scripts=("dotfiles-help.sh" "dotfiles-config.sh" "dotfiles-doctor.sh" "dotfiles-shared.sh")
    for script in "${scripts[@]}"; do
        if [[ -f "$DOTFILES/scripts/$script" ]]; then
            _test_pass "Script $script exists"
        else
            _test_fail "Script $script is missing"
        fi
    done
    
    echo
}

# Configuration management tests
_test_configuration() {
    _test_start "Configuration Management"
    
    # Test config file path
    if [[ -n "$_DOT_CONFIG_FILE" ]]; then
        _test_pass "Config file path is defined"
    else
        _test_fail "Config file path is not defined"
    fi
    
    # Test config loading
    if _dot_load_config >/dev/null 2>&1; then
        _test_pass "Configuration loads without errors"
    else
        _test_fail "Configuration loading failed"
    fi
    
    # Test validation functions
    if _dot_validate_config_value "selected_branch" "main"; then
        _test_pass "Config validation works for valid values"
    else
        _test_fail "Config validation failed for valid values"
    fi
    
    if ! _dot_validate_config_value "selected_branch" "invalid..branch"; then
        _test_pass "Config validation rejects invalid values"
    else
        _test_fail "Config validation accepts invalid values"
    fi
    
    # Test default values
    local defaults=("selected_branch" "cache_duration" "network_timeout" "auto_update_antidote")
    for key in "${defaults[@]}"; do
        local default=$(_dot_get_default "$key")
        if [[ -n "$default" ]]; then
            _test_pass "Default value exists for $key"
        else
            _test_fail "Default value missing for $key"
        fi
    done
    
    echo
}

# Command availability tests
_test_commands() {
    _test_start "Command Availability"
    
    # Test dotfiles function (may not be available in test environment)
    if command -v dotfiles >/dev/null 2>&1; then
        _test_pass "dotfiles command is available"
    else
        _test_skip "dotfiles command not available (expected when testing scripts directly)"
    fi
    
    # Test individual scripts
    local scripts=("help" "config" "doctor")
    for script in "${scripts[@]}"; do
        if [[ -x "$DOTFILES/scripts/dotfiles-${script}.sh" ]]; then
            _test_pass "Script dotfiles-${script}.sh is executable"
        else
            _test_fail "Script dotfiles-${script}.sh is not executable"
        fi
    done
    
    echo
}

# Help system tests
_test_help_system() {
    _test_start "Help System"
    
    # Test main help
    if "$DOTFILES/scripts/dotfiles-help.sh" >/dev/null 2>&1; then
        _test_pass "Main help displays without errors"
    else
        _test_fail "Main help failed to display"
    fi
    
    # Test topic-specific help
    local topics=("config" "doctor" "update" "troubleshooting")
    for topic in "${topics[@]}"; do
        if "$DOTFILES/scripts/dotfiles-help.sh" "$topic" >/dev/null 2>&1; then
            _test_pass "Help topic '$topic' displays without errors"
        else
            _test_fail "Help topic '$topic' failed to display"
        fi
    done
    
    echo
}

# Configuration command tests
_test_config_commands() {
    _test_start "Configuration Commands"
    
    # Test config show
    if "$DOTFILES/scripts/dotfiles-config.sh" show >/dev/null 2>&1; then
        _test_pass "Config show works"
    else
        _test_fail "Config show failed"
    fi
    
    # Test config validate
    if "$DOTFILES/scripts/dotfiles-config.sh" validate >/dev/null 2>&1; then
        _test_pass "Config validate works"
    else
        _test_fail "Config validate failed"
    fi
    
    # Test config help
    if "$DOTFILES/scripts/dotfiles-config.sh" help >/dev/null 2>&1; then
        _test_pass "Config help works"
    else
        _test_fail "Config help failed"
    fi
    
    # Test invalid command
    if ! "$DOTFILES/scripts/dotfiles-config.sh" invalid >/dev/null 2>&1; then
        _test_pass "Invalid config command properly rejected"
    else
        _test_fail "Invalid config command was accepted"
    fi
    
    echo
}

# Doctor command tests
_test_doctor_commands() {
    _test_start "Doctor Commands"
    
    # Test individual sections
    local sections=("system" "dotfiles" "dependencies" "performance")
    for section in "${sections[@]}"; do
        if "$DOTFILES/scripts/dotfiles-doctor.sh" "$section" >/dev/null 2>&1; then
            _test_pass "Doctor $section section works"
        else
            _test_fail "Doctor $section section failed"
        fi
    done
    
    # Test plugins section separately (may fail if antidote not installed)
    if "$DOTFILES/scripts/dotfiles-doctor.sh" plugins >/dev/null 2>&1; then
        _test_pass "Doctor plugins section works"
    else
        _test_skip "Doctor plugins section (antidote not installed)"
    fi
    
    # Test help
    if "$DOTFILES/scripts/dotfiles-doctor.sh" help >/dev/null 2>&1; then
        _test_pass "Doctor help works"
    else
        _test_fail "Doctor help failed"
    fi
    
    # Test invalid section
    if ! "$DOTFILES/scripts/dotfiles-doctor.sh" invalid >/dev/null 2>&1; then
        _test_pass "Invalid doctor section properly rejected"
    else
        _test_fail "Invalid doctor section was accepted"
    fi
    
    echo
}

# Error handling tests
_test_error_handling() {
    _test_start "Error Handling"
    
    # Test missing DOTFILES variable
    local old_dotfiles="$DOTFILES"
    unset DOTFILES
    if ! "$old_dotfiles/zsh/.zfunctions/dotfiles" help >/dev/null 2>&1; then
        _test_pass "Properly handles missing DOTFILES variable"
    else
        _test_fail "Does not handle missing DOTFILES variable"
    fi
    export DOTFILES="$old_dotfiles"
    
    # Test corruption detection
    if _dot_is_config_corrupted "/nonexistent/file"; then
        _test_pass "Corruption detection works for missing files"
    else
        _test_fail "Corruption detection failed for missing files"
    fi
    
    echo
}

# Performance tests
_test_performance() {
    _test_start "Performance"
    
    # Test command execution time
    local start_time=$(date +%s%N)
    "$DOTFILES/scripts/dotfiles-help.sh" >/dev/null 2>&1
    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))
    
    if [[ "$duration" -lt 1000 ]]; then  # Less than 1 second
        _test_pass "Help command executes quickly (${duration}ms)"
    else
        _test_fail "Help command is slow (${duration}ms)"
    fi
    
    # Test doctor performance
    start_time=$(date +%s%N)
    "$DOTFILES/scripts/dotfiles-doctor.sh" system >/dev/null 2>&1
    end_time=$(date +%s%N)
    duration=$(( (end_time - start_time) / 1000000 ))
    
    if [[ "$duration" -lt 5000 ]]; then  # Less than 5 seconds
        _test_pass "Doctor system command executes reasonably (${duration}ms)"
    else
        _test_fail "Doctor system command is slow (${duration}ms)"
    fi
    
    echo
}

# Integration tests
_test_integration() {
    _test_start "Integration"
    
    # Test color constants
    if [[ -n "$_DOT_BLUE" && -n "$_DOT_GREEN" && -n "$_DOT_RED" && -n "$_DOT_RESET" ]]; then
        _test_pass "Color constants are defined"
    else
        _test_fail "Color constants are missing"
    fi
    
    # Test shared functions availability
    if command -v _dot_load_config >/dev/null 2>&1; then
        _test_pass "Shared functions are available"
    else
        _test_fail "Shared functions are not available"
    fi
    
    echo
}

# Main test runner
_run_all_tests() {
    echo -e "${_DOT_BLUE}🧪 Dotfiles Comprehensive Test Suite${_DOT_RESET}"
    echo -e "${_DOT_BLUE}=====================================${_DOT_RESET}"
    echo
    
    _test_environment
    _test_configuration
    _test_commands
    _test_help_system
    _test_config_commands
    _test_doctor_commands
    _test_error_handling
    _test_performance
    _test_integration
    
    # Summary
    echo -e "${_DOT_BLUE}Test Results Summary:${_DOT_RESET}"
    echo -e "  ${_DOT_GREEN}✓ Passed:${_DOT_RESET} $TEST_PASSED"
    echo -e "  ${_DOT_RED}✗ Failed:${_DOT_RESET} $TEST_FAILED"
    echo -e "  ${_DOT_BLUE}📊 Total:${_DOT_RESET} $TEST_TOTAL"
    
    if [[ "$TEST_FAILED" -gt 0 ]]; then
        echo
        echo -e "${_DOT_RED}Failed Tests:${_DOT_RESET}"
        for error in "${TEST_ERRORS[@]}"; do
            echo -e "  • $error"
        done
        echo
        echo -e "${_DOT_RED}❌ Some tests failed. Please review and fix issues.${_DOT_RESET}"
        return 1
    else
        echo
        echo -e "${_DOT_GREEN}🎉 All tests passed! Dotfiles system is working correctly.${_DOT_RESET}"
        return 0
    fi
}

# Run tests
_run_all_tests