# Guía de Gestión: NixOS + Flakes + Home Manager

Este documento detalla los procedimientos estándar para mantener y evolucionar este sistema.

## 1. Aplicar Cambios
Cualquier modificación en la carpeta `~/nixos-config` debe ser aplicada para que surta efecto.

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#nixos
```

## 2. Gestión de Dotfiles
Los archivos de configuración de usuario se gestionan mediante **Home Manager**.

- **Ubicación de origen:** `~/nixos-config/dotfiles/`
- **Ubicación de destino:** Enlaces simbólicos en `~/.config/` (o el home).
- **Procedimiento:** Edita el archivo en `~/nixos-config/dotfiles/` y luego ejecuta el comando de `rebuild`.

## 3. Flujo de Trabajo con Git
Seguimos el estándar de **Conventional Commits**.

1. Realizar cambios en la configuración.
2. Probar con `nixos-rebuild switch`.
3. Si funciona:
   ```bash
   git add .
   git commit -m "feat: descripción del cambio"
   git push
   ```

## 4. Mantenimiento del Sistema

### Actualizar canales y inputs
Para actualizar las versiones de los paquetes (nixpkgs, etc.):
```bash
nix flake update
sudo nixos-rebuild switch --flake .#nixos
```

### Limpieza de generaciones antiguas
Para liberar espacio en disco borrando configuraciones anteriores:
```bash
# Borrar generaciones de usuario (Home Manager)
home-manager expire-generations "-7 days"

# Borrar generaciones del sistema y recolectar basura
sudo nix-collect-garbage -d
```

## 5. Estructura del Repositorio
- `flake.nix`: Entradas y definición de hosts.
- `configuration.nix`: Configuración de hardware, drivers y servicios globales.
- `home.nix`: Paquetes de usuario y configuración de aplicaciones (Dotfiles).
- `dotfiles/`: Archivos fuente de configuración (niri, kitty, etc.).
- `GEMINI.md`: Instrucciones para la IA.
