{ pkgs, inputs, ... }:

let
  # Wrapper para Niri + Dank Shell (Por defecto)
  niri-dank = pkgs.writeShellScriptBin "niri-dank" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=niri
    export NIRI_SHELL=dank
    exec niri
  '';

  # Wrapper para Niri + Noctalia
  niri-noctalia = pkgs.writeShellScriptBin "niri-noctalia" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=niri
    export NIRI_SHELL=noctalia
    exec niri
  '';
in
{
  # Añadimos los paquetes y wrappers al sistema
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.system}.default
    niri-dank
    niri-noctalia
  ];

  # Registramos ambas sesiones en el Display Manager
  services.displayManager.sessionPackages = [
    (pkgs.writeTextFile {
      name = "niri-dank-session";
      destination = "/share/wayland-sessions/niri-dank.desktop";
      content = ''
        [Desktop Entry]
        Name=Niri (Dank)
        Comment=Niri with Dank Material Shell
        Exec=${niri-dank}/bin/niri-dank
        Type=Application
      '';
    })
    (pkgs.writeTextFile {
      name = "niri-noctalia-session";
      destination = "/share/wayland-sessions/niri-noctalia.desktop";
      content = ''
        [Desktop Entry]
        Name=Niri (Noctalia)
        Comment=Niri with Noctalia Shell
        Exec=${niri-noctalia}/bin/niri-noctalia
        Type=Application
      '';
    })
  ];
}
