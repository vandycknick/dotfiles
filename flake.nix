{
  description = "Personal Home Manager environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-master,
      home-manager,
      ...
    }:
    let
      unfree =
        system: source:
        import source {
          inherit system;
          # terraform (BUSL) and claude-code are unfree.
          config.allowUnfree = true;
        };

      mkHome =
        {
          system,
          username,
          homeDirectory,
          genericLinux ? false,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = unfree system nixpkgs;
          extraSpecialArgs.pkgsMaster = unfree system nixpkgs-master;
          modules = [
            ./home.nix
            {
              home = { inherit username homeDirectory; };
              targets.genericLinux.enable = genericLinux;
            }
          ];
        };
    in
    {
      # Key: "<user>@<flavor>"; install.sh derives flavor as nixos | linux | darwin.
      homeConfigurations = {
        "coder@nixos" = mkHome {
          system = "x86_64-linux";
          username = "coder";
          homeDirectory = "/home/coder";
        };
        "nickvd@nixos" = mkHome {
          system = "x86_64-linux";
          username = "nickvd";
          homeDirectory = "/home/nickvd";
        };
        "nickvd@linux" = mkHome {
          system = "x86_64-linux";
          username = "nickvd";
          homeDirectory = "/home/nickvd";
          genericLinux = true;
        };
        "nickvd@darwin" = mkHome {
          system = "aarch64-darwin";
          username = "nickvd";
          homeDirectory = "/Users/nickvd";
        };
      };
    };
}
