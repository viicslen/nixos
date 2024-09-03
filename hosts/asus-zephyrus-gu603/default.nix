{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  user,
  ...
}:
with lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-gu603h
    inputs.disko.nixosModules.disko
    (import ./disko.nix {device = "/dev/nvme0n1";})
    ./hardware.nix
    ../../base/nixos
    ../../base/personal
    ../../base/work
  ];

  home-manager.users.${user} = import ./home.nix;

  networking.hostId = "86f2c355";
  networking.hostName = "asus-zephyrus-gu603";

  powerManagement.cpuFreqGovernor = "powersave";

  boot = {
    kernelParams = [
      "video=eDP-1-1:2560x1600@165" # Patch for 165hz display
      "intel_iommu=on" # Hardware virtualisation
      "nvidia_drm.fbdev=1" # Nvidia DRM
    ];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libGL
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
        intel-media-driver
      ];
    };

    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
    };

    logitech.wireless.enable = true;
  };

  services = {
    xserver = {
      enable = true;

      exportConfiguration = true;
      displayManager.sessionCommands = ''
        xrandr --newmode "2560x1600_165.00" 1047.00 2560 2800 3080 3600  1600 1603 1609 1763 -hsync +vsync
        xrandr --addmode eDP-1-1 "2560x1600_165.00"
        xrandr --output eDP-1-1 --mode 2560x1600 --rate 165
      '';

      videoDrivers = ["nvidia"];
    };

    supergfxd = {
      enable = true;
      settings = {
        vfio_enable = true;
        vfio_save = true;
        always_reboot = true;
        hotplug_type = "Asus";
      };
    };

    asusd = {
      enable = true;
      enableUserService = true;
    };

    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 90;

        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 0;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
      };
    };

    power-profiles-daemon.enable = false;
  };

  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
    zenith-nvidia
    nvtopPackages.nvidia
    gnomeExtensions.supergfxctl-gex
  ];

  features = {
    oom.enable = true;
    theming.enable = true;
    appImages.enable = true;

    gnome = {
      enable = true;
      inherit user;
      additionalExtensions = [
        pkgs.draw-on-your-screen2
      ];
    };

    impermanence = {
      inherit user;
      enable = true;
      directories = [
        "/etc/mullvad-vpn"
      ];
      home = {
        share = [
          "JetBrains"
          "keyrings"
          "direnv"
          "mkcert"
          "pnpm"
          "nvim"
        ];
        config = [
          "Code"
          "Slack"
          "Insomnia"
          "JetBrains"
          "1Password"
          "Mullvad VPN"
          "microsoft-edge"
          "tinkerwell"
          "composer"
          "traefik"
          "direnv"
          "op"
        ];
        cache = [
          "JetBrains"
        ];
        directories = [
          ".ssh"
          ".nix"
          ".kube"
          ".java"
          ".gnupg"
          ".nixops"
          ".vscode"
          ".docker"
          ".tmux/resurrect"
        ];
        files = [
          ".gitconfig"
          ".zsh_history"
          ".wakatime.cfg"
          ".config/monitors.xml"
        ];
      };
    };
  };

  virtualisation.oci-containers.containers = {
    npm = {
      image = "jc21/nginx-proxy-manager:latest";
      ports = [
        "127.0.0.1:80:80"
        "127.0.0.1:443:443"
        "127.0.0.1:81:81"
      ];
      volumes = [
        "nginx-proxy-manager:/data"
        "letsencrypt:/etc/letsencrypt"
      ];
      extraOptions = [
        "--network=npm"
      ];
    };
  };
}
