# ❄️ Instrucciones de Sincronización: De Arch Linux a NixOS

Este documento contiene las directivas técnicas para que el agente de NixOS replique la funcionalidad y estética del sistema Arch.

## 1. Teclado Dual (Inglés e Hiragana/Mozc)
En Arch usamos `fcitx5` con el motor `mozc`. El atajo para alternar entre idiomas es `Ctrl + Space`.

### Configuración en NixOS (`configuration.nix`):
```nix
i18n.inputMethod = {
  enabled = "fcitx5";
  fcitx5.addons = with pkgs; [
    fcitx5-mozc
    fcitx5-gtk
  ];
};

# Variables de entorno necesarias para Wayland/Niri
environment.variables = {
  GTK_IM_MODULE = "fcitx";
  QT_IM_MODULE = "fcitx";
  XMODIFIERS = "@im=fcitx";
};
```

**Nota para el Agente:** 
1. El atajo por defecto de Fcitx5 es `Ctrl + Space`. Asegúrate de que no haya conflictos con los atajos de `niri`.
2. Para que el layout sea "US International", el primer elemento en la lista de métodos de entrada debe ser `keyboard-us` y el segundo `mozc`.

---

## 2. Gestión de Sesión e Inactividad (Bloqueo Estético)
En Arch usamos `hypridle` para el tiempo de espera y `hyprlock` para la interfaz de bloqueo.

### Configuración en NixOS (vía Home Manager):
1. **Hyprlock**: Copiar el diseño de `~/.config/hypr/hyprlock.conf` de Arch. Usa `JetBrainsMono Nerd Font` y un fondo con blur.
2. **Hypridle**: Configurar para que ejecute `hyprlock` tras 5 minutos de inactividad.

```nix
# home.nix
services.hypridle = {
  enable = true;
  settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
    };
    listener = [
      {
        timeout = 300;
        on-timeout = "loginctl lock-session";
      }
    ];
  };
};

programs.hyprlock = {
  enable = true;
  # Aquí se debe replicar el estilo de Arch (labels, input-field, etc.)
};
```

---

## 3. SDDM Fachero (Login Screen)
Arch está usando el tema `simple_sddm_2`.

### Implementación en NixOS:
Debes buscar un paquete de tema similar o usar uno como `sddm-sugar-candy-nix` o `catppuccin-sddm`.

```nix
# configuration.nix
services.displayManager.sddm = {
  enable = true;
  theme = "nombre-del-tema";
  wayland.enable = true;
};
```

**Directiva para el Agente:** Asegúrate de que las fuentes (JetBrainsMono, SF Pro) estén instaladas en el sistema para que SDDM las renderice correctamente.

## 4. Noctalia Launcher (Centrado)
Para que el lanzador de Noctalia se vea en el medio de la pantalla (tanto con el icono como con `Mod+Space`).

### Configuración en `~/.config/noctalia/settings.json`:
El agente debe asegurarse de que la sección `appLauncher` tenga el parámetro `position` en `center`:

```json
{
  "appLauncher": {
    "position": "center",
    "overviewLayer": true,
    "viewMode": "list"
  }
}
```

**Nota para el Agente:** 
1. Si se usa `niri`, el atajo `Mod+Space` debe estar bindeado a `noctalia-launcher` (o el comando correspondiente de Noctalia para abrir el buscador).
2. Verifica que el widget `Launcher` en la barra no tenga un override de posición.

## 5. Automontado de Discos (Thunar/Gvfs)
Para que Thunar pueda ver y montar discos externos u otras particiones automáticamente como en Arch.

### Configuración en NixOS (`configuration.nix`):
Es necesario habilitar los servicios de `gvfs` (para el backend de archivos) y `udisks2` (para el manejo de discos).

```nix
# configuration.nix
services.gvfs.enable = true; # Soporte para montaje de archivos, MTP, Trash, etc.
services.udisks2.enable = true; # El motor que permite montar discos sin ser root
boot.supportedFilesystems = [ "ntfs" "exfat" "ext4" "btrfs" ]; # Asegúrate de tener soporte para tus discos

# Opcional: Si quieres que Thunar tenga miniaturas y extras
programs.thunar = {
  enable = true;
  plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
};
```

**Nota para el Agente:**
1. Asegúrate de que el usuario esté en el grupo `wheel` (o `storage` si existe) para permisos de montaje.
2. Si se usa un entorno Wayland puro, `gvfs` es esencial para que la barra lateral de Thunar muestre los dispositivos.

## 6. Estética de la Terminal (Kitty)
El usuario prefiere mantener un tema estático y consistente en la terminal en lugar de colores dinámicos.

### Configuración:
- **Tema**: Catppuccin Mocha.
- **Nota para el Agente**: En NixOS, puedes usar `programs.kitty.theme = "Catppuccin-Mocha";` si usas Home Manager, o simplemente asegurar que el archivo `current-theme.conf` tenga los colores de Catppuccin Mocha para mantener la consistencia visual que el usuario tiene en Arch.

---
*Documento generado por el Agente de Arch para el Agente de NixOS. 🌸*
