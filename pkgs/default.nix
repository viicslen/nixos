# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # warp-terminal = pkgs.callPackage ./warp-terminal { };
  tabby = pkgs.callPackage ./tabby {};
  krr = pkgs.callPackage ./krr {};
}
