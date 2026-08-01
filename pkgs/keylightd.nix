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
buildGoModule (finalAttrs: {
  pname = "keylightd";

  src = fetchFromGitHub {
    owner = "jmylchreest";
    repo = "keylightd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pa8zKmqaal3Ys8LoVSviKeqsi5x50GjSB8PLJkqMpE4=";
  };

  version = "0.1.9";

  vendorHash = "sha256-8+9kyyvJ9jJciDx+rPmtfSsGmPhBY6qI/eGDpeJ/ES0=";

  env = {
    CGO_ENABLED = 0;

    npmDeps = fetchNpmDeps {
      src = "${finalAttrs.src}/contrib/keylightd-tray/frontend";
      hash = "sha256-Q4MRYuxy3qV2GUrfdw7SzbuflaV7A4Fr7w1cQV5LXMY=";
    };

    npmRoot = "contrib/keylightd-tray/frontend";
  };

  nativeBuildInputs = [
    # wails
    # pkg-config
    # npmHooks.npmConfigHook
  ];

  # buildInputs = [ webkitgtk_4_1 ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.buildDate=1970-01-01T00:00:00Z"
  ];

  subPackages = [
    "cmd/keylightd"
    "cmd/keylightctl"
  ];

  passthru = {
    inherit (finalAttrs) npmDeps;
  };

  meta = {
    description = "Daemon and CLI for Elgato Key Lights";
    homepage = "https://github.com/jmylchreest/keylightd";
    license = lib.licenses.mit;
    mainProgram = "keylightd";
  };
})
