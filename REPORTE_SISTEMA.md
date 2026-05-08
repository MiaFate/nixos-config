# Reporte de Análisis del Sistema (Post-Reinicio 2026-05-08)

Este reporte evalúa el estado del sistema tras los últimos cambios y el reinicio solicitado por el usuario.

## 1. Mejoras Confirmadas ✅

- **NVMe Stability**: El parámetro `nvme_core.default_ps_max_latency_us=0` está activo en el kernel. No se detectan errores de timeout en el NVMe.
- **Sincronización de Tiempo**: La variable `TZ` ha sido inyectada correctamente en la sesión de usuario y en systemd (`America/Argentina/Buenos_Aires`). Esto debería haber corregido el desfase en el lock screen.
- **Unidades de Systemd**: **0 unidades fallidas**. Todos los servicios críticos (Pipewire, Niri, Noctalia) están operando normalmente.
- **XDG Current Desktop**: Se ha logrado mayor consistencia con el valor `niri:GNOME`, permitiendo que los portales funcionen correctamente.

## 2. Problemas Persistentes ⚠️

### [WARN] Error de Tema en Portales (GTK 4)
- **Error**: `xdg-desktop-portal-gnome` reporta fallos al intentar cargar `Adwaita-dark/gtk-4.0/gtk.css`.
- **Causa**: Se está forzando un nombre de tema específico para GTK 4 que no existe en el sistema de archivos (GTK 4 usa `libadwaita` de forma interna).
- **Solución**: Dejar que GTK 4 use el tema por defecto y se guíe por la preferencia de modo oscuro de dconf.

### [WARN] Ruido en DBus (Duplicados)
- Continúan los avisos de `Ignoring duplicate name` para servicios como `org.freedesktop.portal.Desktop`.
- **Análisis**: Es una consecuencia de tener múltiples implementaciones de portales habilitadas. Aunque no es crítico, se puede mitigar limpiando la lista de paquetes del sistema.

## 3. Discrepancias de Configuración 🔍

- **Noctalia Wrapper**: El script `niri-noctalia` en `noctalia.nix` todavía exporta `XDG_CURRENT_DESKTOP=niri` de forma literal, lo cual contradice la configuración general de `niri:GNOME`.

---

## Plan de Acción Recomendado

1. **Unificar XDG_CURRENT_DESKTOP**: Cambiar el valor en `noctalia.nix` a `niri:GNOME`.
2. **Corregir GTK 4**: Eliminar la asignación explícita de `gtk4.theme` en `home.nix`.
3. **Limpieza de Paquetes**: Eliminar `gnome-themes-extra` de `configuration.nix` si ya está en `home.nix` (o viceversa), asegurando que solo esté donde es necesario.

*Reporte generado tras el reinicio del sistema.*
