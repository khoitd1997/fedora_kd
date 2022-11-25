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

  time = {
    timeZone = "America/Los_Angeles";
    hardwareClockInLocalTime = true;
  };

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
    file

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
