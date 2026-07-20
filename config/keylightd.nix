{ lib, pkgs', ... }:
{
  environment.systemPackages = [ pkgs'.keylightd ];

  users = {
    users.keylightd = {
      isSystemUser = true;
      group = "keylightd";
      home = "/var/lib/keylightd";
    };
    groups.keylightd = { };
  };

  systemd.services.keylightd = {
    description = "Elgato Key Light daemon";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs'.keylightd;
      Restart = "on-failure";
      RestartSec = "10s";
      User = "keylightd";
      Group = "keylightd";
      StateDirectory = "keylightd";
      RuntimeDirectory = "keylightd";
      RuntimeDirectoryMode = "0775";
      UMask = "0002";
      Environment = [
        "XDG_CONFIG_HOME=/var/lib/keylightd"
        "XDG_RUNTIME_DIR=/run/keylightd"
      ];
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      SystemCallFilter = [ "@system-service" ];
      SystemCallErrorNumber = "EPERM";
    };
  };
}
