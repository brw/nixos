{ pkgs, inputs, ... }:

{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
    kernelModules = [ "ntsync" ];
    blacklistedKernelModules = [ "amdgpu" ]; # TODO: figure out why my dGPU randomly crashes when undocked
    kernelParams = [
      "i915.enable_guc=2"
      "i915.enable_fbc=1"
      # "i915.enable_psr=2"
      "nvme_core.default_ps_max_latency_us=5500" # need this to stop my SSD from crashing
      "processor.ignore_ppc=1"
    ];
  };

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  console.earlySetup = true;
}
