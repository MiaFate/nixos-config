# Changelog - NixOS Configuration

Todos los cambios significativos, correcciones de errores y decisiones arquitectónicas se registran aquí.

## [2026-05-12] - Steam Regression Troubleshooting
### Removed
- **Troubleshooting**: Temporarily removed `lib` argument and `blueman-applet` service override from `configuration.nix` to verify if they are causing Steam crashes on Niri.
- **Isolation**: Pushed these changes to `fix/steam` branch and saved the original code in `stash@{0}` for quick restoration.

## [2026-05-10] - System Optimization and Fixes
### Fixed
- **Blueman Applet**: Fixed the `blueman-applet.service` error ("bad-setting") by overriding the multiple `ExecStart` entries using `lib.mkForce`.
- **Zsh Configuration**: Removed redundant `z` plugin from Oh My Zsh as it was conflicting with `zoxide`.

### Added
- **Optimization**: Enabled `nix.settings.auto-optimise-store = true` to save disk space through hardlinking.
- **Interactive Search**: Enabled `fzf` and integrated it with Zsh to support `zoxide`'s interactive mode (`zi`), restoring the `cdi` alias functionality.
- **File Management**: Set Thunar as the global default file manager via `xdg.mimeApps` to ensure consistent behavior across browsers and applications.
- **Visuals**: Implemented a refined macOS-inspired aesthetic using `WhiteSur-Dark-Purple` for GTK and `Colloid-Purple-Dark` for icons, aligning with the Catppuccin Lavender color scheme.

### Removed
- **Redundancy**: Removed Dolphin to reduce D-Bus service duplication and KDE dependency footprint, as Thunar is now correctly configured as the system-wide default.

### Changed
- **Zsh Hygiene**: Verified that `initContent` is the new standard for Zsh in NixOS 25.11 (unstable) and retained it after a temporary investigation.

## [2026-05-10] - Premium Fastfetch Integration
### Added
- **Fastfetch Customization**: Integrated a high-end system dashboard with a custom multicolor NixOS logo.
    - **Logo**: Uses premium Nerd Font glyphs (``, ``, etc.) for smooth diagonal edges and a stylized Reddit-sourced design.
    - **Palette**: Implemented a 6-color pastel palette (Pink, Peach, Green, Teal, Blue, Purple) via hex codes.
    - **Layout**: Personalized module list to show core system info, hardware, and uptime while excluding the local IP for privacy.
    - **Automation**: Enabled autostart in Zsh via `initContent` (fixing deprecation warnings for `initExtra`).
- **Tools**: Added `chafa` to user packages for improved terminal image and graphics rendering support.

## [2026-05-10] - Gaming Stability and Audio Fixes
### Fixed
- **THPS 1+2 Freezing**: Identified that the Focusrite Scarlett's 18 channels were causing an infinite loop in GStreamer/Proton. Created a permanent Virtual Stereo Sink in `configuration.nix` to mitigate this.
- **Niri Window Rules**: Added (and temporarily commented) rules for Steam and games to handle maximization and floating states on Wayland/Niri.
- **DXVK Configuration**: Investigated and implemented `dxvk.conf` tweaks for NVIDIA/Wayland memory management (later removed as the audio fix was the primary cause).

### Added
- **Documentation**: Created [GAMING_AUDIO_FIX.md](file:///home/mia/nixos-config/GAMING_AUDIO_FIX.md) as a quick reference for the `PULSE_SINK` workaround.

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
