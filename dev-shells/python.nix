{
  inputs,
  system,
  ...
}: let
  pkgs = import inputs.nixpkgs-unstable {
    inherit system;
  };
in
  pkgs.mkShell {
    packages = with pkgs; [
      (pkgs.python3.withPackages (python-pkgs: [
        # python-pkgs.alive-progress
        # python-pkgs.kubernetes
        # python-pkgs.numpy
        # python-pkgs.prometheus-api-client
        # python-pkgs.prometrix
        # python-pkgs.pydantic
        # python-pkgs.slack-sdk
        # python-pkgs.typer
        # python-pkgs.rich
      ]))
    ];

    shellHook = ''
      exec zsh
    '';
  }
