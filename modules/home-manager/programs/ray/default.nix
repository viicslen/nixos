{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  name = "ray";
  namespace = "programs";
  version = "2.8.1";

  cfg = config.modules.${namespace}.${name};
  appImage = pkgs.appimageTools.wrapType2 {
    inherit version;
    pname = name;
    src = pkgs.fetchurl {
      url = "https://ray-app.s3.eu-west-1.amazonaws.com/Ray-${version}.AppImage";
      hash = "sha256-anRuLgD9mlCYOUcFC07hfbu6j/gsT1+a2eibYykieOI=";
    };
  };
in {
  options.modules.${namespace}.${name} = {
    enable = mkEnableOption (mdDoc name);
  };

  config = mkIf cfg.enable {
    home.packages = [
      appImage
    ];

    xdg = {
      enable = mkDefault true;

      desktopEntries.${name} = {
        name = "Ray";
        genericName = "Debugging Tool";
        exec = "${appImage}/bin/${name} %U";
        icon = name;
        terminal = false;
        comment = "Ray is a tool for debugging and profiling your PHP applications.";
        categories = ["Development"];
        settings = {
          StartupWMClass = name;
        };
      };
    };
  };
}
