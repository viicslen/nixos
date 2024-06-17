{user, ...}: {
  gnome = {
    enable = true;
    inherit user;
  };

  hyprland = {
    enable = true;
    inherit user;
  };

  virtualMachines = {
    enable = true;
    inherit user;
  };

  onePassword = {
    enable = true;
    inherit user;
  };

  docker = {
    enable = true;
    inherit user;
  };

  network.hosts = {
    # Docker
    "kubernetes.docker.internal" = "127.0.0.1";
    "host.docker.internal" = "127.0.0.1";

    # Remote
    "webapps" = "50.116.36.170";
    "storesites" = "23.239.17.196";

    # Development
    "portainer.local" = "127.0.0.1";
    "phpmyadmin.local" = "127.0.0.1";
    "selldiam.test" = "127.0.0.1";
    "mylisterhub.test" = "127.0.0.1";
    "peppermint.test" = "127.0.0.1";
  };

  mullvad = {
    enable = true;
    excludedIPs = [
      "172.66.43.155"
      "172.66.40.101"
    ];
  };

  stylix.enable = true;
  appImages.enable = true;
}
