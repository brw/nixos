{
  systemd.coredump.settings.Coredump = {
    Storage = "none";
    ProcessSizeMax = 0;
  };

  security.sudo.extraConfig = ''
    Defaults passwd_timeout=0
  '';

  services.logind.settings.Login = {
    HandleLidSwitch = "sleep";
  };
}
