{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    # layer rules
    layerrule = let
      toRegex = list: let
        elements = lib.concatStringsSep "|" list;
      in "^(${elements})$";

      lowopacity = [
        "bar"
        "notifications"
        "osd"
        "logout_dialog"
      ];

      highopacity = [
        "calendar"
        "system-menu"
        "anyrun"
        "logout_dialog"
      ];

      blurred = lib.concatLists [
        lowopacity
        highopacity
      ];
    in [
      "blur, waybar"
      "blur, ${toRegex blurred}"
      "xray 1, ${toRegex ["bar"]}"
      "ignorealpha 0.5, ${toRegex (highopacity ++ ["music"])}"
      "ignorealpha 0.2, ${toRegex lowopacity}"
    ];

    windowrule = let
      f = regex: "float, ^(${regex})$";
    in [
      "noborder,^(rofi)$"
      "center,^(rofi)$"
      (f "org.gnome.Calculator")
      (f "org.gnome.design.Palette")
      (f "pavucontrol")
      (f "nm-connection-editor")
      (f "Color Picker")
      (f "xdg-desktop-portal")
      (f "xdg-desktop-portal-gnome")
      (f "de.haeckerfelix.Fragments")
      (f "com.github.Aylur.ags")
    ];

    # window rules
    windowrulev2 = [
      # fix xwayland apps
      "rounding 0, xwayland:1"

      # disable shadows when only one window is present
      "noshadow, onworkspace:w[t1]"

      # telegram media viewer
      "float, title:^(Media viewer)$"

      # 1Password
      "float, title:(1Password)"
      "center, title:(1Password)"

      # make Firefox PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # idle inhibit while watching videos
      "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
      "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      # make some windows floating
      "dimaround, class:^(gcr-prompter)$"
      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

      # JetBrains IDEs
      "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
      "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"
      "opacity 0.90 0.90, class:^(.*jetbrains.*)$"

      # VS Code
      "opacity 0.90 0.90, title:(.*)(Visual Studio Code)$"
    ];
  };
}
