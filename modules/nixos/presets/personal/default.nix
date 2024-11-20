{
  pkgs,
  lib,
  ...
}:
with lib; let
  name = "personal";
  namespace = "presets";

  cfg = config.modules.${namespace}.${name};
in {
  options.${namespace}.${name} = {
    enable = mkEnableOption (mdDoc name);
  };

  config = mkIf cfg.enable {
    # Enable Plymouth
    boot.plymouth.enable = true;

    environment.systemPackages = with pkgs; [
      insomnia
      nix-alien
      nix-init
      lens
      skypeforlinux
      kdePackages.kcachegrind
      graphviz
      sesh
      asciinema
      waveterm

      # Devices
      solaar
      openrgb-with-all-plugins

      # GUI Apps
      libreoffice-fresh
      tangram
      endeavour
      drawing
      kooha

      # Development
      vscode
      obsidian
      qownnotes
      mysql-workbench
      drawio

      # Browsers
      pkgs.inputs.zen-browser.default
    ];

    modules.programs = {
      qmk.enable = true;
      mullvad.enable = true;

      onePassword = {
        enable = true;
        gitSignCommits = true;
        allowedCustomBrowsers = [".zen-wrapped"];
      };
    };
  };
}