{
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
