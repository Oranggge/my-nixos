{ config, pkgs,inputs,lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nixi";
  home.homeDirectory = "/home/nixi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    imagemagick
    wireguard-tools
    ripgrep-all
    calc
    pandoc
    tetex #need for pandoc to work
    iputils
    code-cursor
    ungoogled-chromium
    libreoffice
    hugo
    go
    dino
    nautilus
    profanity
    wl-clipboard
    discord
    tmux
    librsvg # for pandoc to work
    kickoff
    unzip
    orca-slicer
    bemenu # need for screenshots
    htop
    btop
    swayimg
    acpi # battery show
    swayrbar # bar for sway
    rofi-wayland
    brightnessctl
    anydesk
    obsidian
    wofi
    font-awesome
    alejandra
#    zsh-autosuggestions
    zsh
    oh-my-zsh
    telegram-desktop
#    nwg-displays #as arandr but wland // doesn't work
    wdisplays # also display settings
    kanshi # too
    pavucontrol
    vimPlugins.vim-plug
    fzf
    qrencode
    mpv
    dnscrypt-proxy
    busybox
    


#    wezterm # terminal emulation
    wl-clipboard
    tldr 
    bat
    hyprlock

    qutebrowser
    nfs-utils

    #some stuff for hy3
    cmake
    meson
    cpio
    pkg-config
    #gnumake
    #cpio
    #hyprwayland-scanner
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    nerd-fonts.jetbrains-mono
    helvetica-neue-lt-std
    arkpandora_ttf
    gnome-themes-extra

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nixi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

    programs.wezterm = {
      enable = true;
      # other config...
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = [pkgs.vimPlugins.nvim-tree-lua 
               pkgs.vimPlugins.vim-airline
               pkgs.vimPlugins.vim-airline-themes
               pkgs.vimPlugins.coc-yaml
               pkgs.vimPlugins.vim-smoothie
               pkgs.vimPlugins.gruvbox
               pkgs.vimPlugins.yats-vim
               pkgs.vimPlugins.vim-numbertoggle
               pkgs.vimPlugins.vim-auto-save
               pkgs.vimPlugins.vim-go
               pkgs.vimPlugins.csv-vim
               pkgs.vimPlugins.vim-tmux-navigator];

  };



  programs.fzf.enableZshIntegration = true;

  programs.zsh = {
  enable = true;
  enableCompletion = true;
  #autosuggestions.enable = true;
  autosuggestion.enable = true;



  syntaxHighlighting.enable = true;
      initExtra = ''
      source <(fzf --zsh)
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
      zvm_after_init() {
      bindkey -r '^R'  # Remove zsh-vi-mode binding
      bindkey '^R' fzf-history-widget  # Set fzf history search
    }
    '';


  shellAliases = {
    ll = "ls -l";
    vi = "nvim";
    update = "nh os switch /etc/nixos";
    cat = "bat";
    cop = "wl-copy";
    share = "sharecmd";
  };
  history.size = 10000;

  oh-my-zsh = {
     enable = true;
     plugins = [];
     theme = "agnoster";
     };

};


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
