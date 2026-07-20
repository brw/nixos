{ pkgs }:
pkgs.emmylua-ls.overrideAttrs (prevAttrs: {
  version = "0.24.0";
  src = prevAttrs.src.overrideAttrs {
    hash = "sha256-oijk0SFTjpIak9AetBfctMXJ/72bRGjuaib9adx1yac=";
  };
  cargoDeps = prevAttrs.cargoDeps.overrideAttrs (prevAttrs: {
    vendorStaging = prevAttrs.vendorStaging.overrideAttrs {
      outputHash = "sha256-8uzkj7uCV3XzdagsrePwt2DE4MV12xlbwsaBONUymFQ=";
    };
  });
})
