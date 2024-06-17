{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./scripts.nix
    ./app-images.nix
  ];

  environment.systemPackages = with pkgs; [
    neovim
    vimPlugins.nvim-fzf
    wget
    curl
    git
    fzf
    lshw
    chezmoi
    lsd
    bat
    solaar
    delta
    ripgrep
    microsoft-edge-wayland
    slack
    gh
    unzip
    libreoffice-fresh
    evtest
    libinput
    tangram
    endeavour
    handbrake
    unstable.mailspring
    wl-clipboard
    libgcc
    gcc13
    gimp
    insomnia
    libsecret
    nix-alien
    nix-init
    gcc
    zig
    fzf
    jq
    qemu
    quickemu
    quickgui
    openlens
    mysql80
    skypeforlinux
    drawing
    bc
    gtop
    libgtop
    tmux
    zoxide
    gnumake
    cmake
    redisinsight

    # Development
    unstable.vscode
    unstable.obsidian
    unstable.warp-terminal
    unstable.jetbrains-toolbox
    drawio
    mysql-workbench
    siege
    k6
    pgadmin4-desktopmode
    mkcert
    nodejs_20
    corepack_20
  ];

  programs = {
    firefox.enable = true;
  };
}
