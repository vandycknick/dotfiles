{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  home.packages =
    with pkgs;
    [
      iproute2
      procps
    ]
    # Clipboard bridges for a graphical session.
    ++ lib.optionals config.dotfiles.desktop [
      wl-clipboard
      xclip
    ];
}
