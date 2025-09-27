{
  description = "Neovim tools";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.systems.url = "github:nix-systems/default";

  outputs = { self, nixpkgs, systems }:
    let
      supportedSystems = nixpkgs.lib.genAttrs (import systems);
      forEachSystem = f:
        supportedSystems (system: f nixpkgs.legacyPackages.${system});
    in {
      packages = forEachSystem (pkgs: {
        default = pkgs.buildEnv {
          name = "neovim-tools";
          paths = [
            pkgs.lua-language-server
            pkgs.stylua
            pkgs.gopls
            pkgs.goimports
            pkgs.gofumpt
            pkgs.rust-analyzer
            pkgs.nixd
            pkgs.nixfmt-classic
            pkgs.prettierd
          ];
        };

        toolPaths = pkgs.writeTextFile {
          name = "neovim-tools-json";
          destination = "/tools.json";
          text = builtins.toJSON {
            lua_ls = "${pkgs.lua-language-server}/bin/lua-language-server";
            stylua = "${pkgs.stylua}/bin/stylua";
            gopls = "${pkgs.gopls}/bin/gopls";
            goimports = "${pkgs.gopls}/bin/goimports";
            gofumpt = "${pkgs.gopls}/bin/gofumpt";
            rust_analyzer = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            nixd = "${pkgs.nixd}/bin/nixd";
            nixfmt = "${pkgs.nixfmt-classic}/bin/nixfmt";
            prettierd = "${pkgs.prettierd}/bin/prettierd";
          };
        };
      });
    };
}
