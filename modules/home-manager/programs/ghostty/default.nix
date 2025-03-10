{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  name = "ghostty";
  namespace = "programs";

  cfg = config.modules.${namespace}.${name};
in {
  options.modules.${namespace}.${name} = {
    enable = mkEnableOption (mdDoc name);
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      installVimSyntax = true;
      installBatSyntax = true;
      package = pkgs.inputs.ghostty.default;
      settings = {
        auto-update = "off";

        adjust-cell-height = "35%";
        adjust-cell-width = "5%";
        window-padding-y = 0;
        window-padding-color = "extend";
        window-padding-balance = true;
        confirm-close-surface = "always";
        window-inherit-working-directory = false;
        window-theme = "ghostty";

        gtk-adwaita = true;
        adw-toolbar-style = "raised-border";

        font-family = lib.mkForce [
          config.stylix.fonts.monospace.name
        ];

        keybind = [
          "ctrl+shift+q=close_surface"
          "ctrl+shift+w=toggle_window_decorations"
        ];
      };
    };

    dconf.settings."org/gnome/shell/extensions/blur-my-shell/applications" = {
      whitelist = ["com.mitchellh.ghostty"];
    };
  };
}
