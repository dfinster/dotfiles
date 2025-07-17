# dotfiles Changelog

## [1.0.1] - 2025-07-17

### Added

- Added new scheduled `dotfiles-check-update` function to detection changes in the dotfiles repository and prompt user for updates.
- Scheduled check runs when terminal opens, but only one time every 12 hours for performance.
- Added new `dotfiles-update` function to apply updates with a single command.
