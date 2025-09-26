{
  description = "Neovim tools";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.systems.url = "github:nix-systems/default";

  outputs = { nixpkgs, systems }:
    let
      supportedSystems = nixpkgs.lib.genAttrs (import systems);
      forEachSystem = f: supportedSystems (system: f nixpkgs.legacyPackages.${system});
    in {
      packages = forEachSystem (pkgs: {
        default = pkgs.buildEnv {
          name = "neovim-tools";
          paths = [
            pkgs.lua-language-server
            pkgs.gopls
            pkgs.rust-analyzer
            pkgs.stylua
          ];
        };

        toolPaths = pkgs.writeTextFile {
          name = "neovim-tools-json";
          destination = "/tools.json";
          text = builtins.toJSON {
            lua_ls        = "${pkgs.lua-language-server}/bin/lua-language-server";
            gopls         = "${pkgs.gopls}/bin/gopls";
            rust_analyzer = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            stylua        = "${pkgs.stylua}/bin/stylua";
          };
        };
      });
    };
}
