# Plan Finalizado: Migración a home.nix ✅

Este archivo documenta la migración exitosa de los paquetes de usuario desde `configuration.nix` a `home.nix`.
**Estado:** COMPLETADO. Todos los paquetes de usuario ahora se gestionan de forma declarativa mediante Home Manager.

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
