{ ... }:

{
  programs.nixvim.plugins = {
    web-devicons.enable = true;

    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "rose-pine";
          component_separators = "|";
          section_separators = {
            left = "";
            right = "";
          };
        };
        sections = {
          lualine_a = [
            {
              __unkeyed-1 = "mode";
              separator.left = "";
              right_padding = 2;
            }
          ];
          lualine_b = [ "filename" "branch" ];
          lualine_c = [ "fileformat" ];
          lualine_x = [ "encoding" "filetype" ];
          lualine_y = [ "progress" ];
          lualine_z = [
            {
              __unkeyed-1 = "location";
              separator.right = "";
              left_padding = 2;
            }
          ];
        };
      };
    };

    neo-tree = {
      enable = true;
      # Ahora la configuración va dentro de 'settings'
      settings = {
        window.mappings = {
          "h" = "navigate_up";
          "l" = "open";
          ";" = "close_node";
        };
      };
    };

    mini.modules.icons = {};
  };
}
