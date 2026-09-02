{
  description = "My Personal Tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    systems.url = "github:nix-systems/default";

    nvim = {
      url = "path:../../nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-master,
      systems,
      nvim,
      ...
    }:
    let
      lib = nixpkgs.lib;
      supportedSystems = builtins.filter (
        system:
        builtins.elem system [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ]
      ) (import systems);

      forEachSystem =
        f:
        lib.genAttrs supportedSystems (
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
          pkgsMaster = import nixpkgs-master {
            inherit system;
            config.allowUnfree = true;
          };

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
                  hash = "sha256-af3G2rc4JsqN7fn9uitN4S5z1x/DVLadHbszCUQswz0=";
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
                tmux
                zoxide
                atuin
                direnv
                wtp

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
                bc
                bind
                gum
                tealdeer
                wget

                # Git
                git
                git-lfs
                stow
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
                docker-client
                gcx
                github-cli

                # Secrets
                gnupg
                openssh
                onePasswordCliBeta

                # Editors & AI
                python3Packages.ansible-core
                pkgsMaster.claude-code
                opencode
                pi-coding-agent
                shellcheck
                nvim.packages.${system}.default
              ]
              ++ lib.optionals pkgs.stdenv.isLinux [
                # Linux user utilities
                iproute2
                pinentry-gnome3
                procps
                wl-clipboard
                xclip
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
