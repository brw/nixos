{ pkgs, ffmpeg }: pkgs.mpv-unwrapped.override { inherit ffmpeg; }
