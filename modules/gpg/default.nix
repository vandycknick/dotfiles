{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  gpgconf = "${config.programs.gpg.package}/bin/gpgconf";
in
{
  # Keyrings and trust stay mutable state in the home directory (git-ignored).
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";

    # Home Manager's defaults already match drduh's YubiKey-Guide gpg.conf
    # (cipher/digest preferences, long key ids, no comments or version, ...).
    settings = {
      no-greeting = true;
      armor = true;
      # Disable recipient key ID in messages (breaks Mailvelope).
      throw-keyids = true;
    };
  };

  # One agent for everything: the YubiKey through scdaemon, and the agent SSH
  # key, imported once with `ssh-add ~/.ssh/agent_ed25519` and kept
  # passphrase-protected in the agent's key store. sshAuthSock points shells
  # at it unless an agent was forwarded. Socket-activated by systemd on Linux.
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;

    # https://github.com/drduh/YubiKey-Guide/blob/master/config/gpg-agent.conf
    defaultCacheTtl = 60;
    maxCacheTtl = 120;

    # Applies only to SSH keys the agent stores itself (the agent key):
    # unlocked about once a day, never re-prompted mid-session.
    defaultCacheTtlSsh = 86400;
    maxCacheTtlSsh = 86400;

    # Headless machines prompt in the SSH terminal.
    pinentry.package =
      if !config.dotfiles.desktop then
        pkgs.pinentry-curses
      else if isDarwin then
        pkgs.pinentry_mac
      else
        pkgs.pinentry-gnome3;
    # Not set before; pinentry-mac and Wayland ignore it anyway.
    grabKeyboardAndMouse = false;
  };

  # gpg-agent only accepts systemd-style sockets (LISTEN_FDS), and Home
  # Manager's launchd agent binds them under /private/var/run instead of the
  # directory gpgconf reports. On macOS the agent starts on demand instead:
  # every shell (and with-agent) launches it.
  launchd.agents.gpg-agent.enable = lib.mkForce false;
  programs.fish.shellInit = lib.mkIf isDarwin "${gpgconf} --launch gpg-agent";

  home.packages = [ pkgs.yubikey-manager ];
}
