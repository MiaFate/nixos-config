{ pkgs, inputs, ... }:

let
  # Wrapper para Niri + Dank Shell (Por defecto)
  niri-dank = pkgs.writeShellScriptBin "niri-dank" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=niri
    export NIRI_SHELL=dank
    export XMODIFIERS=@im=fcitx
    export GTK_IM_MODULE=wayland
    export QT_IM_MODULE=fcitx
    exec niri-session
  '';

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
    niri-dank
    niri-noctalia
  ];

  # Registramos ambas sesiones en el Display Manager
  services.displayManager.sessionPackages = [
    (pkgs.runCommand "niri-dank-session" {
      passthru.providedSessions = [ "niri-dank" ];
    } ''
      mkdir -p $out/share/wayland-sessions
      cat <<EOF > $out/share/wayland-sessions/niri-dank.desktop
[Desktop Entry]
Name=DMS Shell + Niri
Comment=Niri with Dank Material Shell
Exec=${niri-dank}/bin/niri-dank
Type=Application
EOF
    '')
    (pkgs.runCommand "niri-noctalia-session" {
      passthru.providedSessions = [ "niri-noctalia" ];
    } ''
      mkdir -p $out/share/wayland-sessions
      cat <<EOF > $out/share/wayland-sessions/niri-noctalia.desktop
[Desktop Entry]
Name=NOCTALIA + Niri (Experimental)
Comment=Niri with Noctalia Shell
Exec=${niri-noctalia}/bin/niri-noctalia
Type=Application
EOF
    '')
  ];
}
