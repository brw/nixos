{
  lib,
  stdenvNoCC,
  inputs,
}:

let
  inherit (inputs.importPnpmLock.legacyPackages.${stdenvNoCC.hostPlatform.system})
    importPnpmLock
    iplConfigHook
    ;

  rawUpdateScript = lib.readFile "${inputs.nixcord}/pkgs/scripts/update-vencord-family.sh";

  updateScript =
    lib.replaceStrings
      [
        ''root_package_json_file="./package.json"''
        ''bun_lock_file="./bun.lock"''
      ]
      [
        ''root_package_json_file="${inputs.nixcord}/package.json"''
        ''bun_lock_file="${inputs.nixcord}/bun.lock"''
      ]
      rawUpdateScript;

  equicordVersion = (lib.fromJSON (lib.readFile "${inputs.equicord}/package.json")).version;
  equicordLastModified = lib.join "-" [
    (lib.substring 0 4 inputs.equicord.lastModifiedDate)
    (lib.substring 4 2 inputs.equicord.lastModifiedDate)
    (lib.substring 6 2 inputs.equicord.lastModifiedDate)
  ];
  equicordRev = inputs.equicord.shortRev;

  version = "${equicordVersion}-${equicordLastModified}-${equicordRev}";
in
inputs.nixcord.packages.${stdenvNoCC.hostPlatform.system}.equicord.overrideAttrs (
  finalAttrs: oldAttrs: {
    # inherit version;
    #
    # src = equicord.outPath;
    #
    # mitmCache = importPnpmLock {
    #   inherit (finalAttrs) pname;
    #
    #   # static string cuz shouldn't the lockfile itself be enough?
    #   version = "lockfile";
    #
    #   lockFile = "${equicord}/pnpm-lock.yaml";
    #
    #   manualEntries = {
    #     "gifenc@https://codeload.github.com/mattdesl/gifenc/tar.gz/64842fca317b112a8590f8fef2bf3825da8f6fe3" =
    #       "sha256-Tw2j23uifvrOlF2DAeitFNcV9MSGxG6Nk+GmOYB/EEU=";
    #   };
    # };
    #
    # nativeBuildInputs =
    #   lib.filter (input: input.pname != "pnpm-config-hook") (oldAttrs.nativeBuildInputs or [ ])
    #   ++ [ iplConfigHook ];

    prePatch = ''
      mkdir -p src/userplugins
      cp -r --no-preserve=mode ${inputs.complete-discord-quest-src} src/userplugins/complete-discord-quest
    '';

    buildPhase = lib.replaceString "--disable-updater" "--disable-updater --dev" oldAttrs.buildPhase;

    # passthru.updateScript = oldAttrs.passthru.updateScript.override {
    #   text = updateScript;
    # };
    #
    # env = (oldAttrs.env or { }) // {
    #   EQUICORD_REMOTE = "Equicord/Equicord";
    #   EQUICORD_HASH = "${equicord.rev}";
    # };
  }
)
