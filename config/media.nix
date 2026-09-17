{
  pkgs,
  overrides,
  inputs,
  ...
}:

{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  programs.gpu-screen-recorder.enable = true;

  environment.systemPackages = with pkgs; [
    ffmpeg-full
    overrides.mpv
    plex-desktop
    plezy
    (plex-mpv-shim.override (old: {
      python3Packages = old.python3Packages.overrideScope (
        final: prev: {
          mpv =
            (prev.mpv.override {
              inherit (overrides) mpv;
            }).overrideAttrs
              { doInstallCheck = false; };
        }
      );
    }))
    yt-dlp
    streamlink

    # thumbnailers
    ffmpegthumbnailer
    gdk-pixbuf
    libavif
    libheif.bin
    libheif.out
    libjxl
    webp-pixbuf-loader
    gnome-epub-thumbnailer
    gnome-kra-ora-thumbnailer
    f3d
    (pkgs.callPackage inputs.nautilus-raw-thumbnails { })
  ];
}
