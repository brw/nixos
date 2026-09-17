{ pkgs, inputs }:

{
  emmylua-ls = import ./emmylua-ls.nix { inherit pkgs; };

  equicord = import ./equicord.nix { inherit pkgs inputs; };

  mpv = import ./mpv.nix { inherit pkgs; };

  parsec-bin = import ./parsec.nix { inherit pkgs; };

  vivaldi = import ./vivaldi.nix { inherit pkgs inputs; };
}
