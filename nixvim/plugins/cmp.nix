{ ... }:

{
  programs.nixvim.plugins = {
    cmp-nvim-lsp.enable = true;
    cmp-path.enable = true;
    cmp-buffer.enable = true;
    
    cmp = {
      enable = true;
      settings = {
        snippet.expand = ''
          function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end
        '';
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, { "i", "s" })
          '';
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end, { "i", "s" })
          '';
        };
        sources = [
          { name = "copilot"; }
          { name = "nvim_lsp"; }
          { name = "vsnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
    };
  };
}
