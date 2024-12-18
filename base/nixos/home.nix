{
  pkgs,
  lib,
  inputs,
  outputs,
  user,
  ...
}: {
  imports =
    [
      inputs.nvchad.homeManagerModule
    ]
    ++ lib.attrsets.mapAttrsToList (name: value: value) outputs.homeManagerModules;

  systemd.user.startServices = "sd-switch";

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";

    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };
  };

  nixpkgs.config = import ./nixpkgs.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

  features.zsh.enable = true;
  features.tmux.enable = true;
  features.zellij.enable = true;

  programs = {
    home-manager.enable = true;

    ssh = {
      enable = true;
      controlPath = "/home/${user}/.ssh/controlmasters/%r@%h:%p";
    };

    git = {
      enable = true;
      delta.enable = true;
      aliases = {
        nah = ''!f(){ git reset --hard; git clean -df; if [ -d ".git/rebase-apply" ] || [ -d ".git/rebase-merge" ]; then git rebase --abort; fi; }; f'';
        forget = "!git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D";
        forgetlist = "!git fetch -p && git branch -vv | awk '/: gone]/{print $1}'";
        uncommit = "reset --soft HEAD~0";
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      extensions = with pkgs; [
        gh-copilot
      ];
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };

    hstr = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    nvchad = {
      enable = true;
      backup = false;
      extraPackages = with pkgs; [
        nixd
        python3
        php83
        php83Packages.composer
        docker-compose-language-service
        dockerfile-language-server-nodejs
        nodePackages.bash-language-server
        stable.nodePackages.volar
      ];
    };
  };
}
