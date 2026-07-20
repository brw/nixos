{
  _class = "nixos";

  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./cli-tools.nix
    ./desktop-apps.nix
    ./dev.nix
    ./discord.nix
    ./gaming.nix
    ./gnome-desktop.nix
    ./hardware.nix
    ./keylightd.nix
    ./locale.nix
    ./media.nix
    ./networking.nix
    ./nix.nix
    ./overrides.nix
    ./shell.nix
    ./ssh.nix
    ./swap.nix
    ./system.nix
    ./tailscale.nix
    ./users.nix
    ./virtualisation.nix
    ./waydroid.nix
  ];

  system.stateVersion = "26.05";
}
