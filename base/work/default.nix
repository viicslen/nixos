{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  user,
  ...
}: let
  phpWithExtensions = pkgs.php.buildEnv {
    extensions = {
      enabled,
      all,
    }:
      enabled
      ++ (with all; [
        xdebug
        imagick
        redis
      ]);
    extraConfig = ''
      memory_limit=-1
      max_execution_time=0
    '';
  };
in {
  home-manager.users.${user} = import ./home.nix;

  # Lan Mouse
  networking.firewall.allowedTCPPorts = [4242];

  environment.systemPackages = with pkgs; [
    # Communication
    slack
    slack-cli
    slack-term
    ripcord

    # Formatters
    delta
    jq

    # Editors
    vimPlugins.nvim-fzf
    jetbrains-toolbox
    jetbrains.idea-ultimate
    jetbrains.phpstorm
    jetbrains.datagrip
    jetbrains.webstorm
    jetbrains.goland
    vscode

    # Build
    libgcc
    gcc13
    gcc
    zig
    bc
    gnumake
    cmake
    luakit
    phpWithExtensions
    phpWithExtensions.packages.composer

    # Tools
    nodejs_20
    corepack_20
    mysql80
    awscli
    meld
    kubectl
    kubernetes-helm
    linode-cli
    dbeaver-bin
    atlas
  ];

  programs.zsh.shellAliases = {
    dep = "composer exec -- dep";
    takeout = "composer global exec -- takeout";
    nix-dev = "nix develop path:.";
  };

  features = {
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
      "npm.local" = "127.0.0.1";
      "portainer.local" = "127.0.0.1";
      "phpmyadmin.local" = "127.0.0.1";
      "selldiam.test" = "127.0.0.1";
      "mylisterhub.test" = "127.0.0.1";
    };

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

    mkcert = {
      enable = true;
      rootCA.enable = false;
      rootCA.users = [user];
    };
  };

  virtualisation.oci-containers.containers = {
    npm = {
      hostname = "npm";
      image = "jc21/nginx-proxy-manager:latest";
      ports = [
        "127.0.0.1:80:80"
        "127.0.0.1:443:443"
        "127.0.0.1:81:81"
      ];
      volumes = [
        "nginx-proxy-manager:/data"
        "letsencrypt:/etc/letsencrypt"
      ];
      extraOptions = [
        "--network=npm"
      ];
    };

    mysql = {
      hostname = "mysql";
      image = "percona/percona-server:latest";
      ports = [
        "127.0.0.1:3306:3306"
      ];
      volumes = [
        "percona-mysql:/var/lib/mysql"
      ];
      environment = {
        MYSQL_ROOT_PASSWORD = "secret";
      };
      extraOptions = [
        "--network=npm"
      ];
    };

    portainer = {
      hostname = "portainer";
      image = "portainer/portainer-ee:latest";
      ports = [
        "127.0.0.1:8000:8000"
        "127.0.0.1:9443:9443"
      ];
      volumes = [
        "portainer:/data"
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
      extraOptions = [
        "--network=npm"
      ];
    };
  };
}
