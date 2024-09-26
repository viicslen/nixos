{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    bun
    dart-sass
    fd
    brightnessctl
    swww
    pkgs.inputs.matugen.default
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
  ];

  programs.ags = {
    enable = true;
    configDir = ./config;
    extraPackages = with pkgs; [
      accountsservice
    ];
  };

  wayland.windowManager.hyprland.settings = let 
    ags = "ags -b hypr"; 
  in {
    "$launcher" = "${ags} -t launcher";

    exec-once = [
      "killall -q ags -b hypr;sleep .5 && ags -b hypr"
    ];

    bind = [
      "$mod, Tab, exec, ${ags} -t overview"
      "$mod CTRL SHIFT, R, exec, ${ags} quit; ${ags}"
      "$mod, V, exec, cliphist list | ${ags} -t launcher | cliphist decode | wl-copy" # TODO: use ags to show list
      ",XF86PowerOff, exec, ${ags} -r 'powermenu.shutdown()'"
    ];
  };
}