{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "reasonix-desktop";
  version = "1.18.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "esengine";
    repo = "DeepSeek-Reasonix";
    tag = "desktop-v${finalAttrs.version}";
    hash = "sha256-DlWO5/YJO5QIxKYqcqXiiwKy83V8knZ0fzGgY2zoJzw=";
  };

  vendorHash = "sha256-Byt7/DbSHZ+PJ8evWARRQHds/kyuydTyYH98pFwAxNY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.src.rev}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "DeepSeek-native AI coding agent for your terminal. Engineered around prefix-cache stability — leave it running";
    homepage = "https://github.com/esengine/DeepSeek-Reasonix";
    changelog = "https://github.com/esengine/DeepSeek-Reasonix/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "reasonix-desktop";
  };
})
