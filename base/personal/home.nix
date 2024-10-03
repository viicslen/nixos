{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  user,
  ...
}: {
  home.autostart = [
    pkgs.mullvad-vpn
  ];

  programs.git = {
    enable = true;
    userName = "Victor R";
    userEmail = "39545521+viicslen@users.noreply.github.com";
  };
}
