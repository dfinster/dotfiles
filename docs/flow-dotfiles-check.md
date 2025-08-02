# dotfiles check - Command Flow

## Overview

The `dotfiles check` command checks for available updates from the remote repository. It can run in two modes: manual check (immediate) or startup (respects cache duration). This command is automatically called during shell startup via the startup mechanism.

## Command Flow Diagram

```mermaid
flowchart TD
    A["`**dotfiles check**`"] --> B[zsh/.zfunctions/dotfiles]
    B --> C[scripts/dotfiles-check.sh]
    C --> D[_dot_check]
    D --> E[_dot_setup]
    E --> F[_dot_load_config]
    F --> G{Config already loaded?}
    G -->|Yes| H[Return early]
    G -->|No| I[_dot_create_config_template]
    I --> J{Config corrupted?}
    J -->|Yes| K[Show warning if interactive]
    J -->|No| L[Load config values]
    K --> M[Return error]
    L --> N[_dot_validate_config]
    N --> O[Export _DOT_CONFIG_LOADED=1]
    O --> P[Validate environment]
    P --> Q[_dot_check_cache_validity]
    Q --> R{auto_update_dotfiles disabled?}
    R -->|Yes| S[Return early (skip check)]
    R -->|No| T{Manual or startup?}
    T -->|Manual| U[Bypass cache]
    T -->|startup| V{Cache still valid?}
    V -->|Yes| W[Return early (skip check)]
    V -->|No| X[Continue with check]
    U --> X
    X --> Y{startup mode?}
    Y -->|Yes| Z[Show checking message]
    Y -->|No| AA[Silent mode]
    Z --> BB[_dot_handle_branch_mismatch]
    AA --> BB
    BB --> CC{Branch mismatch?}
    CC -->|Yes| DD[Show mismatch warning]
    CC -->|No| EE[_dot_perform_remote_check]
    DD --> FF[Exit without checking]
    EE --> GG{Can reach GitHub?}
    GG -->|No| HH[Exit silently]
    GG -->|Yes| II[git fetch origin]
    II --> JJ[git rev-list --count]
    JJ --> KK{Commits behind?}
    KK -->|0| LL[Update cache timestamp]
    KK -->|>0| MM[Show update available message]
    LL --> NN[Exit - up to date]
    MM --> OO[Show changelog link]
    OO --> PP[Show update command]
    PP --> QQ[Update cache timestamp]
    QQ --> RR[Exit with update info]
```

## Command Modes

### Manual Check (`dotfiles check`)
- **Cache behavior**: Always bypasses cache
- **Network check**: Always performs remote check
- **Output**: Shows detailed results immediately

### startup (`dotfiles startup`)
- **Cache behavior**: Respects cache duration
- **Network check**: Only if cache expired
- **Output**: Shows informational messages during check
- **Trigger**: Called automatically during shell startup

## Key Functions

### _dot_check_cache_validity
- **Purpose**: Determine if remote check should be skipped
- **Logic**:
  - If `auto_update_dotfiles=false`: Always skip startup
  - If manual check: Always proceed
  - If startup: Check cache timestamp vs `cache_duration`

### _dot_handle_branch_mismatch
- **Purpose**: Validate branch configuration before checking
- **Action**: Shows warning and exits if current branch ≠ configured branch

### _dot_perform_remote_check
- **Purpose**: Execute the actual remote comparison
- **Steps**:
  1. Test GitHub connectivity
  2. Fetch latest remote refs
  3. Count commits behind remote
  4. Update cache timestamp
  5. Display results

## Configuration Dependencies

- **auto_update_dotfiles**: Master switch for automatic checking
- **cache_duration**: Time in seconds between automatic checks
- **selected_branch**: Branch to check for updates
- **network_timeout**: Timeout for network operations

## Cache Management

- **Cache file**: `~/.config/dotfiles/.last-check`
- **Cache invalidation**: Manual checks always bypass cache
- **Cache update**: Updated after every successful remote check
- **Cache duration**: Configurable via `cache_duration` setting

## Network Behavior

- **Connectivity check**: Tests `git ls-remote origin` before proceeding
- **Graceful degradation**: Fails silently if network unavailable
- **Timeout handling**: Respects `network_timeout` configuration

## Output Behavior

### Up to Date
- Silent completion (no output)
- Cache timestamp updated

### Updates Available
- Shows number of commits behind
- Displays changelog URL
- Shows update command
- Updates cache timestamp

### Error Conditions
- **Branch mismatch**: Informational warning with resolution steps
- **Network failure**: Silent exit (no error message)
- **Config corruption**: Warning message with help command
