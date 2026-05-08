# Changelog - NixOS Configuration

Todos los cambios significativos, correcciones de errores y decisiones arquitectónicas se registran aquí.

## [2026-05-08] - Corrección de System Tray para Vesktop
### Fixed
- **Vesktop Tray Icon**: Se restauró el ícono del system tray inyectando `XDG_CURRENT_DESKTOP=niri:GNOME` específicamente en el servicio de autostart de Vesktop.
    - *Razón*: Al simplificar la variable global a solo `niri`, Electron perdía la capacidad de detectar el soporte de StatusNotifierItem.

## [2026-05-08] - Corrección Definitiva de Fcitx5
### Fixed
- **Fcitx5 CPU Loop (Refined)**: Se amplió la regla de ventana para ser insensible a mayúsculas/minúsculas y capturar por título además de `app-id`.
    - *Razón*: Algunos wrappers de Nix o cambios en la ventana de candidatos hacían que la regex anterior fallara intermitentemente.
- **Configuración Live**: Se vinculó manualmente `~/.config/niri` a los dotfiles locales para asegurar que los cambios sean inmediatos sin esperar a un `home-manager switch`.

## [2026-05-08] - Estabilización y Análisis Post-Instalación


### Fixed
- **Fcitx5 CPU Loop**: Se corrigió la regla de ventana en Niri (`config.kdl`) que causaba un uso del 99% de CPU.
    - *Razón*: Múltiples nodos `match` en Niri actúan como un `AND`. Se unificaron en una sola regex `^fcitx|^org\.fcitx\.Fcitx5$`.
- **GTK 4 Portal Errors**: Se eliminó la asignación explícita de `gtk4.theme` en `home.nix`.
    - *Razón*: GTK 4 usa `libadwaita` y no soporta temas externos de la misma forma que GTK 3; forzarlo causaba errores de carga en los portales.
- **XDG Consistency**: Se unificó `XDG_CURRENT_DESKTOP=niri:GNOME` en el wrapper de Noctalia y variables de sesión.

### Added
- **System Health Report**: Creación de `REPORTE_SISTEMA.md` para seguimiento de estado.
- **Critical Gotchas**: Documentación técnica de errores recurrentes en `GEMINI.md`.
- **Change Management**: Esta bitácora (`CHANGELOG.md`) para trazabilidad.

### Changed
- **Niri Config**: Optimización de reglas de ventana para Noctalia y Portales.
- **Home Manager**: Ajuste de variables de entorno para sincronización de zona horaria (`TZ`).

---

## [2026-05-08] - Corrección de Reglas de Niri y Fcitx5

### Fixed
- **Fcitx5 CPU Loop (Regresión)**: Se simplificó la regex de `app-id` en Niri a `r#"fcitx"#` para evitar que la ventana de candidatos sea capturada por el tiling, lo que causaba un loop de foco y 99% de CPU.
- **Noctalia/Quickshell Rules**: Se corrigió el error de lógica `AND` (múltiples `match`) unificando los IDs en una sola regex `OR`.
- **Estabilidad**: Verificado el uso de CPU al 0.0% tras la recarga y reinicio del servicio.

---
