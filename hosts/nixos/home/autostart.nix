{
  lib,
  pkgs,
  config,
  ...
}: {
  home.file."jetbrains-toolbox.desktop" = {
    source = ./desktop/jetbrains-toolbox.desktop;
    target = ".config/autostart/jetbrains-toolbox.desktop";
  };
}
