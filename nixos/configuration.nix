# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <unstable> { config.allowUnfree = true; };
in
{
  imports =
    [
      <home-manager/nixos>
      # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      version = 2;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
    };
  };

  networking.hostName = "nixos-kd";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.utf8";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "-d";
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org/gnome/desktop/input-sources]
      sources=[('xkb', 'us')]
      xkb-options=['terminate:ctrl_alt_bksp', 'lv3:ralt_switch', 'caps:escape']

      [org/gnome/mutter]
      workspaces-only-on-primary=false

      [org/gnome/desktop/session]
      idle-delay=uint32 0

      [org/gnome/desktop/interface]
      clock-show-weekday=true
      color-scheme='prefer-dark'
      enable-animations=false
      enable-hot-corners=false

      [org/gnome/settings-daemon/plugins/color]
      night-light-enabled=true
      night-light-schedule-automatic=false
      night-light-schedule-from=0.0
      night-light-schedule-to=23.983333333333334
      night-light-temperature=uint32 3121

      [org/gnome/settings-daemon/plugins/media-keys]
      custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']
      www=['<Super>b']

      [org/gnome/desktop/wm/preferences]
      button-layout='appmenu:minimize,maximize,close'

      [org/gnome/desktop/wm/keybindings]
      close=['<Super>q']
      switch-applications=@as []
      switch-applications-backward=@as []
      switch-windows=['<Alt>Tab']
      switch-windows-backward=['<Shift><Alt>Tab']

      [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0]
      binding='<Super>m'
      command='code'
      name='launch_vscode'

      [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1]
      binding='<Super>Return'
      command='tilix'
      name='launch_terminal'

      [org/gnome/shell]
      disabled-extensions=['places-menu@gnome-shell-extensions.gcampax.github.com', 'native-window-placement@gnome-shell-extensions.gcampax.github.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com']
      enabled-extensions=['workspace-indicator@gnome-shell-extensions.gcampax.github.com', 'drive-menu@gnome-shell-extensions.gcampax.github.com', 'pop-shell@system76.com']

      [org/gnome/shell/extensions/pop-shell]
      active-hint=true
      gap-inner=uint32 0
      gap-outer=uint32 0
      show-title=false
      tile-by-default=true
      tile-enter=['''''']

      [org/gnome/shell/app-switcher]
      current-workspace-only=true

      [com/gexperts/Tilix]
      background-image-mode='tile'
      enable-wide-handle=true
      prompt-on-close=true
      sidebar-on-right=false
      tab-position='top'
      terminal-title-style='none'
      theme-variant='dark'
      use-tabs=true
      window-save-state=true

      [com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d]
      default-size-columns=140
      default-size-rows=40
      draw-margin=72
      font='Monospace 15'
      scrollback-unlimited=true
      terminal-bell='none'
      use-system-font=false
      visible-name='Default'
    '';
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "us";
    xkbVariant = "";
  };

  # nvidia driver stuffs
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kd = {
    isNormalUser = true;
    description = "Khoi Trinh";
    extraGroups = [ "networkmanager" "wheel" "dialout" "libvirtd" ];
  };
  home-manager.users.kd = { pkgs, ... }: {
    programs.bash = {
      enable = true;
      bashrcExtra = (builtins.readFile ./bash/shell_init.sh);
    };

    programs.git = {
      enable = true;
      userName = "khoitd1997";
      userEmail = "khoidinhtrinh@gmail.com";

      lfs = {
        enable = true;
      };

      difftastic = {
        enable = true;
        background = "dark";
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    neovim
    nixpkgs-fmt
    curl
    sshpass
    wget
    fd
    tio
    bat
    ncdu
    fzf
    ripgrep
    tldr
    tig
    hexyl
    youtube-dl
    pylint
    openocd
    qt5Full
    strace
    lshw
    moreutils
    jq
    doxygen
    htop
    nettools
    neofetch
    hyperfine
    tree
    gawk
    ansible

    # Java
    jdk

    # C++
    gcc
    clang
    clang-tools
    bloaty
    cppcheck
    cpplint
    cmake
    cmake-format
    ninja
    clang-analyzer
    gcc-arm-embedded
    perf-tools
    lttng-tools

    # Python
    python3Full
    black
    python-language-server
    pylint

    # Haskell
    ghc

    # virtualization
    qemu_full
    virt-manager

    # GUI apps
    gparted
    flameshot
    qtcreator
    kicad
    unstable.vscode # always use newest vscode
    cura
    kdenlive
    wireshark
    tilix
    firefox-wayland

    # latex
    texlive.combined.scheme-full

    # gnome stuffs
    gnome3.gnome-tweaks
    gnome.adwaita-icon-theme
    gnomeExtensions.pop-shell
  ];

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

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
  system.stateVersion = "22.05"; # Did you read the comment?

}
