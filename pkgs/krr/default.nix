{
  lib,
  fetchFromGitHub,
  system,
}: let
  unstable = import (fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "nixpkgs-unstable";
    hash = "sha256-LbbVOliJKTF4Zl2b9salumvdMXuQBr2kuKP5+ZwbYq4=";
  }) {inherit system;};
  pythonPackages = unstable.python311Packages;
in
  pythonPackages.buildPythonApplication rec {
    pname = "krr";
    version = "1.8.2";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "robusta-dev";
      repo = "krr";
      rev = "v${version}";
      hash = "sha256-0CbJwhHC+nn6tabOo4mbLMJWNsHzHFwHvBoJKvsr+Ic=";
    };

    nativeBuildInputs = with pythonPackages; [
      poetry-core
    ];

    propagatedBuildInputs = with pythonPackages; [
      alive-progress
      kubernetes
      numpy
      prometheus-api-client
      prometrix
      pydantic
      slack-sdk
      typer
      rich
    ];

    pythonImportsCheck = ["robusta_krr"];

    meta = with lib; {
      description = "Prometheus-based Kubernetes Resource Recommendations";
      homepage = "https://github.com/robusta-dev/krr";
      license = licenses.mit;
      maintainers = with maintainers; [];
      mainProgram = "krr";
    };
  }
