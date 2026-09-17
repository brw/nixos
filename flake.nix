{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    # TODO: replace with something like https://github.com/katrinafyi/nix-patcher
    # nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    # nixpkgs-patcher.url = "/home/bas/git/nixpkgs-patcher";
    nixpkgs-patcher.url = "github:brw/nixpkgs-patcher/tmp";

    nixpkgs-patch-rust-glancer = {
      url = "https://github.com/NixOS/nixpkgs/pull/555434.diff";
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

    complete-discord-quest-src = {
      url = "github:djdoolky76/completeDiscordQuest";
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

    equicord-src = {
      url = "github:Equicord/Equicord";
      flake = false;
    };

    tg.url = "github:alyraffauf/tg";

    nix-hyperfine.url = "github:Mic92/nix-hyperfine";

    nix-bun.url = "github:ryoppippi/nix-bun";

    importPnpmLock = {
      url = "github:scrumplex/importPnpmLock.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    freed-wu-nur = {
      url = "github:Freed-Wu/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # izlix.url = "github:isabelroses/izlix";
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
      nixosConfigurations = {
        bamibal = mkNixosSystem (
          {
            modules = [
              ./hardware-configuration.nix
              ./modules
              ./config
              inputs.determinate.nixosModules.default
              inputs.nix-index-database.nixosModules.default
              inputs.nix-gaming.nixosModules.platformOptimizations
              inputs.nixos-cli.nixosModules.nixos-cli
              inputs.direnv-instant.nixosModules.direnv-instant
              inputs.fast-nix-gc.nixosModules.default
              (
                {
                  config,
                  pkgs,
                  lib,
                  ...
                }:
                {
                  _module.args = rec {
                    inputs' = lib.mapAttrs (
                      _: lib.mapAttrs (_: v: v.${config.nixpkgs.hostPlatform.system} or v)
                    ) inputs;

                    overrides = pkgs.callPackage ./overrides { inherit inputs; };

                    localPackages = (pkgs.callPackage ./pkgs { }) // overrides;
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
      };

      legacyPackages = forAllSystems (pkgs: pkgs.callPackage ./pkgs { });

      packages = self.legacyPackages;
    };
}
