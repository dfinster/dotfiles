# Shell Startup Flow Documentation

## Overview

This document provides a detailed breakdown of the shell startup process, including decision trees and initialization flows for different shell types.

## Shell Type Decision Tree

```mermaid
graph TD
    START[Shell Started] --> LOGIN{Login Shell?}
    LOGIN -->|Yes| LOGINPATH[Login Shell Path]
    LOGIN -->|No| NONLOGIN[Non-Login Shell]
    
    LOGINPATH --> INTERACTIVE1{Interactive?}
    INTERACTIVE1 -->|Yes| LOGININT[Login + Interactive]
    INTERACTIVE1 -->|No| LOGINNONINT[Login + Non-Interactive]
    
    NONLOGIN --> INTERACTIVE2{Interactive?}
    INTERACTIVE2 -->|Yes| NONLOGININT[Non-Login + Interactive]
    INTERACTIVE2 -->|No| NONLOGINNONINT[Non-Login + Non-Interactive]
    
    LOGININT --> ZSHENV1[Source .zshenv]
    LOGINNONINT --> ZSHENV2[Source .zshenv]
    NONLOGININT --> ZSHENV3[Source .zshenv]
    NONLOGINNONINT --> ZSHENV4[Source .zshenv]
    
    ZSHENV1 --> ZPROFILE1[Source .zprofile]
    ZSHENV2 --> ZPROFILE2[Source .zprofile]
    ZSHENV3 --> SKIPPROFILE[Skip .zprofile]
    ZSHENV4 --> SKIPPROFILE
    
    ZPROFILE1 --> ZSHRC1[Source .zshrc]
    ZPROFILE2 --> SKIPRC1[Skip .zshrc]
    SKIPPROFILE --> ZSHRC2[Source .zshrc]
    SKIPPROFILE --> SKIPRC2[Skip .zshrc]
    
    ZSHRC1 --> READY1[Shell Ready]
    SKIPRC1 --> READY2[Shell Ready]
    ZSHRC2 --> READY3[Shell Ready]
    SKIPRC2 --> READY4[Shell Ready]

    classDef startNode fill:#e3f2fd
    classDef decisionNode fill:#fff3e0
    classDef processNode fill:#e8f5e8
    classDef endNode fill:#f3e5f5

    class START startNode
    class LOGIN,INTERACTIVE1,INTERACTIVE2 decisionNode
    class LOGINPATH,NONLOGIN,LOGININT,LOGINNONINT,NONLOGININT,NONLOGINNONINT processNode
    class ZSHENV1,ZSHENV2,ZSHENV3,ZSHENV4,ZPROFILE1,ZPROFILE2,SKIPPROFILE,ZSHRC1,ZSHRC2,SKIPRC1,SKIPRC2 processNode
    class READY1,READY2,READY3,READY4 endNode
```

## Detailed Startup Sequence

### Phase 1: Environment Setup (.zshenv)

```mermaid
flowchart TD
    START[.zshenv Execution] --> GLOB[Enable Extended Globbing]
    GLOB --> XDG[Set XDG Base Directories]
    XDG --> DOTFILES[Configure DOTFILES Path]
    DOTFILES --> CHECK{DOTFILES Exists?}
    
    CHECK -->|No| WARN[Print Warning]
    CHECK -->|Yes| ZDOTDIR[Set ZDOTDIR]
    
    WARN --> MINIMAL[Minimal PATH Setup]
    MINIMAL --> RETURN[Return Early]
    
    ZDOTDIR --> GITCONFIG[Set GIT_CONFIG_GLOBAL]
    GITCONFIG --> INTERACTIVE{Interactive Shell?}
    
    INTERACTIVE -->|No| EDITORS[Set Editors]
    INTERACTIVE -->|Yes| GITCHECK[Git Config Check]
    
    GITCHECK --> TARGETRES[Resolve Target Path]
    TARGETRES --> TARGETEXIST{Target Exists?}
    
    TARGETEXIST -->|No| GITWARN[Print Git Warning]
    TARGETEXIST -->|Yes| LINKSTATE[Check Link State]
    
    GITWARN --> EDITORS
    
    LINKSTATE --> LINKCHECK{Link Correct?}
    LINKCHECK -->|Yes| EDITORS
    LINKCHECK -->|No| BACKUP[Backup Existing]
    
    BACKUP --> SYMLINK[Create Symlink]
    SYMLINK --> EDITORS
    
    EDITORS --> ATUIN[Set Atuin Config]
    ATUIN --> DEDUP[Deduplicate Arrays]
    DEDUP --> PATHS[Configure PATH]
    PATHS --> END[.zshenv Complete]

    classDef startEnd fill:#e3f2fd
    classDef process fill:#e8f5e8
    classDef decision fill:#fff3e0
    classDef warning fill:#ffebee

    class START,END startEnd
    class GLOB,XDG,DOTFILES,ZDOTDIR,GITCONFIG,TARGETRES,LINKSTATE,BACKUP,SYMLINK,EDITORS,ATUIN,DEDUP,PATHS,MINIMAL process
    class CHECK,INTERACTIVE,TARGETEXIST,LINKCHECK decision
    class WARN,GITWARN,RETURN warning
```

### Phase 2: Login Shell Setup (.zprofile)

```mermaid
flowchart TD
    START[.zprofile Execution] --> ORBCHECK{OrbStack Available?}
    ORBCHECK -->|Yes| ORBLOAD[Load OrbStack Integration]
    ORBCHECK -->|No| ORBSKIP[Skip OrbStack]
    
    ORBLOAD --> SUCCESS[OrbStack Loaded]
    ORBSKIP --> SKIPPED[OrbStack Skipped]
    
    SUCCESS --> END[.zprofile Complete]
    SKIPPED --> END

    classDef startEnd fill:#e3f2fd
    classDef process fill:#e8f5e8
    classDef decision fill:#fff3e0

    class START,END startEnd
    class ORBLOAD,ORBSKIP,SUCCESS,SKIPPED process
    class ORBCHECK decision
```

### Phase 3: Interactive Shell Setup (.zshrc)

```mermaid
flowchart TD
    START[.zshrc Execution] --> P10KCHECK{P10k Cache Exists?}
    P10KCHECK -->|Yes| P10KLOAD[Load Instant Prompt]
    P10KCHECK -->|No| P10KSKIP[Skip Instant Prompt]
    
    P10KLOAD --> FUNCS[Setup Custom Functions]
    P10KSKIP --> FUNCS
    
    FUNCS --> ZSTYLES{.zstyles Exists?}
    ZSTYLES -->|Yes| ZLOAD[Load .zstyles]
    ZSTYLES -->|No| ZSKIP[Skip .zstyles]
    
    ZLOAD --> ANTIDOTE
    ZSKIP --> ANTIDOTE[Check Antidote]
    
    ANTIDOTE --> ANTEXIST{Antidote Exists?}
    ANTEXIST -->|No| CLONE[Clone Antidote]
    ANTEXIST -->|Yes| LOAD[Load Antidote]
    
    CLONE --> LOAD
    LOAD --> PLUGINS[Load Plugins]
    PLUGINS --> MODULES[Source .zshrc.d modules]
    
    MODULES --> OPTIONS[Load options.zsh]
    OPTIONS --> ALIASES[Load aliases.zsh]
    ALIASES --> BREWCHECK{Brew Available?}
    
    BREWCHECK -->|Yes| BREWLOAD[Load brew.zsh]
    BREWCHECK -->|No| BREWSKIP[Skip brew.zsh]
    
    BREWLOAD --> ORBSTACKCHECK{OrbStack Available?}
    BREWSKIP --> ORBSTACKCHECK
    
    ORBSTACKCHECK -->|Yes| ORBSTACKLOAD[Load orbstack.zsh]
    ORBSTACKCHECK -->|No| ORBSTACKSKIP[Skip orbstack.zsh]
    
    ORBSTACKLOAD --> P10KTHEME
    ORBSTACKSKIP --> P10KTHEME{.p10k.zsh Exists?}
    
    P10KTHEME -->|Yes| P10KFINAL[Load P10k Theme]
    P10KTHEME -->|No| P10KFINALSKIP[Skip P10k Theme]
    
    P10KFINAL --> END[.zshrc Complete]
    P10KFINALSKIP --> END

    classDef startEnd fill:#e3f2fd
    classDef process fill:#e8f5e8
    classDef decision fill:#fff3e0

    class START,END startEnd
    class P10KLOAD,P10KSKIP,FUNCS,ZLOAD,ZSKIP,CLONE,LOAD,PLUGINS,MODULES,OPTIONS,ALIASES,BREWLOAD,BREWSKIP,ORBSTACKLOAD,ORBSTACKSKIP,P10KFINAL,P10KFINALSKIP process
    class P10KCHECK,ZSTYLES,ANTEXIST,BREWCHECK,ORBSTACKCHECK,P10KTHEME decision
```

## Plugin Loading Sequence

```mermaid
sequenceDiagram
    participant ZshRC as .zshrc
    participant Antidote
    participant PluginTxt as .zsh_plugins.txt
    participant Plugins as Plugin Ecosystem

    ZshRC->>Antidote: Check installation
    alt Antidote Missing
        ZshRC->>Antidote: git clone antidote
    end
    
    ZshRC->>Antidote: source antidote.zsh
    ZshRC->>Antidote: antidote load
    
    Antidote->>PluginTxt: Read plugin definitions
    
    loop For each plugin
        Antidote->>Plugins: Check plugin cache
        alt Plugin Missing
            Antidote->>Plugins: Download/install plugin
        end
        Antidote->>Plugins: Load plugin
        Plugins-->>Antidote: Plugin ready
    end
    
    Antidote-->>ZshRC: All plugins loaded
```

## Module Loading Order

```mermaid
graph TD
    START[Module Loading Start] --> OPTIONS[options.zsh]
    OPTIONS --> ALIASES[aliases.zsh]
    ALIASES --> BREWCHECK{Homebrew Available?}
    
    BREWCHECK -->|Yes| BREW[brew.zsh]
    BREWCHECK -->|No| ORBCHECK
    
    BREW --> ORBCHECK{OrbStack Available?}
    ORBCHECK -->|Yes| ORBSTACK[orbstack.zsh]
    ORBCHECK -->|No| COMPLETE
    
    ORBSTACK --> COMPLETE[All Modules Loaded]

    classDef module fill:#e8f5e8
    classDef decision fill:#fff3e0
    classDef endpoint fill:#e3f2fd

    class OPTIONS,ALIASES,BREW,ORBSTACK module
    class BREWCHECK,ORBCHECK decision
    class START,COMPLETE endpoint
```

## Error Handling and Fallbacks

### Git Configuration Symlink

```mermaid
flowchart TD
    START[Git Config Setup] --> GLOBALSET{GIT_CONFIG_GLOBAL Set?}
    GLOBALSET -->|No| WARN1[Warning: Variable not set]
    GLOBALSET -->|Yes| RESOLVE[Resolve target path]
    
    WARN1 --> RETURN1[Return early]
    
    RESOLVE --> EXISTS{Target exists?}
    EXISTS -->|No| WARN2[Warning: Target missing]
    EXISTS -->|Yes| ISFILE{Is regular file?}
    
    WARN2 --> RETURN2[Return early]
    
    ISFILE -->|No| WARN3[Warning: Not a file]
    ISFILE -->|Yes| CHECKLINK[Check current link]
    
    WARN3 --> RETURN3[Return early]
    
    CHECKLINK --> LINKEXISTS{Link exists?}
    LINKEXISTS -->|No| CREATE[Create symlink]
    LINKEXISTS -->|Yes| CORRECT{Link correct?}
    
    CORRECT -->|Yes| SUCCESS[Link OK]
    CORRECT -->|No| BACKUP{File exists?}
    
    BACKUP -->|Yes| BACKUPFILE[Backup with timestamp]
    BACKUP -->|No| CREATE
    
    BACKUPFILE --> CREATE
    CREATE --> SUCCESS

    classDef process fill:#e8f5e8
    classDef decision fill:#fff3e0
    classDef warning fill:#ffebee
    classDef success fill:#e8f5e8

    class RESOLVE,CHECKLINK,CREATE,BACKUPFILE process
    class GLOBALSET,EXISTS,ISFILE,LINKEXISTS,CORRECT,BACKUP decision
    class WARN1,WARN2,WARN3,RETURN1,RETURN2,RETURN3 warning
    class SUCCESS success
```

### Tool Integration Fallbacks

```mermaid
graph TD
    BREW[Homebrew Check] --> BREWTEST{$+commands[brew]?}
    BREWTEST -->|Yes| BREWENV[Setup Homebrew environment]
    BREWTEST -->|No| BREWSKIP[Silent skip]
    
    ORBSTACK[OrbStack Check] --> ORBFILE{Init script exists?}
    ORBFILE -->|Yes| ORBLOAD[Source with error handling]
    ORBFILE -->|No| ORBSKIP[Silent skip]
    
    ANTIDOTE[Antidote Check] --> ANTDIR{Directory exists?}
    ANTDIR -->|No| ANTCLONE[Git clone repository]
    ANTDIR -->|Yes| ANTLOAD[Load existing installation]
    
    PLUGINS[Plugin Loading] --> PLUGINERR{Plugin error?}
    PLUGINERR -->|Yes| PLUGINCONT[Continue with next]
    PLUGINERR -->|No| PLUGINSUCCESS[Plugin loaded]

    classDef check fill:#fff3e0
    classDef success fill:#e8f5e8
    classDef skip fill:#f5f5f5
    classDef error fill:#ffebee

    class BREWTEST,ORBFILE,ANTDIR,PLUGINERR check
    class BREWENV,ORBLOAD,ANTLOAD,ANTCLONE,PLUGINSUCCESS success
    class BREWSKIP,ORBSKIP skip
    class PLUGINCONT error
```

## Performance Considerations

### Lazy Loading Strategy

```mermaid
graph TD
    STARTUP[Shell Startup] --> ESSENTIAL[Essential Only]
    ESSENTIAL --> INSTANT[Instant Prompt]
    INSTANT --> BACKGROUND[Background Loading]
    
    BACKGROUND --> PLUGINS[Plugin Installation]
    PLUGINS --> HEAVY[Heavy Integrations]
    HEAVY --> COMPLETE[Fully Loaded]
    
    COMPLETE --> READY[Shell Ready]

    classDef phase fill:#e8f5e8
    classDef endpoint fill:#e3f2fd

    class STARTUP,ESSENTIAL,INSTANT,BACKGROUND,PLUGINS,HEAVY,COMPLETE phase
    class READY endpoint
```

This startup flow ensures maximum compatibility across different shell invocation scenarios while maintaining optimal performance through lazy loading and graceful fallbacks.