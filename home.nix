# Dummy comment to force rebuild
{ config, pkgs, inputs, ... }:

{
  home.username = "mia";
  home.homeDirectory = "/home/mia";

  # Forzar zona horaria en la sesión de usuario (corrige el reloj de hyprlock)
  home.sessionVariables = {
    TZ = "America/Argentina/Buenos_Aires";
  };
  systemd.user.sessionVariables = {
    TZ = "America/Argentina/Buenos_Aires";
  };

  imports = [
    ./neovim.nix
  ];

  # Enlaces a archivos de configuración (symlink editable)
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
    (antigravity.override { commandLineArgs = "--password-store=gnome-libsecret"; })
    playerctl
    hyprpicker
    eyedropper
    grim
    slurp
    imagemagick
    swappy
    grimblast
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
    gtk4.theme = null;
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
          timeout = 300;          # 5 min → bloquear pantalla
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1800;         # 30 min → suspender sistema
          on-timeout = "systemctl suspend";
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
    shellAliases = {
      cdi = "zi";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
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
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.9";
      dynamic_background_opacity = "yes";
      confirm_os_window_close = 0;
      cursor_trail = 1;
      enable_audio_bell = "no";
      window_padding_width = 10;
      
      # Integración y Control
      shell_integration = "enabled";
      allow_remote_control = "yes";

      # Tipografía y Ligaduras
      disable_ligatures = "never";

      # Layouts
      enabled_layouts = "splits,stack";
      
      # Rendimiento (Optimizado para NVIDIA/Wayland)
      repaint_delay = 8;
      input_delay = 2;
      sync_to_monitor = "yes";

      # Estética de Pestañas (Premium)
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
    };
    keybindings = {
      "ctrl+shift+enter" = "launch --location=vsplit --cwd=current";
      "ctrl+shift+backspace" = "launch --location=hsplit --cwd=current";
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+down" = "neighboring_window down";
      "ctrl+shift+t" = "new_tab_with_cwd";
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
      ExecStart = "${pkgs.vesktop}/bin/vesktop";
      Environment = "XDG_CURRENT_DESKTOP=niri:GNOME";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override { commandLineArgs = "--password-store=gnome-libsecret"; };
    profiles.default.userSettings = {
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'SF Pro Display', monospace";
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
      "editor.fontLigatures" = true;
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
