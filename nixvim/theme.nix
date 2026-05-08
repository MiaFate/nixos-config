{ ... }:

{
  programs.nixvim = {
    colorschemes.rose-pine = {
      enable = true;
      settings = {
        variant = "moon";
        dark_variant = "moon";
        disable_background = true; # Para transparencia
      };
    };

    # Forzar transparencia vía Lua (como estaba en la config original)
    extraConfigLua = ''
      local function set_transparency()
          local highlights = { "Normal", "NormalFloat", "NormalNC", "SignColumn", "StatusLine" }
          for _, hl in ipairs(highlights) do
              vim.api.nvim_set_hl(0, hl, { bg = "none", ctermbg = "none" })
          end
      end
      set_transparency()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_transparency })
    '';
  };
}
