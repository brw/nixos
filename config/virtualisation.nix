{
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
    # makes it work with containers
    preferStaticEmulators = true;
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };

    podman.enable = true;
  };

  programs.virt-manager.enable = true;
}
