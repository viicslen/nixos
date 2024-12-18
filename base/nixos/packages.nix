{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libsecret
    nil
    nixd
    wget
    curl
    git
    fzf
    lshw
    chezmoi
    lsd
    bat
    ripgrep
    gh
    unzip
    jq
    tmux
    zoxide
    htop
    gcc
    glibc
    glib
    just
    gtop
    wmctrl
    lazygit
    busybox
    libinput
    wl-clipboard
    percona-server
    gnumeric
    libreoffice
    hunspell
    hunspellDicts.en_US

    bluez
    bluez-tools

    blueman
  ];
}
