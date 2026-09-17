{ lib, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraSetFlags = [
      "--advertise-exit-node"
      "--accept-routes"
      "--ssh"
    ];
  };

  systemd.services.ethtool-tailscale = {
    description = "ethtool tailscale optimizations";
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      ${lib.getExe' pkgs.iproute2 "ip"} link show enp56s0u1u4 >/dev/null 2>&1 && ${lib.getExe pkgs.ethtool} -K enp56s0u1u4 rx-udp-gro-forwarding on rx-gro-list off
      ${lib.getExe' pkgs.iproute2 "ip"} link show wlo1 >/dev/null 2>&1 && ${lib.getExe pkgs.ethtool} -K wlo1 rx-udp-gro-forwarding on rx-gro-list off
    '';
    before = [ "tailscaled.service" ];
    # after = [ "network-pre.target" ];
    after = [ "network.target" ];
    wantedBy = [ "tailscaled.service" ];
  };
}
