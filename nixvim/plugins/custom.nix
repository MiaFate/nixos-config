{ pkgs, ... }:

let
  # Custom plugins not in nixpkgs
  love2d-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "love2d.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "S1M0N38";
      repo = "love2d.nvim";
      rev = "main";
      hash = "sha256-K1ZVmo5U2b2spjJTyLDYeXij0XIUjSYfAA5/W67PYu0=";
    };
  };

  gemini-mcp = pkgs.buildGoModule {
    name = "gemini-mcp";
    src = pkgs.fetchFromGitHub {
      owner = "vaijab";
      repo = "gemini-cli.nvim";
      rev = "master";
      hash = "sha256-noKi/IeC5IIYN9UPmwnaxVyk+uOrRGFObg9ne6AboRY=";
    };
    vendorHash = "sha256-H0Wyc7WY3NbTNnQlJcQZuEQds2jhISN8+Xxgcji2jow=";

    postInstall = ''
      mkdir -p $out/bin
      mv $out/bin/gemini-server $out/bin/gemini-server-bin
      cp -r ./* $out/
      mkdir -p $out/bin
      cp $out/bin/gemini-server-bin $out/bin/gemini-server
    '';
  };

  gemini-cli-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "gemini-cli-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "marcinjahn";
      repo = "gemini-cli.nvim";
      rev = "master";
      hash = "sha256-C4OI6NM+Bpa5WffmXY+tNLfuYyX0LNbmsAe9GDBRVCQ=";
    };
  };
in
{
  programs.nixvim = {
    extraPlugins = [
      love2d-nvim
      gemini-mcp
      gemini-cli-nvim
    ];

    extraConfigLua = ''
      -- Gemini setup
      require("gemini").setup({})
    '';
  };
}
