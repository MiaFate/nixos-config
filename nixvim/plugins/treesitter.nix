{ pkgs, ... }:

{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      lua
      rust
      toml
      markdown
      markdown_inline
      nix
    ];
  };
}
