{ lib, ... }:
{
  options.dotfiles.desktop = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether this machine runs a graphical session.";
  };
}
