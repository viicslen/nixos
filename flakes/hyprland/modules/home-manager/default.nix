{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./config/settings.nix
    ./config/rules.nix
    ./config/binds.nix

    # ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix

    ./swaync.nix
    ./rofi.nix
    ./wlogout
    ./waybar
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    systemd.variables = ["--all"];

    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
  };

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":";
}