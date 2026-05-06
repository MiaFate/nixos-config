# System Context

This workspace is running on **NixOS**.

## Environment Details
- **Nix Flakes**: The system uses Nix Flakes for configuration management.
- **Window Manager**: **niri** (a scrollable-tiling Wayland compositor).
- **Status**: The system is recently installed.

## Pending Tasks
- [ ] **Dotfiles Setup**: Research and implement a method for managing dotfiles (e.g., using Home Manager within Flakes, or a separate tool).
- [ ] **Config Migration**: Identify which configurations from the legacy `~/nixos_dotfiles` folder (from a previous install) should be migrated or adapted.

## Operational Guidelines
- **Model Usage Optimization**: Use high-capability (more expensive) models for complex planning and architectural decisions. Use more efficient (economical) models for straightforward execution and simple tasks.
- **Change Transparency**: Inform the user of all changes made. Explicitly highlight any irreversible changes (e.g., file deletions, significant configuration overwrites) before proceeding.
- **Commit Standards**: Use **Conventional Commits** for all repository changes (e.g., `feat:`, `fix:`, `chore:`, `docs:`).
- **NixOS Integration**: All system-level changes should be handled via Nix expressions and Flakes.
- **Niri Awareness**: Consider `niri`'s unique scrolling-tiling behavior for any UI or workflow suggestions.
