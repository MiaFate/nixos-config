{ ... }:

{
  programs.nixvim.opts = {
    # Numeración
    number = true;
    relativenumber = false;

    # Indentación
    shiftwidth = 4;
    tabstop = 4;
    expandtab = true;
    smartindent = true;

    # Comportamiento
    ignorecase = true;
    smartcase = true;
    cursorline = true;
    scrolloff = 8;
    mouse = "a";

    # Apariencia y UX
    termguicolors = true;
    signcolumn = "yes";
    completeopt = [ "menuone" "noselect" "noinsert" ];
    
    # Tiempo de espera para mapeos (Which-key)
    timeout = true;
    timeoutlen = 300;
  };
}
