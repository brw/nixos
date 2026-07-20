# get the latest vivaldi version from the vivaldi-repo input unless a version is specified
# yes it's cursed but i kinda like it
{
  pkgs,
  inputs,
  lib ? pkgs.lib,
  vivaldi ? pkgs.vivaldi,
  stdenvNoCC ? pkgs.stdenvNoCC,
  fetchurl ? pkgs.fetchurl,
  vivaldi-repo-amd64 ? inputs.vivaldi-repo-amd64,
  vivaldi-repo-arm64 ? inputs.vivaldi-repo-arm64,
  version ? null,
  sha256 ? null,
}:
let
  useRepo =
    (version == null && sha256 == null)
    || lib.throwIf (lib.xor version sha256) "version and sha256 must be specified together";

  parseLatest =
    text:
    let
      stanzas = lib.splitString "\n\n" text;
      stableStanza = lib.last (lib.filter (s: lib.hasPrefix "Package: vivaldi-stable" s) stanzas);
    in
    {
      fullVersion = lib.last (lib.match ".*\nVersion: ([^\n]+).*" stableStanza);
      sha256 = lib.last (lib.match ".*\nSHA256: ([^\n]+).*" stableStanza);
    };

  info =
    {
      aarch64-linux = parseLatest (lib.readFile vivaldi-repo-arm64);
      x86_64-linux = parseLatest (lib.readFile vivaldi-repo-amd64);
    }
    .${stdenvNoCC.hostPlatform.system} or (throw "unsupported system");

  ver = if useRepo then info.fullVersion else version;

  cleanVer = lib.head (lib.match "([0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+).*" ver);

  # add -1 suffix if missing
  fullVer = if lib.match ".*-[0-9]+$" ver != null then ver else "${ver}-1";
in
vivaldi.overrideAttrs (
  oldAttrs:
  (lib.optionalAttrs (lib.versionOlder oldAttrs.version cleanVer) {
    version = cleanVer;
    src = fetchurl {
      url = "https://downloads.vivaldi.com/stable/vivaldi-stable_${fullVer}_${oldAttrs.suffix}.deb";
      sha256 = "sha256:${info.sha256}";
    };
  })
)
