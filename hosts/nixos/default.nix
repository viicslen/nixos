# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  user,
  ...
}: {
  # Modules
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.nur.nixosModules.nur
    outputs.nixosModules.gnome
    outputs.nixosModules.sound
    outputs.nixosModules.stylix
    outputs.nixosModules.docker
    outputs.nixosModules.network
    outputs.nixosModules.mullvad
    outputs.nixosModules.hyprland
    outputs.nixosModules.app-images
    outputs.nixosModules.localization
    outputs.nixosModules.one-password
    outputs.nixosModules.virtual-machines
    ./hardware.nix
    ./shell.nix
    ./packages
  ];

  boot = {
    # Bootloader
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 10;
    loader.efi.canTouchEfiVariables = false;

    # Enable Plymouth
    plymouth.enable = true;
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Flatpaks for some applications missing from Nixpkgs
  services.flatpak.enable = true;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.nix-alien.overlays.default
      (self: super: {
        microsoft-edge-wayland = super.symlinkJoin {
          name = "microsoft-edge-wayland";
          paths = [ super.microsoft-edge ];
          buildInputs = [ super.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/microsoft-edge \
            --prefix LD_LIBRARY_PATH : "${super.libGL}/lib" \
            --add-flags "--enable-features=UseOzonePlatform" \
            --add-flags "--ozone-platform=wayland"
            '';
        };
      })
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
    };

    # Perform garbage collection weekly to maintain low disk usage
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  environment.etc =
    lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Victor R";
    extraGroups = ["networkmanager" "wheel" user];
  };

  # Home Manager
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs user;};
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${user} = import ./home;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
      ];
    })
  ];

  # Enable Miscellaneous programs
  programs.direnv.enable = true;
  programs.nix-ld.enable = true;

  # Features
  features = import ./features.nix {inherit user;};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
