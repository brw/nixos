{ pkgs, inputs }:
let
  overrides = import ../overrides { inherit pkgs inputs; };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    keylightd = callPackage ./keylightd.nix { };

    # reasonix-desktop = callPackage ./reasonix-desktop.nix { };
  };
in
packages // overrides
