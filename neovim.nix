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

    # Al ser un plugin de vim, queremos que el resultado contenga los archivos de lua
    # y el binario en la carpeta bin/
    postInstall = ''
      mkdir -p $out/bin
      mv $out/bin/gemini-server $out/bin/gemini-server-bin # Evitar conflictos si el binario se llama igual que el paquete
      # Copiar el resto de los archivos del plugin (lua, doc, etc.)
      cp -r ./* $out/
      # Asegurarnos de que el binario esté donde el plugin lo espera
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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      # LSPs
      pyright
      lua-language-server
      rust-analyzer
      marksman
      taplo

      # Herramientas de soporte
      nodejs # Para copilot.lua
      go     # Para gemini-mcp (si lo requiere en runtime)
      ripgrep # Para telescope
      fd      # Para telescope
    ];

    plugins = with pkgs.vimPlugins; [
      # Colorscheme
      rose-pine

      # LSP & Completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-nvim-lsp-signature-help
      cmp-vsnip
      cmp-path
      cmp-buffer
      vim-vsnip

      # Treesitter
      (nvim-treesitter.withPlugins (p: [
        p.lua
        p.rust
        p.toml
        p.markdown
        p.markdown_inline
      ]))

      # UI
      lualine-nvim
      nvim-web-devicons
      neo-tree-nvim
      plenary-nvim
      nui-nvim
      which-key-nvim
      mini-icons
      transparent-nvim

      # Utilities
      copilot-lua
      snacks-nvim
      telescope-nvim
      nvim-nio

      # Custom
      love2d-nvim
      gemini-mcp
      gemini-cli-nvim
    ];

    initLua = ''
      -- Set leader key
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- Rose Pine colorscheme
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "moon",
        disable_background = true,
      })
      vim.cmd("colorscheme rose-pine")

      -- Lualine
      local colors = {
        blue   = "#89b4fa",
        cyan   = "#89dceb",
        black  = "#1e1e2e",
        white  = "#a6adc8",
        red    = "#f38ba8",
        violet = "#b4befe",
        grey   = "#6c7086",
      }

      local bubbles_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.blue },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.white, bg = colors.black },
        },
        insert = { a = { fg = colors.black, bg = colors.red } },
        visual = { a = { fg = colors.black, bg = colors.cyan } },
        replace = { a = { fg = colors.black, bg = colors.red } },
        inactive = {
          a = { fg = colors.white, bg = colors.black },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white, bg = colors.black },
        },
      }

      require("lualine").setup {
        options = {
          theme = bubbles_theme,
          component_separators = "|",
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { 'mode', separator = { left = "" }, right_padding = 2 } },
          lualine_b = { 'filename', 'branch' },
          lualine_c = { 'fileformat' },
          lualine_x = { 'encoding', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { { 'location', separator = { right = "" }, left_padding = 2 } },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
      }

      -- Neo-tree
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
      require("neo-tree").setup({
        window = {
          mappings = {
            ["h"] = "navigate_up",
            ["l"] = "open",
            [";"] = "close_node",
          }
        }
      })

      -- Copilot
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
      })

      -- Telescope
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Buscar archivos' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Buscar texto (Grep)' })

      -- Snacks.nvim
      require("snacks").setup({
        terminal = { enabled = true },
        notifier = { enabled = true },
      })

      -- Gemini Integration
      require("gemini").setup({})
      vim.keymap.set("n", "<leader>gy", "<cmd>GeminiDiffAccept<cr>", { desc = "Aceptar Cambios Gemini" })
      vim.keymap.set("n", "<leader>gn", "<cmd>GeminiDiffDeny<cr>", { desc = "Rechazar Cambios Gemini" })

      -- Which-key
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wk = require("which-key")
      wk.setup {}
      wk.add({
        { "<leader>e", desc = "Explorador de Archivos (Neo-tree)", mode = "n" },
        { "<leader>a", desc = "Acciones de código (LSP)", mode = "n" },
        { "<leader>v", group = "LÖVE 2D", mode = "n" },
        { "<leader>g", group = "Gemini AI", mode = "n" },
        { "<leader>f", group = "Fuzzy Finder (Telescope)", mode = "n" },
        { "<C-l>", desc = "Aceptar sugerencia de Copilot", mode = "i" },
        { "<CR>", desc = "Aceptar autocompletado", mode = "i" },
      })

      -- Completion (nvim-cmp)
      local cmp = require 'cmp'
      cmp.setup({
        snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
        mapping = {
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            else fallback() end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- LSP Setup (Modern Neovim 0.11+ style)
      if vim.fn.has('nvim-0.11') == 1 then
        vim.lsp.config('pyright', {})
        vim.lsp.config('lua_ls', {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        })
        vim.lsp.config('rust_analyzer', {})
        vim.lsp.config('marksman', {})
        vim.lsp.config('taplo', {})

        -- Auto-attach for 0.11+
        vim.lsp.enable('pyright')
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('rust_analyzer')
        vim.lsp.enable('marksman')
        vim.lsp.enable('taplo')

        -- Custom on_attach for rust_analyzer
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.name == 'rust_analyzer' then
              vim.keymap.set("n", "<C-space>", vim.lsp.buf.hover, { buffer = args.buf })
              vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, { buffer = args.buf })
            end
          end,
        })
      else
        -- Fallback for older versions
        local lspconfig = require('lspconfig')
        lspconfig.pyright.setup {}
        lspconfig.lua_ls.setup {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        }
        lspconfig.rust_analyzer.setup {
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<C-space>", vim.lsp.buf.hover, { buffer = bufnr })
            vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, { buffer = bufnr })
          end,
        }
        lspconfig.marksman.setup {}
        lspconfig.taplo.setup {}
      end

      -- General Options
      vim.opt.number = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 4
      vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }

      -- Transparency
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
