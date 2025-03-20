# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, users, ... }:

with lib; {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

  home-manager.sharedModules = [./home.nix];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    # hostId = "86f2c355";
    hostName = "dostov-dev";
    firewall.enable = mkForce false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dostov = {
    isNormalUser = true;
    description = "dostov";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

   environment.systemPackages = with pkgs; [
    jetbrains.idea-ultimate
    jetbrains.phpstorm
    jetbrains.datagrip
    jetbrains.webstorm
    jetbrains.goland
    microsoft-edge
    vscode
    lens
    insomnia
    drawing
    kooha
    obsidian
    drawio
  ];

  system.stateVersion = "25.05";


  modules = {
    hardware = {
      intel.enable = true;

      nvidia = {
        enable = true;
        modern = true;
      };
    };

    desktop = {
      gnome.enable = true;

      hyprland = {
        enable = true;
        gnomeCompatibility = true;
      };
    };

    functionality = {
      oom.enable = true;
      theming.enable = true;
      appImages.enable = true;
      powerManagement.enable = true;

      network.hosts = {
        # Docker
        "kubernetes.docker.internal" = "127.0.0.1";
        "host.docker.internal" = "127.0.0.1";

        # Remote
        "webapps" = "50.116.36.170";
        "storesites" = "23.239.17.196";
        "db-prod-master" = "50.116.56.10";
        "db-prod-read" = "50.116.56.249";
        "db-staging-master" = "45.79.180.78";
        "db-staging-read" = "45.79.180.88";

        # Development
        "ai.local" = "127.0.0.1";
        "home.local" = "127.0.0.1";
        "buggregator.local" = "127.0.0.1";
        "npm.local" = "127.0.0.1";
        "portainer.local" = "127.0.0.1";
        "phpmyadmin.local" = "127.0.0.1";
        "selldiam.test" = "127.0.0.1";
        "mylisterhub.test" = "127.0.0.1";
        "app.mylisterhub.test" = "127.0.0.1";
        "admin.mylisterhub.test" = "127.0.0.1";
        "*.mylisterhub.test" = "127.0.0.1";
      };
    };

    presets = {
      base.enable = true;
      work.enable = true;
      personal.enable = true;
    };

    programs = {
      mullvad.enable = true;

      docker = {
        enable = true;
        nvidiaSupport = true;
        allowTcpPorts = [
          # Traefik
          80
          443
          8080

          # PHPStorm Xdebug
          9003

          # Portainer
          9443

          # MySQL
          3306

          # Ray
          23517
        ];
      };

      onePassword = {
        enable = true;
        gitSignCommits = true;
        allowedCustomBrowsers = [
          ".zen-wrapped"
          "zen"
        ];
        users = attrNames users;
      };
    };
  };
}
