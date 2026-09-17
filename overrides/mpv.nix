{ pkgs }:

pkgs.mpv.override (old: {
  scripts = with old.mpvScripts; [
    uosc
    mpris
    thumbfast
  ];

  # necessary for escaping double quotes in the makeWrapper args
  makeBinaryWrapper = pkgs.makeShellWrapper;

  extraMakeWrapperArgs = [
    "--add-flags"
    [
      "--hwdec=auto"
      "--screenshot-format=png"
      "--screenshot-template=\"%F - [%P] (%#01n)\""
      "--vo=gpu-next"
      "--gpu-api=opengl"
      "--save-position-on-quit=yes"
    ]
  ];
})
