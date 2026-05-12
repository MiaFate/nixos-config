{ pkgs, ... }:

{
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      pyright.enable = true;
      lua_ls = {
        enable = true;
        settings.Lua.diagnostics.globals = [ "vim" ];
      };
      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
      marksman.enable = true;
      taplo.enable = true;
    };
    
    keymaps = {
      silent = true;
      lspBuf = {
        "K" = "hover";
        "gd" = "definition";
        "gr" = "references";
        "<leader>a" = "code_action";
      };
}
