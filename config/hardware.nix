{ pkgs, ... }:
{
  hardware.enableAllFirmware = true;

  fileSystems = {
    "/".options = [
      "compress=zstd:1"
      "noatime"
    ];
    "/home".options = [
      "compress=zstd:1"
      "noatime"
    ];
    "/nix".options = [
      "compress=zstd:1"
      "noatime"
    ];
  };

  systemd.services.btrfs-set-dynamic-reclaim = {
    description = "set dynamic reclaim on all btrfs filesystems";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      echo 1 | tee /sys/fs/btrfs/*-*/allocation/data/{dynamic,periodic}_reclaim
    '';
  };

  hardware.block.defaultScheduler = "kyber";
  hardware.block.defaultSchedulerRotational = "mq-deadline";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      intel-media-sdk
      intel-compute-runtime-legacy1
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  hardware.intel-gpu-tools.enable = true;

  hardware.i2c.enable = true;
  # TODO: ddcci-driver broken
  # services.ddccontrol.enable = true;

  hardware.sensor.iio.enable = true;

  services.undervolt = {
    enable = true;
    coreOffset = -125;
  };

  services.fwupd.enable = true;

  services.bpftune.enable = true;

  programs.iotop.enable = true;

  programs.yubikey-manager.enable = true;

  services.keylightd.enable = true;

  environment.systemPackages = with pkgs; [
    (nvtopPackages.intel.override { amd = true; })
    intel-gpu-tools
    ddcutil
    i2c-tools
    throttled
    s-tui
    smartmontools
    nvme-cli
  ];
}
