{ pkgs }:
(pkgs.ffmpeg-full.override {
  withUnfree = true;
  withMfx = true;
  withVpl = false;
  withRtmp = true;
}).overrideAttrs
  { doCheck = false; }
