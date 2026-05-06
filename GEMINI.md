# System Context

This workspace is running on **NixOS**.

## Environment Details
- **Nix Flakes**: The system uses Nix Flakes for configuration management.
- **Window Manager**: **niri** (a scrollable-tiling Wayland compositor).
- **Status**: The system is recently installed.

## Pending Tasks
- [x] **Dotfiles Setup**: Initialized modular Flake + Home Manager structure in `~/nixos-config`.
- [ ] **Config Migration**: Move user-specific configs (Zsh, programs) from `configuration.nix` to `home.nix`.
- [x] **Spotify Setup**: Installed official Spotify with Wayland support for notification testing.
- [ ] **Noctalia Experiment**: Verify the new "Niri (Noctalia)" session.
    - Status: Song notifications from Spotify pending verification. Screenshot notifications need integration.

## Transition Note
The user is switching to **Arch Linux** to compare setups. A handover document `~/nixos-config/SYNC_TO_ARCH.md` has been created to guide the Arch-side agent.


## Operational Guidelines
- **Model Usage Optimization**: Use high-capability (more expensive) models for complex planning and architectural decisions. Use more efficient (economical) models for straightforward execution and simple tasks.
- **Change Transparency**: Inform the user of all changes made. Explicitly highlight any irreversible changes (e.g., file deletions, significant configuration overwrites) before proceeding.
- **Commit Standards**: Use **Conventional Commits** for all repository changes (e.g., `feat:`, `fix:`, `chore:`, `docs:`).
- **NixOS Integration**: All system-level changes should be handled via Nix expressions and Flakes.
- **Niri Awareness**: Consider `niri`'s unique scrolling-tiling behavior for any UI or workflow suggestions.
