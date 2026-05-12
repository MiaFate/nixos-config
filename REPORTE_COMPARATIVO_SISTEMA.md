# Reporte Exhaustivo de Análisis y Comparativa (2026-05-12)

Este documento detalla el estado técnico del sistema tras la implementación del stack de Rust y el entorno MangoWC, comparándolo con la configuración base de Niri.

## 1. Auditoría de Errores y Warnings ✅

| Área | Estado | Observaciones |
| :--- | :--- | :--- |
| **Systemd (System)** | Limpio (0 fallos) | Todas las unidades cargadas correctamente. |
| **Systemd (User)** | Limpio (0 fallos) | El conflicto de `blueman-applet` fue resuelto desactivando la unidad y usando el spawn del compositor. |
| **Journal (Logs)** | Estable | Advertencias de duplicidad en `dbus-broker` para `org.freedesktop.secrets`. Es un comportamiento esperado por la coexistencia de GNOME Keyring y servicios de portal. |
| **Waybar CSS** | **Corregido** | Se eliminaron 83 errores de sintaxis causados por propiedades no soportadas por GTK 3 (`transform`, `cubic-bezier` complejo). |
| **Flickering** | **Mitigado** | Resuelto mediante `WLR_DRM_NO_DIRECT_SCANOUT` en Mango y flags de GPU específicos para Antigravity y VS Code. |

## 2. Comparativa de Entornos: MangoWC vs Niri

### MangoWC (dwl-based)
- **Filosofía**: Tiling dinámico tradicional (estilo dwm/dwl). Muy ligero y centrado en el rendimiento.
- **Shell**: Dependiente de Waybar (externo). Diseño más modular.
- **Gaming**: Excelente. Al ser más simple, suele tener menos overhead en juegos pesados.
- **Estabilidad**: Alta, pero requiere `WLR_DRM_NO_DIRECT_SCANOUT=1` para NVIDIA para evitar parpadeos en apps Electron.

### Niri + Noctalia
- **Filosofía**: Tiling scrolleable (infinito horizontal). Flujo de trabajo único y moderno.
- **Shell**: Noctalia (integrado). Proporciona "Media Toasts" y notificaciones estéticamente superiores.
- **Experiencia**: Se siente más "premium" y cohesivo de fábrica.
- **Gestión de Ventanas**: Más intuitiva para multitarea masiva gracias al scroll horizontal.

## 3. Oportunidades de Mejora (Roadmap) 🚀

### A corto plazo
- [ ] **Sincronización Estética**: Ajustar los colores de Waybar para que coincidan exactamente con los "Media Toasts" de Noctalia.
- [ ] **Atajos de Teclado**: Unificar los binds de volumen/brillo entre `config.kdl` (Niri) y `config.conf` (Mango) para consistencia muscular.
- [ ] **LSP Tuning**: Algunos LSPs en `devel.nix` (como `jdt-language-server`) son pesados; se recomienda activarlos solo por proyecto.

### A largo plazo
- [ ] **Migración a Arch**: Como se menciona en `SYNC_TO_ARCH.md`, mantener esta paridad de configuraciones facilitará el salto sin perder productividad.
- [ ] **Optimización de NVIDIA**: Monitorear la estabilidad de los drivers 595.x con Explicit Sync, ya que podrían permitir desactivar los workarounds de flickering en el futuro.

---
*Reporte generado por Antigravity - Estado del Sistema: **ÓPTIMO***
