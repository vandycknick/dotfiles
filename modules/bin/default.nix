{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  gpgconf = "${config.programs.gpg.package}/bin/gpgconf";

  # Agent context: the agent Git config (SSH signing with the agent key) and,
  # through .ssh/config, the agent key first for SSH. Both keys live in the one
  # gpg-agent (modules/gpg).
  with-agent = pkgs.writeShellApplication {
    name = "with-agent";
    text = ''
      if [ "$#" -eq 0 ]; then
        echo 'Usage: with-agent COMMAND [ARG ...]' >&2
        exit 2
      fi

      # Callers outside a login shell (GUI apps, launchd on macOS) may lack the
      # session variables or carry another agent's socket; keep only a socket
      # forwarded by sshd.
      export GNUPGHOME="''${GNUPGHOME:-${config.programs.gpg.homedir}}"
      if [ -z "''${SSH_CONNECTION:-}" ] || [ ! -S "''${SSH_AUTH_SOCK:-}" ]; then
        SSH_AUTH_SOCK=$(${gpgconf} --list-dirs agent-ssh-socket)
        export SSH_AUTH_SOCK
      fi
    ''
    + lib.optionalString isDarwin ''
      # No socket activation on macOS (modules/gpg): connecting starts the agent.
      ${config.programs.gpg.package}/bin/gpg-connect-agent --quiet /bye
    ''
    + ''

      export MACHINE_IDENTITY=agent
      export GIT_CONFIG_GLOBAL="${config.xdg.configHome}/git/agent"
      export GIT_SSH_COMMAND=ssh
      exec "$@"
    '';
  };

  # Coding-agent CLIs run in the agent context on agent machines, or wherever
  # the agent key is present; otherwise as the user. The wrapper shadows the
  # package's own binary (hiPrio) while its man pages and completions stay.
  agentClis = [
    {
      name = "claude";
      package = pkgs.claude-code;
    }
    {
      name = "codex";
      package = pkgs.codex;
      # Updates come from nixpkgs; the built-in updater would install a curl
      # copy into ~/.local/bin.
      args = [
        "-c"
        "check_for_update_on_startup=false"
      ];
    }
    {
      name = "omp";
      package = pkgs.omp;
    }
    {
      name = "opencode";
      package = pkgs.opencode;
    }
    {
      name = "pi";
      package = pkgs.pi-coding-agent;
    }
  ];

  mkAgentCli =
    {
      name,
      package,
      args ? [ ],
    }:
    let
      exec = "${lib.getExe' package name} ${lib.escapeShellArgs args}";
    in
    pkgs.writeShellApplication {
      inherit name;
      text = ''
        key="$HOME/.ssh/agent_ed25519"
        if [ "''${MACHINE_IDENTITY:-}" = agent ] || [ -e "$key" ] || [ -L "$key" ] ||
          [ -e "$key.pub" ] || [ -L "$key.pub" ]; then
          exec ${lib.getExe with-agent} ${exec} "$@"
        fi
        exec ${exec} "$@"
      '';
    };

  # Personal commands, shellchecked at build time with their tools pinned.
  mkScript =
    name: args:
    pkgs.writeShellApplication (
      {
        inherit name;
        text = builtins.readFile ./scripts/${name}.sh;
      }
      // args
    );

  scripts = [
    (mkScript "ecr-docker-login" {
      runtimeInputs = with pkgs; [
        awscli2
        docker-client
      ];
      bashOptions = [
        "errexit"
        "pipefail"
      ];
    })
    (mkScript "kubectl-ctx" {
      runtimeInputs = with pkgs; [
        gnugrep
        gum
        kubectl
      ];
    })
    (mkScript "kubectl-ec2" {
      runtimeInputs = with pkgs; [
        awscli2
        coreutils
        gawk
        kubectl
        ssm-session-manager-plugin
        yq-go
      ];
    })
  ];
in
{
  home.packages = [
    with-agent
  ]
  ++ lib.concatMap (cli: [
    cli.package
    (lib.hiPrio (mkAgentCli cli))
  ]) agentClis
  ++ scripts;
}
