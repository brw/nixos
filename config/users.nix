{ pkgs, ... }:
{
  users.users."bas" = {
    isNormalUser = true;
    description = "Bas";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "wireshark"
      "keylightd"
      "libvirtd"
    ];
  };
}
