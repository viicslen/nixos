{
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    inputs.vscode-server.nixosModules.default
  ];

  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  networking = {
    hostName = "wsl";
    firewall.enable = mkForce false;
  };

  wsl = {
    enable = true;
    defaultUser = "neoscode";
    interop.register = true;
    docker-desktop.enable = true;
    startMenuLaunchers = true;
    useWindowsDriver = true;
    extraBin = [
      {
        src = lib.getExe pkgs.git;
      }
      {
        src = lib.getExe pkgs.bashInteractive;
      }
    ];
  };

  environment = {
    shellAliases = {
      ssh = "ssh.exe";
      ssh-add = "ssh-add.exe";
    };

    systemPackages = with pkgs; [
      jetbrains.webstorm
      jetbrains.phpstorm
      jetbrains.jdk
    ];
  };

  programs = {
    nix-ld.enable = true;
    git.config.programs.core.sshCommand = "ssh.exe";
  };

  services.vscode-server.enable = true;

  modules = {
    presets = {
      base.enable = true;
      work.enable = true;
      personal.enable = true;
    };

    functionality.theming.enable = true;
    containers.settings.log-driver = "local";
  };
}
