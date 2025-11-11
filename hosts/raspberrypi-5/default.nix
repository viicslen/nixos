{ config, pkgs, lib, ... }: {
    # Hardware specific configuration, see section below for a more complete 
    # list of modules
    imports = with nixos-raspberrypi.nixosModules; [
        raspberry-pi-5.base
        raspberry-pi-5.page-size-16k
        raspberry-pi-5.display-vc4
        raspberry-pi-5.bluetooth
    ];

    networking.hostName = "rpi5";

    nixpkgs = {
      buildPlatform = "x86_64-linux";
      hostPlatform = "aarch64-linux";
    };

    system.nixos.tags = let
      cfg = config.boot.loader.raspberryPi;
    in [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];
}