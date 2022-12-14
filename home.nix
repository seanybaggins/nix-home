# vim: tabstop=2 shiftwidth=2 expandtab
{ config, pkgs, lib, ... }:
{

  # Home Manager needs a bit of information about you aknd the
  # paths it should manage.
  home.username = "deck";
  home.homeDirectory = "/home/deck";

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

  home.file.".config/nvim/coc-settings.json" = {
    text = import ./coc/coc.nix pkgs;
  };

  home.shellAliases = {
    la = "ls -a";
    ll = "ls -l";
    lla = "ls -la";
    ls = "exa";
    tmux = "tmux -2";
    vim = "nvim";
  };

  home.packages = [
    pkgs.alacritty
    pkgs.bat
    pkgs.bear
    pkgs.cargo
    pkgs.clang
    pkgs.clang-tools
    pkgs.clippy
    pkgs.davinci-resolve
    pkgs.delta
    pkgs.docker
    pkgs.exa
    pkgs.fzf
    pkgs.htop
    pkgs.meslo-lgs-nf
    pkgs.neofetch
    pkgs.pentablet-driver
    pkgs.ripgrep
    pkgs.rust-analyzer
    pkgs.rustc
    pkgs.rustfmt
    pkgs.tldr
    pkgs.tmux
    pkgs.tree
    pkgs.vlc
    pkgs.wget
    pkgs.xsel
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

  programs.neovim = {
    enable = true;
    extraConfig = import ./nvim/init.vim.nix;
    plugins = with pkgs.vimPlugins; [
      #aosp-vim
      #delta
      #omnisharp-vim' # for C# language support
      ale # for Error corrections in C#
      auto-pairs
      coc-nvim
      coc-clangd
      coc-rust-analyzer
      fzf-vim
      lightline-vim
      nerdtree
      nerdtree-git-plugin
      python-syntax
      rust-vim
      tabular
      vim-fish
      vim-fugitive
      vim-highlightedyank
      vim-markdown
      vim-matchup
      vim-nerdtree-syntax-highlight
      vim-nix
      vim-repeat
      vim-rooter
      vim-surround
      vim-toml
      vim-yaml
      vim-devicons
    ];
    withNodeJs = true;
    withPython3 = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = import ./tmux/tmux.nix;
  };

  programs.git = {
    enable = true;
    userName = "Sean Link";
    userEmail = "sean.link@netally.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR="nvim";
    VISUAL="nvim";
    MANPAGER="sh -c 'col -bx | bat -l man -p'";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
