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
      self,
      nixpkgs,
      nixpkgs-master,
      home-manager,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "1password-cli"
          "claude-code"
          "terraform"
        ];

      # Packages that track nixpkgs master for faster releases.
      fromMaster =
        final: prev:
        let
          master = import nixpkgs-master {
            inherit (prev.stdenv.hostPlatform) system;
            inherit config;
          };
        in
        {
          inherit (master) claude-code codex;
        };

      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system config;
          overlays = [ fromMaster ];
        }
      );
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

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
          pkgs = pkgsFor.${system};
          extraSpecialArgs = { inherit machineIdentity; };
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

      # `nix run github:vandycknick/dotfiles#nvim` anywhere.
      packages = forEachSystem (pkgs: {
        nvim = import ./.config/nvim/package.nix { inherit pkgs; };
      });

      apps = forEachSystem (pkgs: {
        nvim = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.nvim}/bin/nvim";
          meta.description = "Neovim with the language servers and tools from .config/nvim";
        };
      });

      formatter = forEachSystem (pkgs: pkgs.nixfmt-tree);

      checks = forEachSystem (
        pkgs:
        let
          inherit (pkgs.stdenv.hostPlatform) system;
          homes = lib.filterAttrs (_: home: home.activationPackage.system == system) self.homeConfigurations;
        in
        lib.mapAttrs' (
          name: home:
          lib.nameValuePair "home-${lib.replaceStrings [ "@" ] [ "-" ] name}" home.activationPackage
        ) homes
        // {
          shellcheck = pkgs.runCommand "shellcheck" { nativeBuildInputs = [ pkgs.shellcheck ]; } ''
            shellcheck ${./install.sh}
            touch $out
          '';
          nixfmt = pkgs.runCommand "nixfmt" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
            find ${self} -name '*.nix' -exec nixfmt --check {} +
            touch $out
          '';
        }
      );
    };
}
