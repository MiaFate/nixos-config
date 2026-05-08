# Changelog - NixOS Configuration

Todos los cambios significativos, correcciones de errores y decisiones arquitectónicas se registran aquí.

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

---
