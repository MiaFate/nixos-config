# Dummy comment to force rebuild
{ config, pkgs, inputs, ... }:

{
  home.username = "mia";
  home.homeDirectory = "/home/mia";

  imports = [
    ./neovim.nix
  ];

  # Enlaces a archivos de configuración (Editables para DMS)
  xdg.configFile = {
    "niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/niri";
  };

  home.file = {
    "GEMINI.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/GEMINI.md";
  };

  # Paquetes de usuario
  home.packages = with pkgs; [
    gnome-themes-extra
    adwaita-qt
    bibata-cursors
    nerd-fonts.jetbrains-mono
    # vim # Gestionado por programs.neovim
    # neovim # Gestionado por programs.neovim
    alacritty
    fuzzel
    vesktop
    spotify
    google-chrome
    kdePackages.dolphin
    obs-studio
    mpv
    qt6Packages.fcitx5-configtool
    inputs.zen-browser.packages."x86_64-linux".default
    (vscode.override { commandLineArgs = "--password-store=gnome-libsecret"; })
    (antigravity.override { commandLineArgs = "--password-store=gnome-libsecret"; })
  ];

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Configuración de GTK y Modo Oscuro
  gtk = {
    enable = true;
    font = {
      name = "SF Pro Display";
      size = 12;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.theme = config.gtk.theme;
  };

  # Bloqueo de pantalla y gestión de inactividad
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
    settings = {
      general = {
        disable_loading = true;
        grace = 0;
        hide_cursor = true;
      };
      background = [
        {
          path = "/home/mia/Pictures/Wallpapers/Anime-Girl-Night-Sky.jpg";
          blur_passes = 3;
          blur_size = 7;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          outer_color = "rgb(127, 91, 204)";
          inner_color = "rgb(30, 30, 46)";
          font_color = "rgb(205, 214, 244)";
          fade_on_empty = true;
          placeholder_text = "<i>Contraseña...</i>";
          hide_input = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          text = "$TIME";
          color = "rgb(205, 214, 244)";
          font_size = 64;
          font_family = "SF Pro Display Bold";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # Configuración de Zsh vía Home Manager
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
      custom = "$HOME/.oh-my-zsh/custom";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableTransience = true;
    settings = builtins.fromTOML (builtins.readFile ./dotfiles/starship.toml);
  };

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "MesloLGS NF";
      size = 12;
    };
    settings = {
      background_opacity = "0.9";
      dynamic_background_opacity = "yes";
      confirm_os_window_close = 0;
      cursor_trail = 1;
      enable_audio_bell = "no";
      window_padding_width = 4;
    };
  };

  # Autoinicio de Vesktop vía Systemd (Home Manager)
  systemd.user.services.vesktop-autostart = {
    Unit = {
      Description = "Vesktop Autostart (Declarative)";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.vesktop}/bin/vesktop --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
