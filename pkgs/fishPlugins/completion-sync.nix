{
  fishPlugins,
  fetchFromGitHub,
}:

fishPlugins.buildFishPlugin {
  pname = "completion-sync";
  version = "0-unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "jemand771";
    repo = "fish-completion-sync";
    rev = "b5ad1d431b1997205a7cb247edbe188ba51547fa";
    sha256 = "sha256-jrI/gnYvrKw0B20Hakur25uWbvF5ncXrhhHB2NtR8Ps=";
  };

  postUnpack = ''
    install -D $src/init.fish $out/functions/completion-sync.fish
  '';

  meta = {
    description = "A fish plugin to help dynamically load fish completions from `$XDG_DATA_DIRS`.";
    homepage = "https://github.com/jemand771/fish-completion-sync";
  };
}
