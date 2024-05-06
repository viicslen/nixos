{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  user,
  ...
}:
{
  imports = [
    ../nixos
    ./scripts.nix
  ];

  home-manager.users.${user} = import ./home.nix;

  environment.systemPackages = with pkgs; [
    neovim
    vimPlugins.nvim-fzf
    delta
    slack
    evtest
    libinput
    wl-clipboard
    libgcc
    gcc13
    insomnia
    libsecret
    nix-alien
    nix-init
    gcc
    zig
    jq
    qemu
    quickemu
    quickgui
    openlens
    mysql80
    skypeforlinux
    bc
    gtop
    libgtop
    gnumake
    cmake
    stable.redisinsight
    kdePackages.kcachegrind
    graphviz
    luakit
    # tabby-terminal

    # Development
    vscode
    obsidian
    warp-terminal
    jetbrains-toolbox
    jetbrains.phpstorm
    drawio
    mysql-workbench
    siege
    mkcert
    nodejs_20
    corepack_20

    # Postgres
    postgresql_12
    postgresql_15
    postgresql_16
    pgadmin4-desktopmode
    pgmanage
  ];

  programs.zsh.shellAliases = {
    dep = "composer exec -- dep";
    takeout = "composer global exec -- takeout";
  };

  features = {
    docker = {
      enable = true;
      inherit user;
    };

    virtualMachines = {
      enable = true;
      inherit user;
    };

    mullvad.excludedIPs = [
      "172.66.43.155"
      "172.66.40.101"
    ];

    network.hosts = {
      # Docker
      "kubernetes.docker.internal" = "127.0.0.1";
      "host.docker.internal" = "127.0.0.1";

      # Remote
      "webapps" = "50.116.36.170";
      "storesites" = "23.239.17.196";

      # Development
      "buggregator.local" = "127.0.0.1";
      "portainer.local" = "127.0.0.1";
      "phpmyadmin.local" = "127.0.0.1";
      "selldiam.test" = "127.0.0.1";
      "mylisterhub.test" = "127.0.0.1";
    };
  };
}
