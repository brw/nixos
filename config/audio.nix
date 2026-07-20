{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
    playerctl
    easyeffects
  ];

  services.pipewire = {
    enable = true;

    pulse.enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    extraConfig.pipewire = {
      # "10-airplay" = {
      #   "context.modules" = [
      #     {
      #       name = "libpipewire-module-raop-discover";
      #
      #       args = {
      #         roap.discover-local = true;
      #         raop.latency.ms = 248.16;
      #         stream.rules = [
      #           {
      #             matches = [
      #               { raop.ip = "~.*"; }
      #             ];
      #             actions = {
      #               create-stream = {
      #                 stream.props = {
      #                   media.class = "Audio/Sink";
      #                   sess.latency.msec = "248.16";
      #                 };
      #               };
      #             };
      #           }
      #         ];
      #       };
      #     }
      #   ];
      # };
    };
  };
}
