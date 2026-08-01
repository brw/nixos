{
  pkgs,
  inputs',
  overrides,
  ...
}:
{
  programs.vim.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.nix-ld.enable = true;

  programs.ccache = {
    enable = true;
  };

  services.sysprof.enable = true;

  # programs.sysdig.enable = true;

  # programs.ghidra.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs = {
      enable = true;
      enablePureSSHTransfer = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    settings = {
      global = {
        load_dotenv = true;
        strict_env = true;
        warn_timeout = 0;
      };
      whitelist = {
        prefix = [ "/home/bas/dev/pulumi" ];
      };
    };
  };

  # TODO: https://github.com/Mic92/direnv-instant/issues/114
  # programs.direnv-instant.enable = true;

  environment.systemPackages = with pkgs; [
    tree-sitter
    rustc
    cargo
    gnumake
    stdenv.cc
    go
    nodejs_latest
    python3
    sccache
    overrides.emmylua-ls
    nixd
    nil
    nixfmt-rs
    # vtsls
    typescript-go
    bun
    pnpm
    docker-client
    dockerfmt
    docker-compose-language-service
    docker-language-server
    docker-credential-helpers
    dockerfile-language-server
    stylua
    oxfmt
    oxlint
    tsgolint
    jujutsu
    jj-starship
    jj-fzf
    jjui
    jj-vine
    inputs'.tg.packages.default
    gh
    glab
    delta
    jq
    ijq
    xq-xml
    entr
    shfmt
    shellcheck
    uv
    ty
    ruff
    android-tools
    twitch-cli
    inputs'.llm-agents.packages.reasonix
    inputs'.llm-agents.packages.omp
    inputs'.llm-agents.packages.pi
    just
    just-lsp
    vscode-langservers-extracted
    bash-language-server
    fish-lsp
    actionlint
    gopls
    rust-analyzer
    rustfmt
    vscode-js-debug
    glsl_analyzer
    glslviewer
    postgres-language-server
    gleam
    taplo
    tailwindcss-language-server
    inputs'.config-lsp.packages.default
    superhtml
    zls
  ];
}
