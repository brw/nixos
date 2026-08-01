{ pkgs, inputs }:
rec {
  emmylua-ls = import ./emmylua-ls.nix { inherit pkgs; };

  equicord = import ./equicord.nix { inherit pkgs inputs; };

  ffmpeg = import ./ffmpeg.nix { inherit pkgs; };

  mpv = import ./mpv.nix {
    inherit pkgs mpv-unwrapped;
  };

  mpv-unwrapped = import ./mpv-unwrapped.nix {
    inherit pkgs ffmpeg;
  };

  parsec-bin = import ./parsec.nix { inherit pkgs; };

  vivaldi = import ./vivaldi.nix { inherit pkgs inputs; };
}
