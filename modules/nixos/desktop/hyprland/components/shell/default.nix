{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    (inputs.astal.lib.mkLuaPackage {
      inherit pkgs;
      name = "tokyob0t";
      src = ./tokyob0t;

      extraPackages = with pkgs.inputs.astal; [
        astal3
        io
        apps
        battery
        bluetooth
        hyprland
        mpris
        network
        notifd
        powerprofiles
        tray
        wireplumber
      ];
    })
  ];

  wayland.windowManager.hyprland.settings = let
    shell = "tokyob0t -b hypr";
  in {
    exec-once = [
      "uwsm app -- ${shell}"
    ];

    bindr = [
      "$mod, SUPER_L, exec, ${shell} -t launcher"
    ];

    bind = [
      ",XF86PowerOff, exec, ${shell} -t 'powermenu'"
    ];
  };
}
