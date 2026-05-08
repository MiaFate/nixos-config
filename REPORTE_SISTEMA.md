# Reporte de Análisis del Sistema (Final - 2026-05-08)

Este reporte confirma el estado óptimo del sistema tras la implementación de las mejoras recomendadas.

## 1. Estado General del Sistema ✅

- **NVMe Stability**: Confirmado. El parámetro `nvme_core.default_ps_max_latency_us=0` está activo y no hay errores de timeout en el journal.
- **Sincronización de Tiempo**: Confirmado. La variable `TZ` está correctamente inyectada en la sesión (`America/Argentina/Buenos_Aires`). El comando `date` muestra la hora local correcta.
- **Unidades de Systemd**: **0 unidades fallidas**. Tanto a nivel de sistema como de usuario.
- **Consistencia de Entorno**: `XDG_CURRENT_DESKTOP` está unificado en `niri:GNOME` tanto en el wrapper de Noctalia como en la configuración global.

## 2. Resolución de Problemas Anteriores 🛠️

- **[FIXED] Error de Tema en Portales (GTK 4)**: 
    - Se eliminó la asignación de tema explícita en GTK 4 (`gtk4.theme = null`).
    - **Verificación**: No se detectan errores de "Theme parser error" en el journal del boot actual. Los portales ahora usan el modo oscuro vía dconf sin fallos.
- **[CLEAN] Paquetes Duplicados**:
    - Se verificó que `gnome-themes-extra` solo reside en la configuración de usuario (`home.nix`).
    - **Resultado**: Configuración más limpia y modular.

## 3. Observaciones Menores 🔍

- **Ruido en DBus**: Persisten algunos avisos de `Ignoring duplicate name`. 
    - **Análisis**: Es un comportamiento esperado en entornos con múltiples portales (GNOME + GTK) y servicios de integración (Keyring, Tumbler). No afecta al rendimiento ni a la estabilidad.
- **Espacio en Disco**: El sistema utiliza solo el 5% de `/dev/sda2` (35G usados de 879G).
- **Integridad**: El Nix Store se encuentra en buen estado.

---

## 4. Lecciones Aprendidas (Knowledge Base) 💡

- **Fcitx5 vs Niri**: El bug del 100% de CPU ocurre cuando la ventana de candidatos de fcitx5 intenta ser gestionada por el tiling de Niri.
    - **Fix permanente**: La regla de ventana debe usar un único `match` con regex para el App ID. Si se usan múltiples líneas de `match`, Niri las interpreta como un `AND` lógico, lo que causa que la regla falle y el sistema entre en un bucle de foco infinito.


## Conclusión

El sistema se encuentra en un estado **estable y optimizado**. Se han cerrado todas las discrepancias de configuración identificadas previamente. El entorno está listo para el flujo de trabajo diario o para proceder con la transición a Arch Linux si se desea comparar.

*Reporte final generado por Antigravity.*
