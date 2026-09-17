{ pkgs, localPackages, ... }:

{
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      search_mode = "daemon-fuzzy";
      daemon = {
        enabled = true;
        autostart = true; # TODO: get socket activation working instead
      };
    };
  };

  # systemd.user.sockets.atuin-daemon.socketConfig.ListenStream = lib.mkForce "%t/atuin.sock";

  programs.bat.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  environment.systemPackages = with pkgs; [
    starship
    atuin-desktop
    localPackages.fishPlugins.completion-sync
  ];
}
