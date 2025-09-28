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
            pkgs.astro-language-server
            pkgs.black
            pkgs.lua-language-server
            pkgs.stylua
            pkgs.gopls
            pkgs.goimports
            pkgs.gofumpt
            pkgs.helm-ls
            pkgs.isort
            pkgs.pyright
            pkgs.rust-analyzer
            pkgs.nixd
            pkgs.nixfmt-classic
            pkgs.prettierd
            pkgs.terraform-ls
            pkgs.vtsls
            pkgs.vscode-langservers-extracted
          ];
        };

        toolPaths = pkgs.writeTextFile {
          name = "neovim-tools-json";
          destination = "/tools.json";
          text = builtins.toJSON {
            astro = "${pkgs.astro-language-server}/bin/astro-ls";
            black = "${pkgs.black}/bin/black";
            lua_ls = "${pkgs.lua-language-server}/bin/lua-language-server";
            stylua = "${pkgs.stylua}/bin/stylua";
            eslint =
              "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server";
            jsonls =
              "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
            gopls = "${pkgs.gopls}/bin/gopls";
            goimports = "${pkgs.gopls}/bin/goimports";
            gofumpt = "${pkgs.gopls}/bin/gofumpt";
            helm_ls = "${pkgs.helm-ls}/bin/helm_ls";
            isort = "${pkgs.isort}/bin/isort";
            pyright = "${pkgs.pyright}/bin/pyright-langserver";
            rust_analyzer = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            nixd = "${pkgs.nixd}/bin/nixd";
            nixfmt = "${pkgs.nixfmt-classic}/bin/nixfmt";
            prettierd = "${pkgs.prettierd}/bin/prettierd";
            terraformls = "${pkgs.terraform-ls}/bin/terraform-ls";
            vtsls = "${pkgs.vtsls}/bin/vtsls";
          };
        };
      });
    };
}
