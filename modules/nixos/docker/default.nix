{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.docker;
in {
  options.features.docker = {
    enable = mkEnableOption (mdDoc "docker");

    user = mkOption {
      type = types.str;
      default = "nixos";
      description = "The user to add to the docker group";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    users.users.${cfg.user}.extraGroups = ["docker"];
  };
}
