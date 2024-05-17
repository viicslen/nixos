{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  user,
  ...
}: {
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
    handbrake
    sesh
    clutter
    clutter-gtk

    # Devices
    solaar
    openrgb-with-all-plugins

    # Development
    vscode
    obsidian
    warp-terminal
    jetbrains-toolbox
    jetbrains.phpstorm
    jetbrains.datagrip
    jetbrains.webstorm
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
    nix-dev = "nix develop path:.";
    ds = "dev-shell";
    dsl = "dev-shell laravel";
    dsk = "dev-shell kubernetes";
  };

  features = {
    docker = {
      enable = true;
      inherit user;
      allowTcpPorts = [
        # Traefik
        80
        443
        8080

        # PHPStorm Xdebug
        9003

        # Portainer
        9443

        # MySQL
        3306

        # Ray
        23517
      ];
    };

    hyprland = {
      enable = true;
      inherit user;
    };

    mullvad = {
      enableExludeIPs = true;
      excludedIPs = [
        # Nivoda
        "172.66.43.155"
        "172.66.40.101"
        "104.26.4.176"
        "172.67.68.183"
        "104.26.5.176"
        "108.139.10.82"
        "108.139.10.70"
        "108.139.10.74"
        "108.139.10.67"
      ];
    };

    network.hosts = {
      # Docker
      "kubernetes.docker.internal" = "127.0.0.1";
      "host.docker.internal" = "127.0.0.1";

      # Remote
      "webapps" = "50.116.36.170";
      "storesites" = "23.239.17.196";

      # Development
      "home.local" = "127.0.0.1";
      "buggregator.local" = "127.0.0.1";
      "portainer.local" = "127.0.0.1";
      "phpmyadmin.local" = "127.0.0.1";
      "selldiam.test" = "127.0.0.1";
      "mylisterhub.test" = "127.0.0.1";
    };
  };

  # virtualisation.oci-containers.containers = {
  #   traefik = {
  #     image = "traefik:v2.10";
  #     cmd = [
  #       "--providers.docker"
  #       "--api.insecure=true"
  #       "--entryPoints.web.address=:80"
  #       "--entryPoints.websecure.address=:443"
  #       "--providers.file.directory=/etc/traefik/conf"
  #       "--providers.file.watch=true"
  #       "--metrics.prometheus=true"
  #       "--accesslog=true"
  #     ];
  #     ports = [
  #       "80:80"
  #       "443:443"
  #       "8080:8080"
  #     ];
  #     volumes = [
  #       "/var/run/docker.sock:/var/run/docker.sock"
  #     ];
  #     labels = [
  #       "traefik.http.routers.http-catchall.rule=hostregexp(`{host:.+}`)"
  #       "traefik.http.routers.http-catchall.entrypoints=web"
  #       "traefik.http.routers.http-catchall.middlewares=redirect-to-https"
  #       "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https"
  #     ];
  #     extraOptions = [
  #       "--network=takeout"
  #     ];
  #   };
  # };
}
