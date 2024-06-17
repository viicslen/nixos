{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (appimageTools.wrapType2 {
      name = "ray";
      src = fetchurl {
        url = "https://ray-app.s3.eu-west-1.amazonaws.com/Ray-2.7.5.AppImage";
        hash = "sha256-DgAzfbFO9XpCjZkeGmBU6B9G8XiVwfTjoHioWL7seX8=";
      };
      extraPkgs = pkgs: with pkgs; [];
    })

    (appimageTools.wrapType2 {
      name = "tinkerwell";
      src = fetchurl {
        url = "https://download.tinkerwell.app/tinkerwell/Tinkerwell-4.10.0.AppImage";
        hash = "sha256-KgE/m6hpIhfVAVJ5SRtFP6RX3FwgSwej77ZQv1B2eOs=";
      };
      extraPkgs = pkgs: with pkgs; [];
    })
  ];
}
