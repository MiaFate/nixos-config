{ config, pkgs, ... }:

{
  home.username = "mia";
  home.homeDirectory = "/home/mia";

  # Enlaces a archivos de configuración
  xdg.configFile = {
    "niri".source = ./dotfiles/niri;
    "kitty".source = ./dotfiles/kitty;
    "nvim".source = ./dotfiles/nvim;
  };

  home.file = {
    ".p10k.zsh".source = ./dotfiles/p10k.zsh;
    "GEMINI.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/GEMINI.md";
  };

  # Paquetes de usuario
  home.packages = with pkgs; [
    # Puedes mover paquetes de systemPackages aquí si son solo para tu usuario
  ];

  # Configuración de Zsh vía Home Manager
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
      custom = "$HOME/.oh-my-zsh/custom";
      theme = "powerlevel10k";
    };
    initContent = ''
      # Cargar p10k si existe
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
