{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --- Language Servers (LSPs) ---
    nil                     # Nix
    nixd                    # Nix (diagnósticos detallados)
    rust-analyzer           # Rust
    lua-language-server     # Lua
    bash-language-server    # Bash
    marksman                # Markdown
    nodePackages.vscode-json-languageserver # JSON
    yaml-language-server    # YAML
    taplo                   # TOML
    pyright                 # Python
    gopls                   # Go
    jdtls                   # Java
    
    # --- Lenguajes / Runtimes ---
    go
    jdk
    
    # --- Formateadores y Linters ---
    nixfmt-rfc-style        # Nix
    rustfmt                 # Rust
    shellcheck              # Bash
    shfmt                   # Bash
    
    # --- Herramientas de Desarrollo Comunes ---
    gh                      # GitHub CLI
    ripgrep                 # Búsqueda rápida (usado por Telescope/Helix)
    fd                      # Búsqueda de archivos (usado por Telescope/Helix)
  ];
}
