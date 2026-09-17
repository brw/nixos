{
  lib,
  callPackage,
}:

lib.recurseIntoAttrs {
  keylightd = callPackage ./keylightd.nix { };

  # reasonix-desktop = callPackage ./reasonix-desktop.nix { };

  fishPlugins = callPackage ./fishPlugins { };
}
