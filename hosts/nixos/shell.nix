{pkgs, ...}: {
  programs.zsh = {
    enable = true;

    shellAliases = {
      cat = "bat";
      dep = "composer exec -- dep";
      takeout = "composer global exec -- takeout";
      nix-dev = "nix develop path:.";
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
