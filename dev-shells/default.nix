{
  inputs,
  system,
  ...
}: {
  laravel = import ./laravel.nix {inherit inputs system;};
  kubernetes = import ./kubernetes.nix {inherit inputs system;};
  python = import ./python.nix {inherit inputs system;};
}
