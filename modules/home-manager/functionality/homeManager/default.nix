{
  lib,
  config,
  osConfig,
  ...
}:
with lib; let
  name = "functionality";
  namespace = "home-manager";

  cfg = config.${namespace}.${name};
in {
  options.${namespace}.${name} = {
    overrideBackups = mkEnableOption (mdDoc ''
      Whether to overwrite the backup files created by home-manager.
    '');
  };

  config = {
    home.activation.hmOverrideBackupFiles = cfg.overrideBackups (lib.hm.dag.entryAfter ["checkLinkTargets"] ''
      find ${config.home.homeDirectory} -type f -name "*.${osConfig.home-manager.backupFileExtension}" | while read -r backupFile; do
        originalFile="''${backupFile%.${osConfig.home-manager.backupFileExtension}}"
        if [ -f "$originalFile" ]; then
          rm -f "$backupFile"
        fi
      done
    '');
  };
}
