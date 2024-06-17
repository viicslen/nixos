{
  lib,
  pkgs,
  config,
  options,
  ...
}:
with lib; let
  cfg = config.features.gnome;
  homeManagerLoaded = builtins.hasAttr "home-manager" options;
in {
  options.features.gnome = {
    enable = mkEnableOption (mdDoc "gnome");

    user = mkOption {
      type = types.str;
      default = "nixos";
      description = "The user update the settings for";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Enable the GNOME Desktop Environment.
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;

      # Enable GNOME Keyring
      services.gnome.gnome-keyring.enable = true;

      # Exclude GNOME applications from the default install
      environment.gnome.excludePackages =
        (with pkgs; [
          gnome-tour
        ])
        ++ (with pkgs.gnome; [
          gnome-music
          cheese # webcam tool
          tali # poker game
          iagno # go game
          hitori # sudoku game
          atomix # puzzle game
        ]);

      # Enable DConf to tweak desktop settings
      programs.dconf.enable = true;

      # Enable Seahorse to manage keyring
      programs.seahorse.enable = true;

      services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

      # Install GNOME Tweaks
      environment.systemPackages = with pkgs; [
        adw-gtk3
        gnome.gnome-tweaks
        gnome.adwaita-icon-theme
        gnomeExtensions.appindicator
        gnomeExtensions.blur-my-shell
        gnomeExtensions.dash-to-panel
        gnomeExtensions.arcmenu
        gnomeExtensions.user-themes
        gnomeExtensions.autohide-battery
        gnomeExtensions.kube-config
        gnomeExtensions.mullvad-indicator
        gnomeExtensions.supergfxctl-gex
        gnomeExtensions.solaar-extension
        gnomeExtensions.caffeine
        gnomeExtensions.gsconnect
        gnomeExtensions.forge
        gnomeExtensions.arrange-windows
        gnomeExtensions.rounded-corners
      ];
    }
    (mkIf homeManagerLoaded {
      home-manager.users.${cfg.user} = {
        dconf.settings = {
          "org/gnome/mutter".experimental-features = ["scale-monitor-framebuffer"];
          "org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
          "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
      };
    })
  ]);
}
