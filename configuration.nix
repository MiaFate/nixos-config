{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./noctalia.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10; # Mostrar solo las últimas 10 generaciones
  boot.loader.efi.canTouchEfiVariables = true;

  # Gaming Kernel: Zen Kernel para mejor respuesta
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Fix NVMe APST: XPG SPECTRIX S40G tiene firmware buggeado que no soporta APST
  boot.kernelParams = [ 
    "nvme_core.default_ps_max_latency_us=0" 
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];

  # Garbage collection automático (limpia generaciones viejas semanalmente)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_AR.UTF-8";
    LC_IDENTIFICATION = "es_AR.UTF-8";
    LC_MEASUREMENT = "es_AR.UTF-8";
    LC_MONETARY = "es_AR.UTF-8";
    LC_NAME = "es_AR.UTF-8";
    LC_NUMERIC = "es_AR.UTF-8";
    LC_PAPER = "es_AR.UTF-8";
    LC_TELEPHONE = "es_AR.UTF-8";
    LC_TIME = "es_AR.UTF-8";
  };

  # Configuración de entrada (fcitx5 para Japonés/Hiragana)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      ignoreUserConfig = true;
      addons = with pkgs; [
        fcitx5-mozc
      ];
      settings.inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us-intl";
        };
        "Groups/0/Items/0".Name = "keyboard-us-intl";
        "Groups/0/Items/1".Name = "mozc";
        GroupOrder."0" = "Default";
      };
    };
  };


  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;     # Guarda/restaura VRAM en suspend (fix pantalla negra al resumir)
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # SDDM Configuration
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "simple-sddm-2";
    extraPackages = with pkgs; [
      kdePackages.qtsvg
      kdePackages.qtmultimedia
      kdePackages.qtvirtualkeyboard
    ];
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.gvfs.enable = true; # Soporte para papelera y montaje de discos
  services.udisks2.enable = true; # Manejo de discos sin root
  services.tumbler.enable = true; # Soporte para miniaturas

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.mia = {
    isNormalUser = true;
    description = "mia";
    extraGroups = [ "networkmanager" "wheel" "input" "video" ];
    shell = pkgs.zsh;
  };

  # Fonts
  fonts.packages = with pkgs; [
    meslo-lgs-nf
    nerd-fonts.jetbrains-mono
    nerd-fonts.victor-mono
    noto-fonts-cjk-sans
    # Apple Fonts (SF Pro) from flake input
    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "MesloLGS NF" ];
      sansSerif = [ "SF Pro Display" "JetBrainsMono Nerd Font" ];
      serif = [ "SF Pro Display" "JetBrainsMono Nerd Font" ];
    };
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fix: Saltear tests de openldap que fallan aleatoriamente (test017)
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    (callPackage ./sddm-theme.nix {})
    wget
    libnotify
    git
    gemini-cli
    polkit_gnome
    libsecret
    wl-clipboard
    pavucontrol
    btop
    xwayland
    xwayland-satellite
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "niri:GNOME";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    GSK_RENDERER = "gl"; # Fix para xdg-desktop-portal-gnome y color picker en NVIDIA
  };

  # XDG Portals
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.ColorPicker" = [ "gtk" ];
      };
      common = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  # Programs and services
  programs.ssh.startAgent = true;
  services.gnome.gcr-ssh-agent.enable = false;
  programs.niri.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  programs.seahorse.enable = true;
  services.devmon.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = [
    pkgs.thunar-archive-plugin
    pkgs.thunar-volman
  ];

  # Gaming Configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
  description = "polkit-gnome-authentication-agent-1";
  wantedBy = [ "graphical-session.target" ];
  wants = [ "graphical-session.target" ];
  after = [ "graphical-session.target" ];
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    Restart = "on-failure";
    RestartSec = 1;
    TimeoutStopSec = 10;
  };
};



  programs.zsh.enable = true;

  # Logind: configuración explícita para desktop
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";             # No es laptop
    HandleLidSwitchExternalPower = "ignore";
    HandlePowerKey = "poweroff";
    HandleSuspendKey = "suspend";
    IdleAction = "ignore";
    IdleActionSec = "30min";
  };

  # ZRAM Swap (Recomendado para evitar congelamientos)
  zramSwap.enable = true;

  # habilita flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";

}
