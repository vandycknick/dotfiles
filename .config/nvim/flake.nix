{
  description = "nvim";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
              pkgs.harper
              pkgs.helm-ls
              pkgs.isort
              pkgs.oxlint
              pkgs.pyright
              pkgs.rust-analyzer
              pkgs.nixd
              pkgs.nixfmt
              pkgs.prettierd
              pkgs.terraform-ls
              pkgs.vtsls
              pkgs.vscode-langservers-extracted
            ] ++ lib.optionals pkgs.stdenv.isLinux [
              pkgs.inotify-tools # Lsp file watching requires inotify tools to be installed on Linux: https://gitlab.b-data.ch/neovim/neovim/-/blob/master/runtime/lua/vim/lsp/_watchfiles.lua?ref_type=heads#L11
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
