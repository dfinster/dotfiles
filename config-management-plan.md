# Config Management Implementation Plan

## Overview
This document outlines the implementation plan for GitHub Issues #50 (Config Management Commands) and #55 (Dotfiles Doctor Command). The plan prioritizes maintainability, performance, and follows macOS zsh function best practices.

## Current State Analysis

### Existing Infrastructure
- ✅ Configuration file handling (`_dot_load_config`, `_dot_validate_config`)
- ✅ Configuration validation and repair system
- ✅ Color constants and consistent formatting
- ✅ Error handling patterns
- ✅ Cross-platform detection (`is-macos` function)
- ✅ Command dispatch structure in main case statement
- ✅ Git integration for dotfiles repository management

### Configuration Variables Available
- `_DOT_CONFIG_FILE` - Config file path
- `_DOT_CONFIG_DEFAULTS` - Default values array
- `_DOT_CONFIG_VALIDATORS` - Validation patterns array
- `DOTFILES` - Dotfiles repository path
- Environment variables: `XDG_CONFIG_HOME`, `HOME`, `OSTYPE`

### Existing Utility Functions
- `_dot_trim_whitespace()` - String processing
- `_dot_parse_config_line()` - Config parsing
- `_dot_validate_config_value()` - Value validation
- `_dot_create_config_template()` - Template generation
- `_dot_is_config_corrupted()` - Corruption detection
- `_dot_repair_config_selectively()` - Automatic repair

## Issue #50: Config Management Commands

### Requirements Analysis
1. **`dotfiles config`** - Display current configuration
2. **`dotfiles config edit`** - Safe config editing with validation
3. **`dotfiles config reset`** - Reset to defaults
4. **`dotfiles config validate`** - Check configuration validity

### Implementation Strategy

#### Phase 1: Core Config Display (`dotfiles config`)
**Function:** `_dot_config_show()`

**Design Approach:**
- Leverage existing `_dot_load_config()` and validation infrastructure
- Use consistent color formatting from existing help function
- Display both current values and defaults for comparison
- Include source information (file vs default)

**Performance Considerations:**
- Single config file read
- No external command dependencies
- Minimal string processing using existing utilities

**Implementation Steps:**
1. Create `_dot_config_show()` function
2. Load and validate current configuration
3. Format output with source indicators
4. Handle missing/corrupted config gracefully
5. Add to main command dispatcher

#### Phase 2: Config Validation (`dotfiles config validate`)
**Function:** `_dot_config_validate()`

**Design Approach:**
- Reuse existing `_dot_is_config_corrupted()` logic
- Provide detailed validation report
- Show specific validation errors with line numbers
- Suggest fixes for common issues

**Performance Considerations:**
- Leverage existing single-pass validation
- No file modifications during validation
- Minimal memory footprint

**Implementation Steps:**
1. Create `_dot_config_validate()` function
2. Extend validation to provide detailed error reporting
3. Add severity levels (warning vs error)
4. Include repair suggestions
5. Return appropriate exit codes

#### Phase 3: Config Reset (`dotfiles config reset`)
**Function:** `_dot_config_reset()`

**Design Approach:**
- Create backup before reset (safety first)
- Use existing `_dot_create_config_template()` as foundation
- Preserve user's branch setting if valid
- Provide confirmation prompt for safety

**Performance Considerations:**
- Atomic file operations using temp files
- Single backup creation
- Minimal I/O operations

**Implementation Steps:**
1. Create `_dot_config_reset()` function
2. Implement backup creation with timestamped filename
3. Add confirmation prompt with escape option
4. Preserve critical user settings (branch)
5. Use atomic file replacement
6. Validate result after reset

#### Phase 4: Safe Config Editing (`dotfiles config edit`)
**Function:** `_dot_config_edit()`

**Design Approach:**
- Use `$EDITOR` environment variable (zsh best practice)
- Fallback to common macOS editors: `code`, `nano`, `vi`
- Pre-edit validation and backup
- Post-edit validation with automatic repair option
- Rollback capability on validation failure

**Performance Considerations:**
- External editor process management
- Efficient validation using existing functions
- Minimal temp file usage

**Implementation Steps:**
1. Create `_dot_config_edit()` function
2. Implement editor detection logic
3. Create pre-edit backup
4. Launch editor with proper signal handling
5. Validate changes post-edit
6. Offer repair or rollback on validation failure
7. Clean up temporary files

#### Phase 5: Command Integration
**Implementation Steps:**
1. Add config subcommand dispatcher `_dot_config()`
2. Update main case statement
3. Update `_dot_help()` function
4. Add config-specific help (`dotfiles config help`)
5. Ensure consistent error messaging

### Testing Strategy
- Test all config states: valid, invalid, missing, corrupted
- Test editor detection on clean macOS system
- Test atomic operations and rollback scenarios
- Validate cross-platform compatibility (macOS/Linux)

## Issue #55: Dotfiles Doctor Command

### Requirements Analysis
1. System information (OS, shell, hardware)
2. Dotfiles environment (location, branch, status)
3. Dependencies and tools availability
4. Plugin system status
5. Performance metrics
6. Configuration validation status

### Implementation Strategy

#### Phase 1: System Information Collection
**Function:** `_dot_doctor_system()`

**macOS-Specific Information Sources:**
- `uname -a` - System kernel info
- `sw_vers` - macOS version details
- `system_profiler SPHardwareDataType` - Hardware info
- `$SHELL` - Current shell
- `zsh --version` - Zsh version
- `echo $OSTYPE` - OS type detection

**Performance Considerations:**
- Cache expensive system_profiler calls
- Use conditional execution for macOS vs Linux
- Minimize external command invocations
- Parallel information gathering where safe

**Implementation Steps:**
1. Create `_dot_doctor_system()` function
2. Implement platform-specific detection
3. Add hardware information gathering (with fallbacks)
4. Include shell and terminal information
5. Format output with consistent styling

#### Phase 2: Dotfiles Environment Analysis
**Function:** `_dot_doctor_dotfiles()`

**Information to Collect:**
- `$DOTFILES` path and validation
- Current branch and remote status
- Working directory status (clean/dirty)
- Last update check time
- Configuration file status and validity

**Performance Considerations:**
- Reuse existing git wrappers (`_dot_git`)
- Leverage existing config validation
- Single git status check
- Avoid network calls for basic info

**Implementation Steps:**
1. Create `_dot_doctor_dotfiles()` function
2. Validate dotfiles environment setup
3. Check git repository status
4. Analyze configuration file health
5. Include last update information

#### Phase 3: Dependencies and Tools Check
**Function:** `_dot_doctor_dependencies()`

**Tools to Check:**
- Essential: `git`, `zsh`
- Package managers: `brew`, `apt`
- Editors: `code`, `nano`, `vim`
- dotfiles-specific: `antidote`
- Development tools: `node`, `python`, `ruby` (optional)

**Performance Considerations:**
- Use `command -v` for existence checks (fastest)
- Batch checks in single loop
- Avoid version checking for non-critical tools
- Provide summary counts

**Implementation Steps:**
1. Create `_dot_doctor_dependencies()` function
2. Define tool categories (essential, recommended, optional)
3. Implement batch availability checking
4. Add version detection for critical tools
5. Provide installation suggestions for missing tools

#### Phase 4: Plugin System Analysis
**Function:** `_dot_doctor_plugins()`

**Antidote-Specific Checks:**
- Antidote installation and version
- Plugin file location and validity
- Plugin load status
- Last update time
- Performance impact assessment

**Performance Considerations:**
- Conditional execution only if antidote exists
- Parse existing plugin files rather than loading
- Minimal plugin system interaction

**Implementation Steps:**
1. Create `_dot_doctor_plugins()` function
2. Check antidote installation status
3. Analyze plugin configuration
4. Report plugin health and last update
5. Identify potential performance issues

#### Phase 5: Performance Metrics Collection
**Function:** `_dot_doctor_performance()`

**Metrics to Collect:**
- Shell startup time estimation
- Config file size and complexity
- Number of loaded plugins
- Last update performance
- Cache file sizes and ages

**Performance Considerations:**
- Avoid actual shell startup measurement (too expensive)
- Use file metadata instead of content analysis
- Provide recommendations, not just metrics

**Implementation Steps:**
1. Create `_dot_doctor_performance()` function
2. Implement startup time estimation
3. Analyze configuration complexity
4. Check cache file health
5. Provide performance recommendations

#### Phase 6: Doctor Command Integration
**Function:** `_dot_doctor()`

**Design Approach:**
- Modular execution with section headers
- Progressive disclosure (summary first, details optional)
- Color-coded status indicators
- Optional verbose mode
- Machine-readable output option

**Implementation Steps:**
1. Create main `_dot_doctor()` function
2. Implement section-based execution
3. Add summary and detailed modes
4. Include health score calculation
5. Add troubleshooting suggestions

### Output Format Design

```
🩺 Dotfiles Doctor Report

✅ System Information
   OS: macOS 14.2.1 (23C71)
   Shell: zsh 5.9 (/bin/zsh)
   Hardware: MacBook Pro (2023)

✅ Dotfiles Environment  
   Location: /Users/user/.config/dotfiles
   Branch: main (up to date)
   Status: Clean working directory

⚠️  Dependencies
   ✅ Essential: git, zsh, brew
   ⚠️  Missing: antidote (recommended)
   ✅ Editors: code, nano, vim

✅ Configuration
   Status: Valid (5/5 settings)
   Last updated: 2 days ago

📊 Performance
   Estimated startup impact: ~50ms
   Plugin count: 12
   Cache status: Healthy

💡 Recommendations:
   • Install antidote for plugin management
   • Consider reducing plugin count for faster startup
```

## Implementation Timeline

### Phase 1 (Foundation) - Week 1
- [ ] Config display (`dotfiles config`)
- [ ] Config validation (`dotfiles config validate`)
- [ ] Basic doctor system info (`dotfiles doctor` - system section)

### Phase 2 (Safety Features) - Week 2  
- [ ] Config reset with backup (`dotfiles config reset`)
- [ ] Doctor dotfiles environment analysis
- [ ] Doctor dependencies check

### Phase 3 (Advanced Features) - Week 3
- [ ] Safe config editing (`dotfiles config edit`)
- [ ] Doctor plugin system analysis
- [ ] Doctor performance metrics

### Phase 4 (Polish & Integration) - Week 4
- [ ] Complete help system integration
- [ ] Comprehensive testing across scenarios
- [ ] Documentation updates
- [ ] Performance optimization

## Best Practices Implementation

### macOS zsh Function Standards
1. **Error Handling:** Use consistent exit codes and error messages
2. **Performance:** Minimize external command calls and file I/O
3. **Portability:** Conditional execution for macOS-specific features
4. **Safety:** Atomic operations, backups, and validation
5. **User Experience:** Clear output, progress indicators, helpful errors

### Code Organization
1. **Modularity:** Separate functions for each major operation
2. **Reusability:** Leverage existing validation and utility functions
3. **Consistency:** Follow existing naming conventions and patterns
4. **Documentation:** Inline comments for complex logic
5. **Testing:** Built-in validation and error scenarios

### Security Considerations
1. **Input Validation:** Sanitize all user inputs and file paths
2. **File Operations:** Use atomic writes and proper permissions
3. **Command Injection:** Validate branch names and config values
4. **Privacy:** Avoid exposing sensitive information in doctor output
5. **Backup Safety:** Timestamped backups with automatic cleanup

## Success Metrics

### Functionality
- [ ] All commands work on clean macOS system
- [ ] Graceful handling of missing dependencies
- [ ] Proper error messages and recovery suggestions
- [ ] Consistent performance across different system states

### User Experience
- [ ] Intuitive command structure matching existing patterns
- [ ] Clear, actionable output messages
- [ ] Safe operations with backup and rollback capabilities
- [ ] Helpful documentation and examples

### Technical Quality
- [ ] No external dependencies beyond standard macOS tools
- [ ] Minimal performance impact on shell startup
- [ ] Clean integration with existing codebase
- [ ] Comprehensive error handling and edge case coverage

This implementation plan provides a robust foundation for both config management and system diagnostics while maintaining the high standards of the existing dotfiles system.