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
          # terraform (BUSL), claude-code, and 1password-cli are unfree.
          config.allowUnfree = true;
        };

      mkHome =
        {
          system,
          username,
          homeDirectory,
          machineIdentity,
          genericLinux ? false,
          desktop ? false,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = unfree system nixpkgs;
          extraSpecialArgs.pkgsMaster = unfree system nixpkgs-master;
          extraSpecialArgs.machineIdentity = machineIdentity;
          modules = [
            ./home.nix
            {
              home = { inherit username homeDirectory; };
              targets.genericLinux.enable = genericLinux;
              dotfiles.desktop = desktop;
            }
          ];
        };
    in
    {
      # "<user>@<hostname>" for specific machines (desktops), else the headless
      # "<user>@<flavor>" fallback; install.sh tries them in that order.
      homeConfigurations = {
        "coder@nixos" = mkHome {
          system = "x86_64-linux";
          username = "coder";
          homeDirectory = "/home/coder";
          machineIdentity = "agent";
        };
        "nickvd@nixos" = mkHome {
          system = "x86_64-linux";
          username = "nickvd";
          homeDirectory = "/home/nickvd";
          machineIdentity = "personal";
        };
        "nickvd@linux" = mkHome {
          system = "x86_64-linux";
          username = "nickvd";
          homeDirectory = "/home/nickvd";
          genericLinux = true;
          machineIdentity = "personal";
        };
        "nickvd@darwin" = mkHome {
          system = "aarch64-darwin";
          username = "nickvd";
          homeDirectory = "/Users/nickvd";
          machineIdentity = "personal";
          desktop = true;
        };
      };
    };
}
