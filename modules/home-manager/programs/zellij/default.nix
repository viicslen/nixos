{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  name = "zellij";
  namespace = "features";

  cfg = config.${namespace}.${name};
in {
  options.${namespace}.${name}.enable = mkEnableOption (mdDoc "zellij");

  config = {
    programs.zellij = {
      enable = true;

      settings = {
        ui = {
          pane_frames = {
            rounded_corners = true;
          };
        };
      };
    };

    xdg.configFile."zellij/layouts/default.kdl".text = ''
      layout {
        default_tab_template {
          children
          pane size=1 borderless=true {
            plugin location="file:${pkgs.inputs.zjstatus.default}/bin/zjstatus.wasm" {
              format_left  "{mode}#[fg=black,bg=blue,bold]{session}  #[fg=blue,bg=#181825]{tabs}"
              format_right "{swap_layout}#[fg=#181825,bg=#b1bbfa]{datetime}"
              format_space "#[bg=#181825]"

              hide_frame_for_single_pane "true"

              mode_normal  "#[bg=blue] "

              tab_normal              "#[fg=#181825,bg=#4C4C59] #[fg=#000000,bg=#4C4C59]{index}  {name} #[fg=#4C4C59,bg=#181825]"
              tab_normal_fullscreen   "#[fg=#6C7086,bg=#181825] {index} {name} [] "
              tab_normal_sync         "#[fg=#6C7086,bg=#181825] {index} {name} <> "
              tab_active              "#[fg=#181825,bg=#ffffff,bold,italic] {index}  {name} #[fg=#ffffff,bg=#181825]"
              tab_active_fullscreen   "#[fg=#9399B2,bg=#181825,bold,italic] {index} {name} [] "
              tab_active_sync         "#[fg=#9399B2,bg=#181825,bold,italic] {index} {name} <> "


              datetime          "#[fg=#6C7086,bg=#b1bbfa,bold] {format} "
              datetime_format   "%A, %d %b %Y %H:%M"
              datetime_timezone "America/New_York"
            }
          }
        }
      }
    '';
  };
}