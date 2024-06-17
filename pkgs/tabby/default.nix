{
  lib,
  stdenv,
  fetchFromGitHub,
  mkYarnPackage,
  fetchYarnDeps,
}: let
  executableName = "tabby";
  version = "1.0.207";
in
  mkYarnPackage rec {
    name = "${executableName}-${version}";
    pname = executableName;
    inherit version;

    src = fetchFromGitHub {
      owner = "Eugeny";
      repo = "tabby";
      rev = "v${version}";
      hash = "sha256-5vsHYf1+4KNC3RzXhp1eLhwdPRsqj04ArMTr6wLPJC4=";
    };

    offlineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = "sha256-4fLsijF0WA6W1fCV8z9aCsd5DNgh0BgiAzC9Hp6WVUw=";
    };

    packageJSON = ./package.json;

    meta = with lib; {
      description = "A terminal for a more modern age";
      homepage = "https://github.com/Eugeny/tabby";
      license = licenses.mit;
      maintainers = with maintainers; [];
      mainProgram = "tabby";
      platforms = platforms.all;
    };
  }
