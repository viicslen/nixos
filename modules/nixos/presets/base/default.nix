{
  pkgs,
  lib,
  ...
}:
with lib; let
  name = "base";
  namespace = "presets";

  cfg = config.modules.${namespace}.${name};
in {
  options.${namespace}.${name} = {
    enable = mkEnableOption (mdDoc name);

    defaultShell = mkPackageOption pkgs "zsh" {};

    flakeLocation = mkOption {
      type = types.path;
      default = "/etc/nixos";
      description = ''
        The location of the flake.
      '';
    };

    fonts = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "JetBrainsMono"
            "DroidSansMono"
          ];
        })
      ];
      description = ''
        The list of fonts to install.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs = {
      # Enable NH for easier system rebuilds
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = lib.mkDefault cfg.flakeLocation;
      };

      # Enable direnv
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # Enable Zsh
      zsh.enable = true;
    };

    services = {
      # Enable CUPS to print documents.
      printing.enable = lib.mkDefault true;

      # Configure keymap in X11
      xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Install fonts
    fonts.packages = cfg.fonts;

    # Set default shell
    users.defaultUserShell = pkgs.zsh;

    # Home Manager
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = {
        inherit inputs outputs;
        stateVersion = config.system.stateVersion;
      };
    };

    environment = {
      # Some useful system packages
      systemPackages = with pkgs;
        [
          libsecret
          nil
          nixd
          wget
          curl
          git
          fzf
          lshw
          lsd
          bat
          ripgrep
          unzip
          jq
          tmux
          zoxide
          htop
          gcc
          glibc
          glib
          just
          gtop
          wmctrl
          lazygit
          busybox
          libinput
          wl-clipboard
        ]
        ++ import ./scripts.nix {
          inherit pkgs;
          flake = cfg.flakeLocation;
        };

      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well, awesome!
      etc =
        lib.mapAttrs' (name: value: {
          name = "nix/path/${name}";
          value.source = value.flake;
        })
        config.nix.registry;

      # Set flake path in environment
      sessionVariables = {
        FLAKE = lib.mkDefault cfg.flakeLocation;
      };
    };

    nixpkgs = {
      # You can add overlays here
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.stable-packages
        outputs.overlays.unstable-packages
        outputs.overlays.flake-inputs

        inputs.nix-alien.overlays.default
        inputs.nixpkgs-wayland.overlay
      ];
      # Configure your nixpkgs instance
      config = {
        # Disable if you don't want unfree packages
        allowUnfree = true;
      };
    };

    nix = {
      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well, awesome!
      nixPath = ["/etc/nix/path"];

      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";

        # Deduplicate and optimize nix store
        auto-optimise-store = true;

        # Use community binary cache
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        # Limit the number of parallel jobs to avoid OOM
        max-jobs = lib.mkDefault 16;
      };

      # Perform garbage collection weekly to maintain low disk usage
      gc = {
        # automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1w";
      };
    };
  };
}