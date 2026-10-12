{
  description = "nvim";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.systems.url = "github:nix-systems/default";

  outputs =
    {
      self,
      nixpkgs,
      systems,
    }:
    let
      lib = nixpkgs.lib;
      supportedSystems = lib.genAttrs (import systems);
      forEachSystem = f: supportedSystems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forEachSystem (pkgs: {
        default = import ./package.nix { inherit pkgs; };
      });

      apps = forEachSystem (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.system}.default}/bin/nvim";
        };
      });
    };
}
