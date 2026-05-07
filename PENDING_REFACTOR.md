# Plan Pendiente: Migración a home.nix

Este archivo contiene las instrucciones para migrar los paquetes de usuario desde `configuration.nix` a `home.nix` (arquitectura de Home Manager). 
**Nota para Gemini / Agente IA:** Cuando la usuaria solicite ejecutar este refactor, lee este archivo y aplica los cambios.

## Cambios a realizar en `configuration.nix`
**Eliminar** los siguientes paquetes de la lista `environment.systemPackages`:
- `vim`
- `neovim`
- `kitty` (ya está en home.nix)
- `alacritty`
- `fuzzel`
- `inputs.zen-browser.packages."x86_64-linux".default`
- `vesktop`
- `bibata-cursors` (ya está en home.nix)
- `qt6Packages.fcitx5-configtool`
- `spotify`
- `google-chrome`
- `kdePackages.dolphin`
- `(vscode.override { commandLineArgs = "--password-store=gnome"; })`
- `(antigravity.override { commandLineArgs = "--password-store=gnome"; })`
- `obs-studio`
- `mpv`

## Cambios a realizar en `home.nix`
**Agregar** los siguientes paquetes a la lista `home.packages`:
- `vim`
- `neovim`
- `alacritty`
- `fuzzel`
- `vesktop`
- `spotify`
- `google-chrome`
- `kdePackages.dolphin`
- `obs-studio`
- `mpv`
- `qt6Packages.fcitx5-configtool`
- `inputs.zen-browser.packages."x86_64-linux".default`
- `(pkgs.vscode.override { commandLineArgs = "--password-store=gnome"; })`
- `(pkgs.antigravity.override { commandLineArgs = "--password-store=gnome"; })`

*(No agregar `kitty` ni `bibata-cursors` ya que ya están declarados o configurados).*
