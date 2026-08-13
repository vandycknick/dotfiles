{
  description = "My Personal Tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    nvim = {
      url = "path:../../nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      systems,
      nvim,
      ...
    }:
    let
      lib = nixpkgs.lib;

      forEachSystem =
        f:
        lib.genAttrs (import systems) (
          system:
          f system (
            import nixpkgs {
              inherit system;

              # Needed for terraform (BUSL) and the 1Password CLI (proprietary).
              config.allowUnfree = true;
            }
          )
        );
    in
    {
      packages = forEachSystem (
        system: pkgs:
        let
          onePasswordVersion = "2.39.0-beta.02";

          onePasswordSource =
            {
              x86_64-linux = {
                platform = "linux_amd64";
                extension = "zip";
              };

              aarch64-linux = {
                platform = "linux_arm64";
                extension = "zip";
              };

              aarch64-darwin = {
                platform = "apple_universal";
                extension = "pkg";
              };
            }
            .${system} or (throw "1Password CLI beta is not supported on ${system}");

          onePasswordCliBeta = pkgs._1password-cli.overrideAttrs (_old: {
            version = onePasswordVersion;

            src =
              if onePasswordSource.extension == "zip" then
                pkgs.fetchzip {
                  url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${onePasswordVersion}/op_${onePasswordSource.platform}_v${onePasswordVersion}.zip";
                  hash = "sha256-ZbqkqY2InfeBU3jxh27F9WPMy6EyrERUbO1PM9i0ycA=";
                  stripRoot = false;
                }
              else
                pkgs.fetchurl {
                  url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${onePasswordVersion}/op_${onePasswordSource.platform}_v${onePasswordVersion}.pkg";
                  hash = lib.fakeHash;
                };
          });
        in
        {
          default = pkgs.buildEnv {
            name = "personal-tools";

            paths =
              with pkgs;
              [
                # Shell & environment
                fish
                zoxide
                atuin
                direnv
                zmx

                # File & text navigation
                eza
                bat
                ripgrep
                fd
                fzf

                # Data & code inspection
                jq
                yq-go
                tokei

                # Git
                lazygit
                hunk

                # Cloud & infrastructure
                awscli2
                ssm-session-manager-plugin
                google-cloud-sdk
                terraform
                kubectl
                kubernetes-helm
                k9s
                coder

                # Secrets
                onePasswordCliBeta

                # Editors & AI
                opencode
                nvim.packages.${system}.default
              ]
              ++ lib.optionals pkgs.stdenv.isDarwin [
                # macOS only
                pinentry_mac
              ];
          };
        }
      );
    };
}
