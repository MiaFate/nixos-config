{ ... }:

{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./theme.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };
}
