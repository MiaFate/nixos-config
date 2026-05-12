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
    vscode-langservers-extracted # JSON, HTML, CSS
    yaml-language-server    # YAML
    taplo                   # TOML
    pyright                 # Python
    gopls                   # Go
    jdt-language-server     # Java
    
    # --- Lenguajes / Runtimes ---
    go
    jdk
    
    # --- Formateadores y Linters ---
    nixfmt                  # Nix
    rustfmt                 # Rust
    shellcheck              # Bash
    shfmt                   # Bash
    
    # --- Herramientas de Desarrollo Comunes ---
    gh                      # GitHub CLI
    ripgrep                 # Búsqueda rápida (usado por Telescope/Helix)
    fd                      # Búsqueda de archivos (usado por Telescope/Helix)
  ];
}
