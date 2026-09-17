{ pkgs, ... }:

{
  networking.hostName = "bamibal";

  environment.systemPackages = with pkgs; [
    ethtool
    bind
    wsdd
    nload
  ];

  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    # tailscale can't parse this lmao https://github.com/golang/go/issues/36822
    # "1.1"
    "1.0.0.1"
    "8.8.4.4"
    # "2606:4700:4700::1111"
    # "2001:4860:4860::8888"
    # "2606:4700:4700::1001"
    # "2001:4860:4860::8844"
  ];

  # ipv6 has packet loss issues on my stupid ziggo compal modem bleh
  # networking.enableIPv6 = false;
  # boot.kernel.sysctl = {
  #   "net.ipv6.conf.all.disable_ipv6" = true;
  #   "net.ipv6.conf.default.disable_ipv6" = true;
  # };
  # none of the above work. kernel param it is
  # boot.kernelParams = [ "ipv6.disable=1" ];
  # nevermind kernel param breaks keylightd
  # networking.networkmanager.connectionConfig = {
  #   "ipv6.method" = "disabled";
  # };
  # fuck it that doesn't work either just change it for each link using the GUI

  networking.nftables.enable = true;

  programs.mtr.enable = true;

  programs.wireshark = {
    enable = true;
    usbmon.enable = true;
  };

  programs.iftop.enable = true;

  programs.whois.enable = true;
}
