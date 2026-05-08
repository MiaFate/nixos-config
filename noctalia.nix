{ pkgs, inputs, ... }:

let
  # Wrapper para Niri + Noctalia
  niri-noctalia = pkgs.writeShellScriptBin "niri-noctalia" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=niri
    export NIRI_SHELL=noctalia
    export XMODIFIERS=@im=fcitx
    export GTK_IM_MODULE=wayland
    export QT_IM_MODULE=fcitx
    exec niri-session
  '';
in
{
  # Añadimos los paquetes y wrappers al sistema
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.libnotify
    niri-noctalia
  ];

  # Registramos la sesión en el Display Manager
  services.displayManager.sessionPackages = [
    (pkgs.runCommand "niri-noctalia-session" {
      passthru.providedSessions = [ "niri-noctalia" ];
    } ''
      mkdir -p $out/share/wayland-sessions
      cat <<EOF > $out/share/wayland-sessions/niri-noctalia.desktop
[Desktop Entry]
Name=NOCTALIA + Niri
Comment=Niri with Noctalia Shell
Exec=${niri-noctalia}/bin/niri-noctalia
Type=Application
EOF
    '')
  ];
}
