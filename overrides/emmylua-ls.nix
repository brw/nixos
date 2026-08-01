{
  pkgs,
  lib ? pkgs.lib,
}:
let
  version = "0.25.1";
  srcHash = "sha256-wxVbjKHcid5rG4Y2xpq9AKu/T6tg8JGFfciChqvmUDo=";
  cargoHash = "sha256-MAMHJDzU7WRfsl4IQ6eKt1mc1e90s2RQG8fwE8Ay3qc=";
in
if lib.versionOlder pkgs.emmylua-ls.version version then
  pkgs.emmylua-ls.overrideAttrs (prevAttrs: {
    inherit version;

    src = prevAttrs.src.overrideAttrs {
      hash = srcHash;
    };

    cargoDeps = prevAttrs.cargoDeps.overrideAttrs (prevAttrs: {
      vendorStaging = prevAttrs.vendorStaging.overrideAttrs {
        outputHash = cargoHash;
      };
    });
  })
else
  pkgs.emmylua-ls
