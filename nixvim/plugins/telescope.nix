{ ... }:

{
  programs.nixvim.plugins.telescope = {
    enable = true;
    # Los mapeos están en keymaps.nix para centralizarlos
  };
}
