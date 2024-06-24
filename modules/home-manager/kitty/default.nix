{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.kitty;
in {
  options.features.kitty = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable kitty terminal emulator";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      shellIntegration.enableZshIntegration = true;

      settings = {
        # shell = "zsh -l -c 'tmux attach || tmux'";
        wayland_titlebar_color = "background";
        background_opacity = lib.mkForce "0.5";
        dynamic_background_opacity = true;
        remember_window_size = true;
        background_blur = 5;
      };

      extraConfig = ''
        modify_font cell_height 150%
        modify_font strikethrough_position 150%
      '';
    };
  };
}
