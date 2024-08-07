{pkgs, ...}: {
  programs.zsh = {
    enable = true;

    shellAliases = {
      cat = "bat";
      vim = "nvim";
      ts = "tmux-session";
      ds = "dev-shell";
      dsl = "dev-shell laravel";
      dsk = "dev-shell kubernetes";
      o = "xdg-open";
    };

    shellInit = ''
      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      elif [ -f "/etc/profiles/per-user/neoscode/etc/profile.d/hm-session-vars.sh" ]; then
        . "/etc/profiles/per-user/neoscode/etc/profile.d/hm-session-vars.sh"
      fi
    '';
  };

  users.defaultUserShell = pkgs.zsh;
}
