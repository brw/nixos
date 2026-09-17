{
  lib,
  pkgs,
  ...
}:

let
  gsettings = pkgs.writeShellScriptBin "gsettings" ''
    cache=/tmp/gsettings-schema-dirs-$UID
    lockfile=$cache.lock
    current=$(readlink /run/current-system)

    ${lib.getExe' pkgs.util-linux "flock"} "$lockfile" ${pkgs.writeShellScript "gsettings-update-cache" ''
      cache=$1
      current=$2
      if [ -f "$cache" ] && [ "$(head -1 "$cache")" = "$current" ]; then
        exit 0
      fi
      schemas=
      for p in $NIX_PROFILES; do
        [ -d "$p" ] || continue
        for d in $(${lib.getExe' pkgs.nix "nix-store"} --query --requisites "$p" 2>/dev/null); do
          for sd in "$d"/share/gsettings-schemas/*/; do
            [ -d "$sd" ] && schemas="$schemas''${schemas:+:}$sd"
          done
        done
      done
      printf '%s\n%s\n' "$current" "$schemas" > "$cache"
    ''} "$cache" "$current"

    dirs=$(tail -1 "$cache")
    exec env XDG_DATA_DIRS="$dirs" ${lib.getExe' pkgs.glib "gsettings"} "$@"
  '';
in
{
  services.printing.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };

  services.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };
  services.desktopManager.gnome.enable = true;

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
            "hushlog@gagoalaverdyan"
          ];
        };

        "org/gnome/gnome-session" = {
          logout-prompt = false;
        };

        "org/gnome/mutter/wayland" = {
          xwayland-allow-grabs = true;
          xwayland-grab-access-rules = "['parsecd']";
        };
      };
    }
  ];

  qt.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.hack
    hack-font
  ];

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  environment.systemPackages = with pkgs; [
    gsettings
    gnome-tweaks
    dconf-editor
    # inputs'.dconf2nix.packages.default
    gnomeExtensions.appindicator
    gjs
    qadwaitadecorations
    qadwaitadecorations-qt6
    wl-clipboard
    mutter # mainly for gdctl (display control tool)
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;

    # workaround for media file details in nautilus
    # https://github.com/NixOS/nixpkgs/issues/53631
    GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
      with pkgs.gst_all_1;
      [
        gst-plugins-good
        gst-plugins-bad
        gst-plugins-ugly
        gst-libav
      ]
    );

    # workaround for "Settings schema 'org.gtk.Settings.FileChooser' is not installed"
    XDG_DATA_DIRS = [
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    ];
  };
}
