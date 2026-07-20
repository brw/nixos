{
  lib,
  buildGoModule,
  fetchNpmDeps,
  npmHooks,
  fetchFromGitHub,
  wails,
  webkitgtk_4_1,
  pkg-config,
}:
let
  pname = "keylightd";

  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "jmylchreest";
    repo = "keylightd";
    rev = "v${version}";
    hash = "sha256-3DmsYm8ZB2nILBWtgv4vPTw9clKyaSrVlAypwUlAajw=";
  };

  npmDeps = fetchNpmDeps {
    src = "${src}/contrib/keylightd-tray/frontend";
    hash = "sha256-Q4MRYuxy3qV2GUrfdw7SzbuflaV7A4Fr7w1cQV5LXMY=";
  };
  npmRoot = "contrib/keylightd-tray/frontend";
in
buildGoModule (finalAttrs: {
  inherit
    pname
    version
    src
    ;

  vendorHash = "sha256-Odx74tTuufpcvssybAXqYoU5ubem4IvI3lOw5nT2aEo=";

  env = {
    inherit npmDeps npmRoot;
  };

  nativeBuildInputs = [
    wails
    pkg-config
    npmHooks.npmConfigHook
  ];

  buildInputs = [ webkitgtk_4_1 ];

  buildPhase = ''
    runHook preBuild

    make build

    runHook postBuild
  '';

  # installPhase = ''
  #   runHook preInstall
  #   install -Dm755 keylightd "$out/bin/keylightd"
  #   install -Dm755 keylightctl "$out/bin/keylightctl"
  #   runHook postInstall
  # '';

  passthru = {
    inherit npmDeps;
  };

  meta = {
    description = "Daemon and CLI for Elgato Key Lights";
    homepage = "https://github.com/jmylchreest/keylightd";
    license = lib.licenses.mit;
    mainProgram = "keylightctl";
  };
})
