{ pkgs, overrides, ... }:

{
  environment.systemPackages = with pkgs; [
    ghostty
    (overrides.vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs = "--enable-features=AutoPictureInPictureForVideoPlayback,BrowserInitiatedAutomaticPictureInPicture";
    })
    mailspring
    signal-desktop
    equibop
    chatterino2
    libreoffice
    overrides.parsec-bin
    ente-auth
    telegram-desktop
    via
    bitwarden-desktop
    spotify
    spicetify-cli
  ];

  services.udev.packages = [ pkgs.via ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.flatpak = {
    enable = true;
  };
}
