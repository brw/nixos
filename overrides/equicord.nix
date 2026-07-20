{
  pkgs,
  inputs,
  lib ? pkgs.lib,
  stdenvNoCC ? pkgs.stdenvNoCC,
  # writeShellScriptBin ? pkgs.writeShellScriptBin,
  nixcord ? inputs.nixcord,
  completeDiscordQuest-src ? inputs.completeDiscordQuest-src,
}:
let
  rawUpdateScript = lib.readFile "${nixcord.outPath}/pkgs/scripts/update-vencord-family.sh";
  updateScript =
    lib.replaceStrings
      [
        ''root_package_json_file="./package.json"''
        ''bun_lock_file="./bun.lock"''
      ]
      [
        ''root_package_json_file="${nixcord.outPath}/package.json"''
        ''bun_lock_file="${nixcord.outPath}/bun.lock"''
      ]
      rawUpdateScript;
in
nixcord.packages.${stdenvNoCC.hostPlatform.system}.equicord.overrideAttrs (
  finalAttrs: oldAttrs: {
    # src = oldAttrs.src.overrideAttrs {
    #   inherit (oldAttrs.src) owner repo;
    #   rev = "1e353f3bdea3545c198b32c7e2216fcd0b923dbf";
    #   hash = "sha256-dHm/Gp/Gd1Bwnu2jGoCmtOpeZ5fJyHLlj5/YIi3zZ3g=";
    # };
    #
    # version = "2026-07-23-unstable-2026-07-18";
    #
    # pnpmDeps = oldAttrs.pnpmDeps.overrideAttrs {
    #   inherit (finalAttrs)
    #     src
    #     version
    #     patches
    #     pname
    #     ;
    #
    #   hash = "sha256-WdSowp/yuPokdU7Sv/XBQOo/0JPs9AA5LRq6dx57Uyk=";
    # };

    preBuild = ''
      mkdir -p src/userplugins
      cp -r ${completeDiscordQuest-src} src/userplugins/
    '';

    buildPhase =
      lib.replaceStrings [ "--disable-updater" ] [ "--disable-updater --dev" ]
        oldAttrs.buildPhase;

    passthru.updateScript = oldAttrs.passthru.updateScript.override {
      text = updateScript;
    };
  }
)
