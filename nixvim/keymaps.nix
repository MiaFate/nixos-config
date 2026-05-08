{ ... }:

{
  programs.nixvim = {
    globals.mapleader = " ";
    globals.maplocalleader = " ";

    keymaps = [
      # Explorador de archivos (Neo-tree se configura en su propio plugin, pero el atajo va aquí)
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options = {
          silent = true;
          desc = "Explorador de Archivos (Neo-tree)";
        };
      }

      # Telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Buscar archivos";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Buscar texto (Grep)";
      }

      # Gemini Integration
      {
        mode = "n";
        key = "<leader>gy";
        action = "<cmd>GeminiDiffAccept<CR>";
        options.desc = "Aceptar Cambios Gemini";
      }
      {
        mode = "n";
        key = "<leader>gn";
        action = "<cmd>GeminiDiffDeny<CR>";
        options.desc = "Rechazar Cambios Gemini";
      }

      # LSP (Serán sobreescritos por mapeos específicos de LSP si es necesario)
      {
        mode = "n";
        key = "<leader>a";
        action.__raw = "vim.lsp.buf.code_action";
        options.desc = "Acciones de código (LSP)";
      }
    ];
  };
}
