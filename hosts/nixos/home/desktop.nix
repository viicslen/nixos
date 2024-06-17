{
  lib,
  user,
  pkgs,
  config,
  ...
}: {
  home.file."jetbrains-webstorm.desktop" = {
    source = ./desktop/jetbrains-webstorm.desktop;
    target = ".local/share/applications/jetbrains-webstorm.desktop";
  };

  home.file."jetbrains-datagrip.desktop" = {
    source = ./desktop/jetbrains-datagrip.desktop;
    target = ".local/share/applications/jetbrains-datagrip.desktop";
  };

  home.file."ray.desktop" = {
    source = ./desktop/ray.desktop;
    target = ".local/share/applications/ray.desktop";
  };

  home.file."tinkerwell.desktop" = {
    source = ./desktop/tinkerwell.desktop;
    target = ".local/share/applications/tinkerwell.desktop";
  };

  xdg = {
    enable = true;

    desktopEntries.firefox-direct = {
      name = "Firefox (Direct)";
      genericName = "Web Browser";
      exec = "${pkgs.mullvad}/bin/mullvad-exclude ${pkgs.firefox}/bin/firefox %U";
      terminal = false;
      categories = ["Application" "Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml"];
      settings = {
        StartupWMClass = "firefox";
      };
    };

    desktopEntries.phpstorm = {
      name = "PhpStorm";
      genericName = "PHP IDE";
      comment = "The Lightning-Smart PHP IDE";
      exec = "${pkgs.bash}/bin/bash /home/${user}/.local/share/JetBrains/Toolbox/scripts/PhpStorm %U";
      icon = "/home/${user}/.local/share/JetBrains/Toolbox/apps/phpstorm/bin/phpstorm.svg";
      categories = ["Development" "IDE"];
      terminal = false;
      settings = {
        StartupWMClass = "jetbrains-phpstorm";
      };
    };

    desktopEntries.lan-mouse = {
      name = "Lan Mouse";
      genericName = "KVM";
      exec = "/etc/profiles/per-user/neoscode/bin/lan-mouse %U";
      icon = "lan-mouse";
      terminal = false;
      settings = {
        StartupWMClass = "lan-mouse";
      };
    };
  };
}
