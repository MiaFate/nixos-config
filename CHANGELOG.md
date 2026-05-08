# Changelog - NixOS Configuration

Todos los cambios significativos, correcciones de errores y decisiones arquitectónicas se registran aquí.

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
