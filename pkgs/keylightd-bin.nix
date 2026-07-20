{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "0.1.8";

  archives = {
    x86_64-linux = {
      arch = "amd64";
      hash = "sha256-xZ5gNuH5S122sAu4oDGOA61ClSXNjXdftwc1sLXAInA=";
    };
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-2Wr+GD1lp6BYcJbxczSJxrF/QWAeFFUGUTh0qp3hlCc=";
    };
  };

  archive = archives.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit version;
  pname = "keylightd";

  src = fetchurl {
    url = "https://github.com/jmylchreest/keylightd/releases/download/v${finalAttrs.version}/keylightd_${finalAttrs.version}_linux_${archive.arch}.tar.gz";
    inherit (archive) hash;
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 keylightd "$out/bin/keylightd"
    install -Dm755 keylightctl "$out/bin/keylightctl"

    runHook postInstall
  '';

  meta = {
    description = "Daemon and CLI for Elgato Key Lights";
    homepage = "https://github.com/jmylchreest/keylightd";
    license = lib.licenses.mit;
    mainProgram = "keylightctl";
    platforms = lib.attrNames archives;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
