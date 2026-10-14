{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.packages = with pkgs; [
    # ~/.docker/config.json uses credsStore osxkeychain.
    docker-credential-helpers
  ];
}
