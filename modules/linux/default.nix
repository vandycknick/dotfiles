{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  home.packages = with pkgs; [
    iproute2
    procps
    wl-clipboard
    xclip
  ];
}
