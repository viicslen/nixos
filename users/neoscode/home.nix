{
  user,
  name,
}: {
  lib,
  pkgs,
  config,
  ...
}: {
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    packages = import ./packages.nix { inherit pkgs; };

    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };
  };

  programs = {
    carapace.enable = true;
    thefuck.enable = true;
    zoxide.enable = true;
    k9s.enable = true;

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      extensions = [pkgs.gh-copilot];
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    hstr = {
      enable = true;
      enableZshIntegration = true;
    };

    ssh = {
      enable = true;
      controlPath = "/home/${user}/.ssh/controlmasters/%r@%h:%p";
      matchBlocks = {
        "FmTod" = {
          hostname = "webapps";
          user = "fmtod";
        };

        "SellDiam" = {
          hostname = "webapps";
          user = "inventory";
        };

        "DOS" = {
          hostname = "storesites";
          user = "dostov";
        };

        "BLVD" = {
          hostname = "storesites";
          user = "diamondblvd";
        };

        "EXB" = {
          hostname = "storesites";
          user = "extrabrilliant";
        };

        "DTC" = {
          hostname = "storesites";
          user = "diamondtraces";
        };

        "NFC" = {
          hostname = "storesites";
          user = "naturalfacet";
        };

        "TJD" = {
          hostname = "storesites";
          user = "tiffanyjonesdesigns";
        };

        "47DD" = {
          hostname = "storesites";
          user = "47diamonddistrict";
        };

        "PELA" = {
          hostname = "storesites";
          user = "pelagrino";
        };
      };
    };

    git = {
      enable = true;
      delta.enable = true;
      userName = name;
      userEmail = "39545521+viicslen@users.noreply.github.com";
      aliases = {
        nah = ''!f(){ git reset --hard; git clean -df; if [ -d ".git/rebase-apply" ] || [ -d ".git/rebase-merge" ]; then git rebase --abort; fi; }; f'';
        forget = "!git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D";
        forgetlist = "!git fetch -p && git branch -vv | awk '/: gone]/{print $1}'";
        uncommit = "reset --soft HEAD~0";
      };
      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
        web.browser = "microsoft-edge";
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJk8lwwP7GnxZMgpx+C30i/Lw912BBoFccz4gjek8lCX";
      };
    };

    nvchad = {
      enable = false;
      backup = false;
      extraPackages = with pkgs; [
        nixd
        python3
        php83
        php83Packages.composer
        docker-compose-language-service
        dockerfile-language-server-nodejs
        nodePackages.bash-language-server
        stable.nodePackages.volar
      ];
    };
  };

  modules = {
    programs = {
      zsh.enable = true;
      ray.enable = true;
      tmux.enable = true;
      aider.enable = true;
      tmate.enable = true;
      kitty.enable = true;
      atuin.enable = true;
      ghostty.enable = true;
      nushell.enable = true;
      starship.enable = true;
      tinkerwell.enable = true;
      nvf.enable = true;
      sesh = {
        enable = true;
        enableNushellIntegration = true;
        enableTmuxIntegration = true;
      };
    };

    functionality.impermanence = {
      enable = true;
      share = [
        "Steam"
        "JetBrains"
        "keyrings"
        "direnv"
        "zoxide"
        "mkcert"
        "pnpm"
        "nvim"
        "atuin"
      ];
      config = [
        "Lens"
        "Code"
        "Slack"
        "Insomnia"
        "JetBrains"
        "1Password"
        "Tinkerwell"
        "Mullvad VPN"
        "GitHub Desktop"
        "microsoft-edge"
        "github-copilot"
        "tinkerwell"
        "composer"
        "discord"
        "legcord"
        "direnv"
        "gcloud"
        "helm"
        "op"
      ];
      cache = [
        "JetBrains"
        "starship"
        "carapace"
        "zoxide"
        "atuin"
        "helm"
      ];
      directories = [
        ".pki"
        ".ssh"
        ".zen"
        ".kube"
        ".java"
        ".gnupg"
        ".steam"
        ".nixops"
        ".vscode"
        ".docker"
        ".mozilla"
        ".thunderbird"
        ".tmux/resurrect"
      ];
      files = [
        ".env.aider"
        ".gitconfig"
        ".ideavimrc"
        ".zsh_history"
        ".wakatime.cfg"
        ".config/background"
        ".config/monitors.xml"
      ];
    };
  };

  xdg = {
    configFile."gh/hosts.yml".source = (pkgs.formats.yaml {}).generate "hosts.yml" {
      "github.com" = {
        user = "viicslen";
        git_protocol = "https";
        users = {
          viicslen = "";
        };
      };
    };

    mimeApps = {
      enable = true;
      associations.added = {
        "text/html" = "org.gnome.Epiphany.desktop;microsoft-edge.desktop";
        "application/xhtml+xml" = "org.gnome.Epiphany.desktop;microsoft-edge.desktop";
        "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
        "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";
        "x-scheme-handler/http" = "org.gnome.Epiphany.desktop;microsoft-edge.desktop";
        "x-scheme-handler/https" = "org.gnome.Epiphany.desktop;microsoft-edge.desktop";
        "x-scheme-handler/mailto" = "org.gnome.Geary.desktop";
      };
      defaultApplications = {
        "text/html" = "microsoft-edge.desktop";
        "application/xhtml+xml" = "microsoft-edge.desktop";
        "x-scheme-handler/http" = "microsoft-edge.desktop";
        "x-scheme-handler/https" = "microsoft-edge.desktop";
        "x-scheme-handler/mailto" = "org.gnome.Geary.desktop";
      };
    };
  };

  home.file."/home/neoscode/.config/mimeapps.list".force = lib.mkForce true;

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "microsoft-edge.desktop"
        "phpstorm.desktop"
        "ghostty.desktop"
        "legcord.desktop"
      ];
    };

    "org/gnome/shell/extensions/arcmenu" = {
      menu-button-border-color = lib.hm.gvariant.mkTuple [true "transparent"];
      menu-button-border-radius = lib.hm.gvariant.mkTuple [true 10];
    };

    "org/gnome/desktop/wm/preferences".button-layout = lib.mkForce ":minimize,maximize,close";
  };
}
