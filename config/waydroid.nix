{ pkgs, ... }:

{
  virtualisation.waydroid.enable = true;

  environment.systemPackages = [ pkgs.waydroid-helper ];

  systemd.packages = [ pkgs.waydroid-helper ];
}
