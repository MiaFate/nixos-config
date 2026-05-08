# System Context

This workspace is running on **NixOS**.

## Environment Details
- **Nix Flakes**: The system uses Nix Flakes for configuration management.
- **Window Manager**: **niri** (a scrollable-tiling Wayland compositor).
- **Shell**: **Noctalia** (primary shell bar/notifications, DMS removed).
- **Status**: The system is recently installed.

## Pending Tasks
- [x] **Dotfiles Setup**: Initialized modular Flake + Home Manager structure in `~/nixos-config`.
- [ ] **Config Migration**: Move user-specific configs (Zsh, programs) from `configuration.nix` to `home.nix`.
- [x] **Spotify Setup**: Installed official Spotify with Wayland support for notification testing.
- [x] **Noctalia Setup**: Noctalia is the primary shell. DMS has been removed.
    - Status: Song notifications from Spotify pending verification. Screenshot notifications need integration.
- [x] **System Health Check**: Review and execute improvements from [REPORTE_SISTEMA.md](file:///home/mia/nixos-config/REPORTE_SISTEMA.md).

## Transition Note
The user is switching to **Arch Linux** to compare setups. A handover document `~/nixos-config/SYNC_TO_ARCH.md` has been created to guide the Arch-side agent.


## Operational Guidelines
- **Model Usage Optimization**: Use high-capability (more expensive) models for complex planning and architectural decisions. Use more efficient (economical) models for straightforward execution and simple tasks.
- **Change Transparency**: Inform the user of all changes made. Explicitly highlight any irreversible changes (e.g., file deletions, significant configuration overwrites) before proceeding.
- **Commit Standards**: Use **Conventional Commits** for all repository changes (e.g., `feat:`, `fix:`, `chore:`, `docs:`).
- **NixOS Integration**: All system-level changes should be handled via Nix expressions and Flakes.
- **Niri Awareness**: Consider `niri`'s unique scrolling-tiling behavior for any UI or workflow suggestions.
- **Change Management**: Maintain a `CHANGELOG.md` at the root of the repository. Every significant fix, refactor, or feature addition MUST be documented there with the date, the change made, and the rationale/lessons learned.
## Critical Gotchas & Knowledge Base
- **Fcitx5 CPU Loop (Niri)**: Fcitx5 candidate windows MUST be floating and MUST NOT take focus (`open-floating true`, `open-focused false`). 
    - **IMPORTANT**: In Niri `window-rule` blocks, multiple `match` nodes act as an **AND** condition. DO NOT separate `app-id` matches into multiple lines if you want an **OR** behavior; use a single regex instead.
    - **RECOMENDACIÓN**: Usar `match app-id=r#"fcitx"#` para ser lo más inclusivo posible y evitar problemas con mayúsculas/minúsculas o nombres de procesos envueltos (Nix). Si la regla falla, el sistema entrará en un loop de foco al 100% de CPU.
- **GTK 4 Theming**: Do not set `gtk4.theme` in Home Manager when using `Adwaita-dark`. GTK 4 uses libadwaita and setting a theme path explicitly causes portal errors. Use `dconf` to set `color-scheme = "prefer-dark"`.
