# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  users,
  ...
}:
with lib; {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
  ];

  system.stateVersion = "25.05";
  home-manager.sharedModules = [./home.nix];

  boot = {
    plymouth.enable = true;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      grub = {
        configurationLimit = 10;
        efiSupport = true;
	      device = "nodev";
      };

      systemd-boot.enable = false;
    };
  };

  networking = {
    hostName = "dostov-dev";
    firewall.enable = mkForce false;
  };

  users.users = {
    dostov = {
      isNormalUser = true;
      description = "dostov";
      extraGroups = ["networkmanager" "wheel"];
    };

    neoscode.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaNSsNMlFN0+bSryhAdcS38d0Egk/M3SvzP4Yb4Wf4H dostov@dostov-dev"
    ];
  };

  services = {
    blueman.enable = true;
    displayManager.gdm.enable = true;
    displayManager.defaultSession = "hyprland-uwsm";

    openssh = {
      enable = true;
      startWhenNeeded = true;
      settings.PasswordAuthentication = true;
    };

    cloudflared = {
      enable = true;
      tunnels = {
        "0998f771c-00d1-4caa-9c82-de93b57c89a0" = {
          credentialsFile = "/home/neoscode/.cloudflared/998f771c-00d1-4caa-9c82-de93b57c89a0.json";
          default = "http_status:404";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    (pkgs.inputs.zen-browser.default.override {
      nativeMessagingHosts = [
        pkgs.firefoxpwa
      ];
      extraPrefsFiles = [
        (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
          sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
        })
      ];
    })
    google-chrome
    vivaldi
    vivaldi-ffmpeg-codecs
    brave

    # IDEs & Editors
    # jetbrains.idea-ultimate
    # jetbrains.phpstorm
    # jetbrains.datagrip
    # jetbrains.webstorm
    # jetbrains.goland
    jetbrains-toolbox
    zed-editor-fhs
    vscode

    # Development Tools
    insomnia
    postman
    lens

    # Notes
    obsidian

    # Communication
    legcord
    discordo

    # Drawing
    drawing
    drawio

    # Office
    onlyoffice-desktopeditors
    freeoffice

    # Misc
    tlrc
    vial
    kooha
    #uv

    (writeShellApplication {
      name = "hyprflow-work";
      runtimeInputs = [ hyprland ];
      text = ''
        ${hyprland}/bin/hyprctl dispatch exec "[workspace 1 silent] zen-beta"
        ${hyprland}/bin/hyprctl dispatch exec "[workspace 11 silent] legcord"
        ${hyprland}/bin/hyprctl dispatch exec "[workspace 11 silent] kitty"
        ${hyprland}/bin/hyprctl dispatch exec "[workspace 12 silent] code"
        ${hyprland}/bin/hyprctl dispatch exec "[workspace 12 silent] kitty"
      '';
      meta.description = "Hyprland workspace setup script for work environment";
    })
  ];

  modules = {
    hardware = {
      intel.enable = true;
      nvidia.enable = true;
      bluetooth.enable = true;
    };

    desktop = {
      gnome = {
        enable = true;
        remoteDesktop = true;
      };

      hyprland = {
        enable = true;
        gnomeCompatibility = true;
        extraGlobalVariables = {
          NVD_BACKEND = "direct";
          LIBVA_DRIVER_NAME = "nvidia";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          __GL_GSYNC_ALLOWED = "0";
          __GL_VRR_ALLOWED = "0";
        };
      };
    };

    functionality = {
      oom.enable = true;
      appImages.enable = true;
      powerManagement.enable = true;


      theming = {
        enable = true;
        disabledTargets = ["chromium"];
      };

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
        "npm.local" = "127.0.0.1";
        "home.local" = "127.0.0.1";
        "soketi.local" = "127.0.0.1";
        "buggregator.local" = "127.0.0.1";
        "portainer.local" = "127.0.0.1";
        "phpmyadmin.local" = "127.0.0.1";

        "selldiam.test" = "127.0.0.1";
        "mylisterhub.test" = "127.0.0.1";
        "vite.mylisterhub.test" = "127.0.0.1";
        "app.mylisterhub.test" = "127.0.0.1";
        "admin.mylisterhub.test" = "127.0.0.1";
        "*.mylisterhub.test" = "127.0.0.1";
        "time-tracker.test" = "127.0.0.1";
        "socket.time-tracker.test" = "127.0.0.1";
      };
    };

    presets = {
      base.enable = true;
      work.enable = true;
      personal.enable = true;
    };

    programs = {
      ld.enable = true;
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
        users = attrNames users;
        allowedCustomBrowsers = [
          ".zen-wrapped"
          "zen"
        ];
      };
    };
  };
}
