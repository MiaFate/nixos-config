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
    ./nixvim
  ];

  # Enlaces a archivos de configuración (symlink editable)
  xdg.configFile = {
    "niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/niri";
    "fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/fastfetch";
    "mango/config.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/mango/config.conf";
  };

  home.file = {
    "GEMINI.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/GEMINI.md";
  };

  # Paquetes de usuario
  home.packages = with pkgs; [
    fastfetch
    gnome-themes-extra
    adwaita-qt
    bibata-cursors
    # nerd-fonts.jetbrains-mono # Ya está en configuration.nix
    # vim # Gestionado por programs.neovim
    # neovim # Gestionado por programs.neovim
     alacritty
    fuzzel
    vesktop
    spotify
    google-chrome
    obs-studio
    mpv
    qt6Packages.fcitx5-configtool
    inputs.zen-browser.packages."x86_64-linux".default
    (whitesur-gtk-theme.override { themeVariants = ["pink"]; })
    (colloid-icon-theme.override { colorVariants = ["pink"]; })
    (antigravity.override { commandLineArgs = "--password-store=gnome-libsecret"; })
    playerctl
    hyprpicker
    eyedropper
    grim
    slurp
    imagemagick
    swappy
    grimblast

    # Rust-based stack tools
    zed-editor
    helix
    foot
    nushell
    starship
    yazi

    # Gaming
    mangohud
    protonup-qt
    heroic
    lutris
    bottles
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
      name = "WhiteSur-Dark-pink";
      package = (pkgs.whitesur-gtk-theme.override { themeVariants = ["pink"]; });
    };
    iconTheme = {
      name = "Colloid-Pink-Dark";
      package = pkgs.colloid-icon-theme.override { colorVariants = ["pink"]; };
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

  # Configuración de Nushell
  programs.nushell = {
    enable = true;
    # Integración con starship se hace automáticamente si ambos están habilitados en Home Manager
    # pero podemos añadir configuraciones extra si es necesario.
    extraConfig = ''
      $env.config = {
        show_banner: false,
      }
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableTransience = true;
    settings = builtins.fromTOML (builtins.readFile ./dotfiles/starship.toml);
  };

  # Configuración de Foot (Terminal ligera en Rust/C)
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "${pkgs.nushell}/bin/nu";
        font = "JetBrainsMono Nerd Font:size=12";
      };
      colors = {
        alpha = 0.9;
        background = "1e1e2e"; # Catppuccin Mocha-ish
        foreground = "cdd6f4";
      };
    };
  };

  # Configuración de Yazi (File Manager en Rust)
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  # Configuración de Helix (Editor en Rust)
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };

  # Configuración de Zsh vía Home Manager
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    initContent = ''
      fastfetch
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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


  programs.vscode = {
    enable = true;
    package = pkgs.vscode.override { commandLineArgs = "--password-store=gnome-libsecret"; };
    profiles.default.userSettings = {
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'SF Pro Display', monospace";
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
      "editor.fontLigatures" = true;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
