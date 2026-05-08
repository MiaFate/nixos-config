# Changelog - NixOS Configuration

Todos los cambios significativos, correcciones de errores y decisiones arquitectónicas se registran aquí.

## [2026-05-08] - Optimización de Prompt y Navegación Inteligente
### Added
- **Zoxide Integration**: Se habilitó `zoxide` con la opción `--cmd cd`. Esto permite usar `cd` con búsqueda inteligente de directorios ("frecency") manteniendo la compatibilidad con el comportamiento estándar de `cd` (como volver al home sin argumentos).
- **Configuración Declarativa de VSCode**: Se movió la configuración de VSCode a `programs.vscode` en `home.nix`.

### Changed
- **Starship Layout**: Reposicionamiento del reloj en el prompt. Ahora aparece en la primera línea a la derecha mediante el módulo `$fill`, mejorando la legibilidad y el espacio en la línea de comando.
- **Limpieza de Zsh**: Se eliminaron los restos de Powerlevel10k (`p10k.zsh`) y la carpeta manual `~/.oh-my-zsh`, consolidando una configuración 100% declarativa y minimalista.
- **Fontconfig Global**: Fuentes predeterminadas (JetBrainsMono y SF Pro) establecidas en `configuration.nix`.

## [2026-05-08] - Corrección de System Tray para Vesktop
### Fixed
- **Vesktop Tray Icon**: Se restauró el ícono del system tray inyectando `XDG_CURRENT_DESKTOP=niri:GNOME` específicamente en el servicio de autostart de Vesktop.

## [2026-05-08] - Corrección Definitiva de Fcitx5
### Fixed
- **Fcitx5 CPU Loop (Refined)**: Se amplió la regla de ventana para ser insensible a mayúsculas/minúsculas y capturar por título además de `app-id`.
- **Configuración Live**: Se vinculó manualmente `~/.config/niri` a los dotfiles locales para asegurar que los cambios sean inmediatos.

## [2026-05-08] - Estabilización y Análisis Post-Instalación

### Fixed
- **Fcitx5 CPU Loop**: Se corrigió la regla de ventana en Niri que causaba un uso del 99% de CPU.
- **GTK 4 Portal Errors**: Se eliminó la asignación explícita de `gtk4.theme`.
- **XDG Consistency**: Se unificó `XDG_CURRENT_DESKTOP=niri:GNOME`.

---
