{ pkgs, inputs', ... }:

{
  programs.steam = {
    enable = true;
    protontricks = {
      enable = true;
    };
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    extraPackages = [ pkgs.adwaita-icon-theme ];
    extest.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
    # package = pkgs.gamescope.overrideAttrs (oldAttrs: {
    #   version = "3.16.23.2";
    #   src = oldAttrs.src.override {
    #     hash = "sha256-deI7Uvb3giBnxGDwa7R+kO8Jb7tv+HxKsuZRmFLBDJk=";
    #   };
    #   patches = oldAttrs.patches ++ [
    #     # pending upstream patch to fix the screenshot output resolution
    #     # https://github.com/ValveSoftware/gamescope/pull/2181
    #     (pkgs.fetchpatch2 {
    #       url = "https://github.com/ValveSoftware/gamescope/commit/4d9f4484909cf43349551d4d9ae6c5bc2f4861af.patch?full_index=1";
    #       hash = "sha256-G0qb/ZeWwOejYNk9+ekmDSzN6KbIY2GDdDPj8kOKBQM=";
    #     })
    #   ];
    # });
  };

  environment.systemPackages = with pkgs; [
    wineWow64Packages.stagingFull
    winetricks
    prismlauncher
    inputs'.nix-gaming.packages.osu-stable
    (inputs'.nix-gaming.packages.osu-lazer-bin.override {
      releaseStream = "tachyon";
    })
    tetrio-desktop
  ];
}
