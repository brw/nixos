{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
        FilterDiscoverable = false;
      };
    };
  };

  # systemd.user.services.mpris-proxy.wantedBy = [ "default.target" ];
}
