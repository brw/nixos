{
  lib,
  inputs,
  callPackage,
  mpv,
  parsec-bin,
  vivaldi,
}:

lib.recurseIntoAttrs {
  equicord = callPackage ./equicord.nix { inherit inputs; };

  mpv = callPackage ./mpv.nix { } mpv;

  parsec-bin = callPackage ./parsec-bin.nix { } parsec-bin;

  vivaldi = callPackage ./vivaldi.nix { inherit inputs; } vivaldi;
}
