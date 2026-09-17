{
  pkgs,
  inputs',
  config,
  ...
}:

{
  nixpkgs.config = {
    allowUnfree = true;

    permittedInsecurePackages = [
      "intel-media-sdk-23.2.2" # sorry for my old ass laptop i guess
    ];

    # i long for the day this becomes the default
    # fetchedSourceNameDefault = "versioned";

    # don't think i need this
    allowAliases = false;
  };

  # nixpkgs.overlays = [
  #   # (_: _: {
  #   #   nix = pkgs.lixPackageSets.latest.lix;
  #   # })
  #   (_: _: inputs'.izlix.packages)
  # ];

  environment.systemPackages =
    with pkgs;
    [
      inputs'.nix-output-monitor.packages.default
      nix-diff
      hydra-check
      flake-edit
      cachix
      nurl
      nix-update
      nix-prefetch-scripts
      nixpkgs-reviewFull
      dix
      inputs'.fast-nix-gc.packages.default
      nix-tree
      inputs'.nix-hyperfine.packages.default
      nix-init
      (writeShellApplication {
        name = "ns";
        runtimeInputs = [
          fzf
          nix-search-tv
        ];
        text = builtins.readFile "${nix-search-tv.src}/nixpkgs.sh";
      })
    ]
    ++ lib.optionals (pkgs ? nix-graph) [ nix-graph ];

  nix = {
    # begone !
    channel.enable = false;

    registry = {
      n.to = {
        type = "indirect";
        id = "nixpkgs";
      };
    };

    settings = {
      extra-experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      keep-derivations = true;
      keep-outputs = true;
      keep-going = true;
      # i had this as true but i didn't realize that build directories never get garbage collected
      keep-failed = false;

      auto-optimise-store = true;

      # idk if i really need this but it seems nice i guess
      use-xdg-base-directories = true;

      show-trace = true;

      # i know it's slow to have so many substituters but building from source is slower
      # (i also know it's insecure but oh well, trade-offs when you don't have much compute)
      # TODO: https://github.com/manic-systems/ncro
      substituters = [ "https://nixos-cache-proxy.cofob.dev" ];
      extra-substituters = [
        # "https://cache.bas.sh"
        "https://nix-community.cachix.org"
        "https://install.determinate.systems"
        "https://watersucks.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://cache.numtide.com"
        "https://isabelroses.cachix.org"
        "https://cache.thalheim.io"
        "https://attic.xuyh0120.win/lantian"
        # "ssh-ng://nix.bas.sh&max-connections=10&compress=true"
        # "ssh-ng://nix.bas.sh?priority=100&compress=true"
        # "ssh-ng://eu.nixbuild.net&compress=true"
      ];

      extra-trusted-substituters = [
        "https://bas.cachix.org"
        "https://cache.lix.systems"
      ];

      extra-trusted-public-keys = [
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        # "cache.bas.sh:HR5UV8Png8fmmG1vCPHmNHyV+lwZPjP3Sk/BjxfGOFk="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "bas.cachix.org-1:LblbDYEqJwBSbBnM4y+uFbBXItBUuvOIYFnr23MYtBk="
        "nixbuild.net/5WVSYG-1:5B/h8LjKqcxNnNU4fYpWPoDjhEffgeVRzi24UIUjhxs="
        "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nix.bas.sh:ufdeOGRzoAuOUJ7kV+A5xkKZ71dB3PgmmOfFjWwL9mI="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "cache.thalheim.io-1:R7msbosLEZKrxk/lKxf9BTjOOH7Ax3H0Qj0/6wiHOgc="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "isabelroses.cachix.org-1:mXdV/CMcPDaiTmkQ7/4+MzChpOe6Cb97njKmBQQmLPM="
      ];

      trusted-users = [ "@wheel" ];

      http3 = true;
      http-connections = 0;
      max-substitution-jobs = 256;

      # i don't care !
      warn-dirty = false;

      builders-use-substitutes = true;

      # already have btrfs compression so don't think i need this
      compress-build-log = false;

      # detsys nix
      lazy-trees = true;
      eval-cores = 0;
    };

    # distributedBuilds = true;
    #
    # buildMachines = [
    #   {
    #     hostName = "nix.bas.sh?max-connections=10&compress=true";
    #     system = "x86_64-linux";
    #     maxJobs = 16;
    #     speedFactor = 100;
    #     protocol = "ssh-ng";
    #     supportedFeatures = [
    #       "nixos-test"
    #       "benchmark"
    #       "big-parallel"
    #       "kvm"
    #       "uid-range"
    #     ];
    #     mandatoryFeatures = [
    #       "big-parallel"
    #     ];
    #   }
    # ];
  };

  programs.nh = {
    enable = true;
    package = inputs'.nh.packages.default;
    flake = "/etc/nixos";
  };

  # services.fast-nix-gc = {
  #   enable = true;
  #   package = inputs'.fast-nix-gc.packages.default;
  #   automatic = true;
  #   dates = "daily";
  #   deleteOlderThan = "7d";
  #   keepRecent = "3d";
  # };
  #
  # services.fast-nix-optimise = {
  #   enable = true;
  #   automatic = true;
  #   dates = "daily";
  # };

  programs.nixos-cli = {
    enable = true;

    package = inputs'.nixos-cli.packages.default.override (old: {
      nix = config.nix.package;
    });

    option-cache.enable = false;

    settings = {
      apply = {
        reexec_as_root = true;
        use_nom = true;
      };
      confirmation = {
        empty = "default-yes";
      };
      differ = {
        query_derivations = true;
        tool = "command";
        command = [ "dix" ];
        # command = [ "nix-diff" ];
      };
    };
  };

  programs.nix-index-database.comma.enable = true;
  programs.nix-index = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };
}
