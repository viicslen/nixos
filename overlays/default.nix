# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  # Make Microsoft-Edge not be shit on Wayland
  # Feed it libGL
  microsoft-edge-wayland = final: _prev: {
      microsoft-edge-wayland = _prev.symlinkJoin {
        name = "microsoft-edge-wayland";
        paths = [ _prev.microsoft-edge ];
        buildInputs = [ _prev.makeWrapper ];
        postBuild = ''
           wrapProgram $out/bin/microsoft-edge \
           --prefix LD_LIBRARY_PATH : "${_prev.libGL}/lib" \
           --add-flags "--enable-features=UseOzonePlatform" \
           --add-flags "--ozone-platform=wayland"
           '';
      };
    };
}
