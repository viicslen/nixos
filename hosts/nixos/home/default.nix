{
  config,
  pkgs,
  lib,
  inputs,
  user,
  ...
}: {
  imports = [
    inputs.lan-mouse.homeManagerModules.default
    ./autostart.nix
    ./desktop.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user;
  home.homeDirectory = "/home/${user}";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.gnomeExtensions.toggle-alacritty
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/<user>/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  # Set the user session paths
  home.sessionPath = [
    "~/.local/share/JetBrains/Toolbox/scripts"
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  programs.lan-mouse = {
    enable = true;
    systemd = true;
    # package = inputs.lan-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default
  };

  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = true;

      shell = {
        program = "zsh";
        args = ["-l" "-c" "tmux attach || tmux"];
      };

      font = {
        offset = {
          y = 0;
          x = 0;
        };
        
        glyph_offset = {
          y = 0;
          x = 0;
        };
      };

      window.startup_mode = "Maximized";
    };
    # ToDo: install alacritty gnome extension
  };

  programs.kitty = {
    enable = true;

    shellIntegration.enableZshIntegration = true;

    settings = {
      remember_window_size = true;
      wayland_titlebar_color = "background";
      shell = "zsh -l -c 'tmux attach || tmux'";
      dynamic_background_opacity = true;
      background_opacity = lib.mkForce "0.9";
      background_blur = 5;
    };

    extraConfig = ''
      modify_font cell_height 150%
      modify_font strikethrough_position 150%
    '';
  };
}
