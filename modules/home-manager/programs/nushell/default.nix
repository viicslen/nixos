{
  lib,
  config,
  ...
}:
with lib; let
  name = "nushell";
  namespace = "programs";

  cfg = config.modules.${namespace}.${name};
in {
  options.modules.${namespace}.${name} = {
    enable = mkEnableOption (mdDoc "nushell");
  };

  config = mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;

        shellAliases = {
          pn = "pnpm";
          vim = "nvim";
          ts = "tmux-session";
          ds = "dev-shell";
          dsl = "dev-shell laravel";
          dsk = "dev-shell kubernetes";
          o = "xdg-open";
          spf = "search-package-files";

          k = "kubectl";
          kga = "kubectl get all";
          kgp = "kubectl get pods";
          kdp = "kubectl describe pod";
          kcuc = "kubectl config use-context";
          krr = "kubectl rollout restart";

          sail = "sh $([ -f sail ] && echo sail || echo vendor/bin/sail)";
          s = "sail";
          sud = "sail up -d";
          sdown = "sail down";
          sa = "sail artisan";
          sc = "sail composer";
          sp = "sail php";
          sn = "sail npm";
          st = "sail tinker";
          sd = "sail debug";
          sda = "sail debug artisan";
        };

        extraConfig = (builtins.unsafeDiscardStringContext (builtins.readFile ./config.nu));
      };

      # Needed for completions
      fish.enable = true;

      # Integrations
      keychain.enableNushellIntegration = true;
      direnv.enableNushellIntegration = true;
      carapace.enableNushellIntegration = true;
      atuin.enableNushellIntegration = true;
      thefuck.enableNushellIntegration = true;
      zoxide.enableNushellIntegration = true;
      yazi.enableNushellIntegration = true;
    };
  };
}