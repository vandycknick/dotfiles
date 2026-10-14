{ lib, pkgs, ... }:
let
  gcArgs = [
    "--delete-older-than"
    "30d"
  ];
in
{
  # Validates the generated nix.conf at build time; not installed.
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Also prunes Home Manager generations older than 30 days.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = lib.escapeShellArgs gcArgs;
  };

  # Home Manager passes nix.gc.options to launchd as a single argument.
  launchd.agents.nix-gc.config.ProgramArguments = lib.mkForce (
    [ "${pkgs.nix}/bin/nix-collect-garbage" ] ++ gcArgs
  );
}
