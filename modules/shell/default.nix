{
  config,
  lib,
  pkgs,
  machineIdentity,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  inherit (config.xdg) cacheHome configHome dataHome;

  sessionVars = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  # Login sh/bash/zsh: the shared session environment, then the tracked profile.
  profile = ''
    . "${sessionVars}"
    ${builtins.readFile ../../.config/shell/profile}
  '';
in
{
  # Exports XDG_{CONFIG,DATA,STATE,CACHE}_HOME through the session variables.
  xdg.enable = true;

  # One environment for every shell. sh-family logins source hm-session-vars.sh
  # from the generated profile; Fish gets a translated copy from its module.
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    EDITOR = "nvim";
    TERMINAL = "ghostty";

    XDG_BIN_HOME = "${config.home.homeDirectory}/.local/bin";

    # An inherited tool context (with-agent) takes precedence over the target default.
    MACHINE_IDENTITY = "\${MACHINE_IDENTITY:-${machineIdentity}}";

    PI_CODING_AGENT_DIR = "${configHome}/pi";
    PI_CODING_AGENT_SESSION_DIR = "${dataHome}/pi/sessions";

    LESSHISTFILE = "-";
    ZDOTDIR = "${configHome}/shell";

    GOPATH = "${dataHome}/go";
    CARGO_HOME = "${dataHome}/cargo";
    RUSTUP_HOME = "${dataHome}/rustup";
    NUGET_PACKAGES = "${cacheHome}/NuGet/packages";
    NUGET_PLUGINS_CACHE_PATH = "${cacheHome}/NuGet/plugins-cache";
    NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
    DENO_INSTALL_ROOT = "${config.home.homeDirectory}/.local";

    # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
    AWS_CONFIG_FILE = "${configHome}/aws/config";
    AWS_SHARED_CREDENTIALS_FILE = "${configHome}/aws/credentials";
    # https://learn.microsoft.com/en-us/cli/azure/azure-cli-configuration
    AZURE_CONFIG_DIR = "${configHome}/azure";
    K9SCONFIG = "${configHome}/k9s";

    GNUPGHOME = "${dataHome}/gnupg";
    PASSWORD_STORE_DIR = "${dataHome}/password-store";
  }
  // lib.optionalAttrs isDarwin {
    BROWSER = "/Applications/Zen.app/Contents/MacOS/zen";
  }
  // lib.optionalAttrs isLinux {
    # macOS has no XDG_RUNTIME_DIR; tmux keeps its default there.
    TMUX_TMPDIR = "$XDG_RUNTIME_DIR";
  };

  home.file.".profile".text = profile;
  home.file.".zprofile".text = profile;

  # Generates ~/.config/fish/config.fish, which sources the session variables.
  # Tracked conf.d/ and functions/ files are still linked individually.
  programs.fish = {
    enable = true;

    # conf.d/ runs before config.fish and so cannot see the session variables;
    # anything that depends on them belongs here.
    shellInit = ''
      source ${./identity.fish}
    '';

    interactiveShellInit = ''
      set fish_greeting ""
      set -g fish_key_bindings fish_vi_key_bindings

      set -g my_prompt_color_prompt green

      direnv hook fish | source
      zoxide init fish | source
      atuin init fish | source
      wtp hook fish | source

      bind -M insert \cp up-or-search
      bind -M insert \cn down-or-search
      bind -M insert \cy accept-autosuggestion
    ''
    + lib.optionalString isLinux ''

      if test (tty) = /dev/tty1
        if uwsm check may-start; and uwsm select
          exec uwsm start default
        end
      end
    '';
  };
}
