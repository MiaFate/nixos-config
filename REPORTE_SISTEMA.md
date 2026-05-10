# Reporte de Análisis del Sistema (Actualizado - 2026-05-10)

Este reporte confirma el estado del sistema y las mejoras aplicadas tras el análisis exhaustivo de hoy.

## Hallazgos Recientes y Mejoras ✅

- **[FIXED] Blueman Applet**: El servicio de usuario fallaba por tener múltiples `ExecStart`. Se aplicó un override con `lib.mkForce` para limpiar la lista y asegurar que cargue correctamente.
- **[CLEAN] Redundancia de Zsh**: Se eliminó el plugin `z` de Oh My Zsh. Al usar `zoxide` (vía `programs.zoxide.enableZshIntegration`), el plugin nativo de OMZ era redundante y podía causar lentitud o conflictos menores.
- **[OPTIMIZED] Nix Store**: Se habilitó `auto-optimise-store`. Esto optimizará el almacenamiento de forma continua al crear enlaces duros entre archivos idénticos en el store.
- **[VERIFIED] Zsh initContent**: Se verificó que `initContent` es la opción recomendada en las versiones más recientes de NixOS/Home Manager para evitar advertencias de depreciación sobre `initExtra`.

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

## 3. Observations Menores 🔍

- **Ruido en DBus**: Persisten algunos avisos de `Ignoring duplicate name`. 
    - **Análisis**: Es un comportamiento esperado en entornos con múltiples portales (GNOME + GTK) y servicios de integración (Keyring, Tumbler). No afecta al rendimiento ni a la estabilidad.
- **Espacio en Disco**: El sistema utiliza solo el 5% de `/dev/sda2` (35G usados de 879G).
- **Integridad**: El Nix Store se encuentra en buen estado.

---

## 4. Lecciones Aprendidas (Knowledge Base) 💡

- **Fcitx5 vs Niri**: El bug del 100% de CPU ocurre cuando la ventana de candidatos de fcitx5 intenta ser gestionada por el tiling de Niri.
    - **Fix permanente**: La regla de ventana debe usar un único `match` con regex para el App ID. Si se usan múltiples líneas de `match`, Niri las interpreta como un `AND` lógico, lo que causa que la regla falle y el sistema entre en un bucle de foco infinito.
- **Notificaciones de Noctalia**: Los cambios de canción y capturas de pantalla se manejan como "Media Toasts", lo que significa que son notificaciones efímeras que no se guardan en el historial por diseño, evitando saturarlo.


## Conclusión

El sistema se encuentra en un estado **estable, optimizado y verificado**. Se han cerrado todas las discrepancias de configuración identificadas y las funcionalidades de shell (Noctalia) están operando según lo esperado por el usuario.

*Reporte final actualizado por Antigravity.*
