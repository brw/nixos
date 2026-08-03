{
  inputs = {
    # nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # TODO: replace with something like https://github.com/katrinafyi/nix-patcher
    # nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    # nixpkgs-patcher.url = "/home/bas/git/nixpkgs-patcher";
    nixpkgs-patcher.url = "github:brw/nixpkgs-patcher/tmp";
    # rip Yorhel :(
    nixpkgs-patch-ncdu = {
      url = "https://github.com/NixOS/nixpkgs/pull/537648.diff";
      flake = false;
    };
    nixpkgs-patch-ghostty = {
      url = "https://github.com/NixOS/nixpkgs/pull/545447.diff";
      flake = false;
    };

    nix-output-monitor.url = "github:maralorn/nix-output-monitor";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-index-database.url = "github:nix-community/nix-index-database";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    completeDiscordQuest-src = {
      url = "github:nicola02nb/completeDiscordQuest";
      flake = false;
    };

    nautilus-raw-thumbnails = {
      url = "github:stackcoder/nixos-nautilus-raw-thumbnails";
      flake = false;
    };

    vivaldi-repo-amd64 = {
      url = "https://repo.vivaldi.com/archive/deb/dists/stable/main/binary-amd64/Packages";
      flake = false;
    };
    vivaldi-repo-arm64 = {
      url = "https://repo.vivaldi.com/archive/deb/dists/stable/main/binary-arm64/Packages";
      flake = false;
    };

    nh.url = "github:nix-community/nh";

    nixos-cli.url = "github:nix-community/nixos-cli";

    direnv-instant.url = "github:Mic92/direnv-instant";

    llm-agents.url = "github:numtide/llm-agents.nix";

    fast-nix-gc.url = "github:Mic92/fast-nix-gc";

    # config-lsp.url = "github:Myzel394/config-lsp";
    config-lsp.url = "github:brw/config-lsp";

    # equicord-src = {
    #   url = "github:Equicord/Equicord";
    #   flake = false;
    # };

    tg.url = "github:alyraffauf/tg";

    nix-hyperfine.url = "github:Mic92/nix-hyperfine";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-patcher,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forAllSystems =
        fn:
        lib.genAttrs systems (
          system:
          fn (
            import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "intel-media-sdk-23.2.2"
                ];
              };
            }
          )
        );

      hasNixpkgsPatches = lib.any (name: lib.match "nixpkgs-patch-.*" name != null) (
        lib.attrNames inputs
      );

      mkNixosSystem = if hasNixpkgsPatches then nixpkgs-patcher.lib.nixosSystem else lib.nixosSystem;
    in
    {
      nixosConfigurations.bamibal = mkNixosSystem (
        {
          modules = [
            ./hardware-configuration.nix
            ./config
            inputs.nix-index-database.nixosModules.default
            inputs.nix-gaming.nixosModules.platformOptimizations
            inputs.nixos-cli.nixosModules.nixos-cli
            inputs.direnv-instant.nixosModules.direnv-instant
            inputs.fast-nix-gc.nixosModules.default
            (
              { config, ... }:
              {
                _module.args = rec {
                  inputs' = lib.mapAttrs (
                    _: lib.mapAttrs (_: v: v.${config.nixpkgs.hostPlatform.system} or v)
                  ) inputs;
                  self' = inputs'.self;
                  pkgs' = self'.packages;
                };
              }
            )
          ];
          specialArgs = { inherit inputs self; };
        }
        // lib.optionalAttrs hasNixpkgsPatches {
          nixpkgsPatcher = {
            inherit inputs;
            enableTroubleshootingShell = false;
            setNixpkgsFlakeSourceToPatched = true;
          };
        }
      );

      packages = forAllSystems (pkgs: import ./pkgs { inherit pkgs inputs; });
    };
}
