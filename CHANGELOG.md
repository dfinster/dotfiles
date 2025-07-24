# dotfiles Changelog

## [1.0.2] - 2025-07-17

### Added

- Added $DOTFILES_BRANCH variable to assign the branch selected for the dotfiles repository. This allows users to switch between branches easily. The variable is set in `~/.zshenv` before sourcing `~/.config/dotfiles/zsh/.zshenv`. If not set, it defaults to "main".
- Added antidote automatic update functionality to dotfiles-update. When you run dotfiles-update, it will now automatically update antidote plugins using antidote update after successfully pulling dotfiles changes.

## [1.0.1] - 2025-07-17

### Added

- Added new scheduled `dotfiles-check-update` function to detection changes in the dotfiles repository and prompt user for updates.
- Scheduled check runs when terminal opens, but only one time every 12 hours for performance.
- Added new `dotfiles-update` function to apply updates with a single command.
