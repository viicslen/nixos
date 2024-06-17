{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib; let
  cfg = config.features.stylix;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.features.stylix = {
    enable = mkEnableOption (mdDoc "stylix");
    theme = mkOption {
      type = types.str;
      default = "material-darker";
      description = "The base16 theme to use";
    };
    polarity = mkOption {
      type = types.str;
      default = "dark";
      description = "The polarity of the theme";
    };
    wallpaper = mkOption {
      type = types.path;
      default = pkgs.runCommand "image.png" {} ''
        COLOR=$(${pkgs.yq}/bin/yq -r .base00 "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml")
        COLOR="#"$COLOR
        ${pkgs.imagemagick}/bin/magick convert -size 1920x1080 xc:$COLOR $out
      '';
      description = "The wallpaper to use";
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      image = cfg.wallpaper;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";
      polarity = cfg.polarity;

      fonts = {
        monospace = {
          package = (pkgs.nerdfonts.override { fonts = ["FiraCode"]; });
          name = "Fira Code Nerd Font";
        };
      };

      targets = {
        gnome.enable = true;

        plymouth.logo = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/f84c13adae08e860a7c3f76ab3a9bef916d276cc/logo/nix-snowflake-colours.svg";
          sha256 = "pHYa+d5f6MAaY8xWd3lDjhagS+nvwDL3w7zSsQyqH7A=";
        };
      };
    };
  };
}
