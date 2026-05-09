# Changelog - NixOS Configuration

Todos los cambios significativos, correcciones de errores y decisiones arquitectónicas se registran aquí.

## [2026-05-09] - System Analysis and Optimization
### Fixed
- **Niri Config**: Updated screen lock shortcut (`Super+Alt+L`) to use `hyprlock` instead of `swaylock`, ensuring compatibility with the current system setup.
- **Home Manager**: Removed redundant `nerd-fonts.jetbrains-mono` declaration in `home.nix` (already provided in `configuration.nix`).
- **Configuration**: Standardized indentation in `configuration.nix` (tabs to spaces) for better maintainability.
- **UI**: Increased default font sizes by 1 point (GTK: 13, Kitty: 13, VSCode: 15) for better readability.
- **UI**: Reverted font size changes back to defaults (GTK: 12, Kitty: 12, VSCode: default) as requested.
- **Hardware**: Enabled Bluetooth support and added Blueman manager for device control.
- **Networking**: Enabled `systemd-resolved` to address slow Steam download speeds.

### Changed
- **Refactor**: Formally marked the user package migration to Home Manager as completed in `PENDING_REFACTOR.md`.

## [2026-05-09] - Fix Gaming and Steam Startup
### Fixed
- **Steam/X11**: Added `xwayland` and `xwayland-satellite` to system packages to enable X11 application support on Niri.
- **Environment**: Updated Niri configuration to propagate `DISPLAY` environment variable via D-Bus, fixing Steam startup issues.
- **GameMode**: Verified `gamemoded` is operational (reported as "inactive" when no game is active, which is expected).
- **Niri Config**: Fixed syntax error by removing invalid `xwayland` node and restored animation speed (`slowdown 1.0`).
- **Environment**: Unified `XDG_CURRENT_DESKTOP` to `niri:GNOME` across system and user configurations.

## [2026-05-08] - Migración Completa a NixVim Modular
### Added
- **NixVim Framework**: Migración de toda la configuración de Neovim a NixVim.
    - **Estructura**: Organización modular en la carpeta `nixvim/`, separando opciones, atajos de teclado, temas y plugins (LSP, UI, CMP, etc.).
    - **Mantenibilidad**: Ahora todos los plugins y LSPs se gestionan declarativamente a través de Nix, eliminando la necesidad de bloques gigantes de Lua manual.
- **Zoxide Integration**: Se habilitó `zoxide` con la opción `--cmd cd`.

### Changed
- **Starship Layout**: Reposicionamiento del reloj en el prompt a la primera línea mediante el módulo `$fill`.
- **Limpieza de Sistema**: Eliminación definitiva de archivos legacy de Oh My Zsh y Powerlevel10k.

## [2026-05-08] - Mejora de Fuentes y Configuración Declarativa de VSCode
### Added
- **Configuración Declarativa de VSCode**: Gestión de fuentes y ligaduras vía Nix.
- **Fontconfig Global**: Fuentes predeterminadas establecidas en `configuration.nix`.

## [2026-05-08] - Corrección de System Tray para Vesktop
### Fixed
- **Vesktop Tray Icon**: Restauración del ícono inyectando la variable de entorno correcta.

## [2026-05-08] - Integración de Copilot en CMP
### Added
- **Copilot-CMP**: Integración de las sugerencias de Copilot directamente en el menú de autocompletado (`cmp`).

### Changed
- **Copilot-Lua**: Se desactivaron las sugerencias nativas (`suggestion.enabled = false`) para evitar colisiones visuales con el menú de `cmp`.

---
