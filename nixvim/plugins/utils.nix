{ ... }:

{
  programs.nixvim.plugins = {
    which-key = {
      enable = true;
      settings.spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "Fuzzy Finder (Telescope)";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Gemini AI";
        }
        {
          __unkeyed-1 = "<leader>v";
          group = "LÖVE 2D";
        }
      ];
    };

    copilot-lua = {
      enable = true;
      settings = {
        suggestion = {
          enabled = true;
          auto_trigger = true;
          keymap = {
            accept = "<C-l>";
            next = "<M-]>";
            prev = "<M-[>";
            dismiss = "<C-]>";
          };
        };
        panel.enabled = false;
      };
    };

    snacks = {
      enable = true;
      settings = {
        terminal.enabled = true;
        notifier.enabled = true;
      };
    };

    # Soporte para hilos en Neovim (requerido por algunos plugins)
    nvim-nio.enable = true;
  };
}
