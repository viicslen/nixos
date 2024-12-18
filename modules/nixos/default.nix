# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  kde = import ./kde;
  oom = import ./oom;
  qmk = import ./qmk;
  gnome = import ./gnome;
  sound = import ./sound;
  docker = import ./docker;
  mkcert = import ./mkcert;
  podman = import ./podman;
  theming = import ./theming;
  network = import ./network;
  mullvad = import ./mullvad;
  backups = import ./backups;
  hyprland = import ./hyprland;
  containers = import ./containers;
  corepack = import ./corepack;
  app-images = import ./app-images;
  localization = import ./localization;
  impermanence = import ./impermanence;
  one-password = import ./one-password;
  github-runner = import ./github-runner;
  virtual-machines = import ./virtual-machines;
}
