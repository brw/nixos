{
  pkgs,
  lib ? pkgs.lib,
}:
let
  parsec-launcher = pkgs.writeShellScript "parsec-launcher" ''
    ${lib.getExe pkgs.parsec-bin} "$@" &
    disown

    PID=$!
    # set wmclass for mutter's xwayland-grab-access-rules
    ${lib.getExe pkgs.xdotool} search --sync --all --pid $PID --name '.*' set_window --classname "parsecd" set_window --class "parsecd"
  '';
in
pkgs.parsec-bin.overrideAttrs (oldAttrs: {
  postFixup = ''
    cp ${parsec-launcher} $out/bin/parsec-launcher

    substituteInPlace $out/share/applications/parsecd.desktop \
      --replace-fail "Exec=parsecd" "Exec=parsec-launcher"
  '';
})
