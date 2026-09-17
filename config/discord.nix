{ inputs', overrides, ... }:

{
  environment.systemPackages = [
    (inputs'.nixcord.packages.discord.override {
      inherit (overrides) equicord;
      withEquicord = true;
    })
  ];
}
