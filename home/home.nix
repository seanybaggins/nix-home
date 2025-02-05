# vim: tabstop=2 shiftwidth=2 expandtab
{ inputs, pkgs, system, ... }:
{

  # Home Manager needs a bit of information about you aknd the
  # paths it should manage.
  home.username = "sean";
  home.homeDirectory = "/home/sean";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  nixpkgs.config.allowUnfree = true;

  home.file.".config/nix/nix.conf" = {
    text = ''
      experimental-features = nix-command flakes
    '';
  };

  home.file.".config/nvim/coc-settings.json".source = ./coc/coc-settings.json;
  home.file.".config/nvim/skeletons".source = ./nvim/skeletons;

  home.shellAliases = {
    la = "ls -a";
    ll = "ls -l";
    lla = "ls -la";
    ls = "lsd";
    tmux = "tmux -2";
    vim = "nvim";
    xp-pen = "pentablet-driver";
  };

  # Required for virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home.packages = with pkgs; [
    alacritty
    android-tools
    awscli2
    bat
    bear
    bottles
    brave
    cargo
    clang
    clang-tools
    clippy
    cmake
    cmake-language-server
    docker-compose
    eog
    fd
    fish
    flowkey_dl
    fzf
    gimp-with-plugins
    gnome-calculator
    gnumake
    gnupg
    google-chrome
    gpt4all
    graphviz-nox
    hledger
    hledger-interest
    hledger-utils
    hledger-web
    htop
    inkscape-with-extensions
    inputs.caligula.packages.${system}.default
    inputs.paisa.packages.${system}.default
    jupiter-dock-updater-bin
    keepassxc
    libreoffice-qt # Need to figure out what there is so much lag when compared to
    lsd
    meslo-lgs-nf
    musescore
    neofetch
    networkmanager-openvpn
    nil
    nix-tree
    nixd
    nixos-generators
    nixpkgs-fmt
    nodePackages.bash-language-server
    obs-studio
    obsidian
    packer
    pentablet-driver
    pmccabe
    prismlauncher
    protonvpn-gui
    python3 # For autojump
    python3Packages.black
    remmina
    ripgrep
    rust-analyzer
    rustc
    rustfmt
    saleae-logic-2
    shellcheck
    shfmt
    signal-desktop
    simple-scan
    steam
    steamdeck-firmware
    terraform
    terraform-ls
    tldr
    tmux
    tor-browser
    tree
    trezor-suite
    unzip
    usbutils
    virt-manager
    vlc
    vscode
    wget
    xsel
    yt-dlp
    zip
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history = {
      size = 50000;
      save = 50000;
    };
    initExtra = import ./zsh/zsh_rc.nix pkgs;
    plugins = with pkgs; [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.6.0";
          sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
        };
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
      }
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
      }
    ];
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.neovim = {
    enable = true;
    extraConfig = import ./nvim/init.vim.nix { inherit pkgs; };
    plugins = with pkgs.vimPlugins; [
      #aosp-vim
      #omnisharp-vim' # for C# language support
      ale # for Error corrections in C#
      auto-pairs
      coc-clangd
      coc-json
      coc-nvim
      coc-pyright
      coc-rust-analyzer
      fzf-vim
      lightline-vim
      nerdtree
      nerdtree-git-plugin
      python-syntax
      rust-vim
      tabular
      vim-autoformat
      vim-devicons
      vim-fish
      vim-fugitive
      vim-gitgutter
      vim-highlightedyank
      vim-markdown
      vim-matchup
      vim-nerdtree-syntax-highlight
      vim-nix
      vim-repeat
      vim-rooter
      vim-shellcheck
      vim-surround
      vim-terraform
      vim-tmux-navigator
      vim-toml
      vim-yaml
    ];
    withNodeJs = true;
    withPython3 = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = import ./tmux/tmux.nix;
    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
    ];
  };

  programs.git = {
    enable = true;
    userName = "Sean Link";
    userEmail = "sean.link@lightdeckdx.com";
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = "true";
    };
    delta.enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
