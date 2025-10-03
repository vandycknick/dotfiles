{
  description = "nvim";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.systems.url = "github:nix-systems/default";

  outputs = { self, nixpkgs, systems }:
    let
      lib = nixpkgs.lib;
      bashOptions = [ "errexit" "nounset" "pipefail" ];
      supportedSystems = lib.genAttrs (import systems);
      forEachSystem = f:
        supportedSystems (system: f nixpkgs.legacyPackages.${system});
    in {
      packages = forEachSystem (pkgs:
        let
          plugins = pkgs.symlinkJoin {
            name = "nvim-plugins";
            paths = [
              pkgs.astro-language-server
              pkgs.black
              pkgs.lua-language-server
              pkgs.stylua
              pkgs.gopls
              pkgs.gotools
              pkgs.gofumpt
              pkgs.helm-ls
              pkgs.isort
              pkgs.oxlint
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
        in {

          default = pkgs.writeShellScriptBin "nvim" ''
            ${lib.concatMapStringsSep "\n" (option: "set -o ${option}")
            bashOptions}
            export PATH="${plugins}/bin:$PATH"

            exec ${pkgs.neovim}/bin/nvim "$@"
          '';
        });

      apps = forEachSystem (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.system}.default}/bin/nvim";
        };
      });
    };
}
