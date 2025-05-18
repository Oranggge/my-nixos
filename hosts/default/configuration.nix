# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

#imports = [ <home-manager/nixos> ];
system.autoUpgrade = {
  enable = true;
  flake = inputs.self.outPath;
  flags = [
    "--update-input"
    "nixpkgs"
    "-L" # print build logs
  ];
  dates = "02:00";
  randomizedDelaySec = "45min";
};


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
#  networking.networkmanager.dns = "none";
#  networking.nameservers = [ "1.1.1.1" "1.0.0.1"];

  networking = {
    nameservers = [ "127.0.0.1" "::1" "1.1.1.1" ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
  };

 services.dnscrypt-proxy2 = {
    enable = true;
    # Settings reference:
    # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      # Add this to test if dnscrypt-proxy is actually used to resolve DNS requests
      query_log.file = "/var/log/dnscrypt-proxy/query.log";
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      server_names = [ "doh.appliedprivacy.net"  ];
    };
  };

  networking.wg-quick.interfaces.wg0.configFile = "/etc/wireguard/wg0.conf";



  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixi = {
    isNormalUser = true;
    description = "nixi";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  home-manager = {
     extraSpecialArgs = { inherit inputs;};
     users = {
      "nixi" = import ./home.nix;
      };
    };

  # Enable automatic login for the user.
  services.getty.autologinUser = "nixi";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #virtualbox
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pdfgrep
    openconnect
    orca-slicer
    bambu-studio
    cura-appimage
    gnumake
    #keymapp
    # to be able to edit the keyboard layout here what needed to do:
    #nix-shell -p xorg.xhost
    #[nix-shell:~]$ xhost +SI:localuser:root
    # sudo keymapp
    wget
    #neovim
    ngrok
    gnugrep
    igrep
    xplugd
    git
    firefox
    kitty
    waybar
    mako
    grim
    slurp
    wl-clipboard

    xdg-desktop-portal
    xdg-desktop-portal-wlr
    arandr
    autorandr
    xorg.xrandr

    python39
    ollama
    protege
    jq
    pdftk
    poppler-utils
    zotero
    texlive.combined.scheme-full
  ];

   virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "nixi" ];

   virtualisation.docker.enable = true;
#   users.users.nixi.extraGroups = [ "docker" ];


   services.dbus.enable = true;
# smt for bash scripts
   services.envfs.enable = true;

   
#  programs.xwayland.enable = true;  # Just in case


  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
  "text/html" = "org.qutebrowser.qutebrowser.desktop";
  "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
  "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
  "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
  "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
};


    # Enable the gnome-keyring secrets vault. 
    # Will be exposed through DBus to programs willing to store secrets.
#   services.gnome.gnome-keyring.enable = true;

#   environment.variables = {
#    # Force Wayland for Electron Apps (Obsidian, Anydesk, Discord, VSCode, etc.)
#    NIXOS_OZONE_WL = "1";
#    ELECTRON_OZONE_PLATFORM_HINT = "auto";
#
#    # Wayland for Qt Applications
#    QT_QPA_PLATFORM = "wayland";
#    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
#
#    # Wayland for GTK Applications
##    GDK_BACKEND = "wayland";
#
#    # Enable Wayland portals (for file pickers, copy-paste, etc.)
#    GTK_USE_PORTAL = "1";
#  };

  # Enable XWayland (for compatibility)
  #services.xserver.enable = true;
  #services.xdg-desktop-portal.enable = true;


  # yprland; ly is display manager
  services.displayManager.ly.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };


  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 
   services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };


#  programs.hyprland = {
#  enable = true;
#  xwayland.enable = true;
#  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
#  };

#  nix.settings = {
#    substituters = ["https://hyprland.cachix.org"];
#    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
#  };

# maybe to run executable 
#programs.appimage.enable = true;
#programs.appimage.binfmt = true;
#programs.appimage.package = pkgs.appimage-run.override { extraPkgs = pkgs: [ pkgs.libthai ]; };
#
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # nixos helper
    programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos/";
  };

 # xdg.portal = {
 # enable = true;
 # extraPortals = with pkgs; [
 #   xdg-desktop-portal-wlr
 #   xdg-desktop-portal-gtk
 # ];
#  wlr = {
#    enable = true;
#    settings = { # uninteresting for this problem, for completeness only
#      screencast = {
#        output_name = "eDP-1";
#        max_fps = 30;
#        chooser_type = "simple";
#        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
#      };
#    };
#  };
#};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
