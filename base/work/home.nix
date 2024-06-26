{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  user,
  ...
}: {
  home.packages = with pkgs; [
    microsoft-edge-wayland
    notion-app-enhanced
    appflowy
  ];

  features.lan-mouse.enable = true;

  programs.ray.enable = true;
  programs.tinkerwell.enable = true;
}
