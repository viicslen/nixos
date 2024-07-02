{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  feature = "kde";
  cfg = config.features.${feature};
in {
  options.features.${feature} = {
    enable = mkEnableOption (mdDoc feature);

    enableSddm = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable the SDDM window manager";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.enable = mkDefault true;
    services.xserver.desktopManager.plasma6.enable = true;

    services.xserver.displayManager.sddm = mkIf cfg.enableSddm {
      enable = true;
      wayland.enable = true;
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
    ];
  };
}
