# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, home-manager, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      home-manager.nixosModule
      ./kde/kde.nix
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
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos-kd";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  time = {
    timeZone = "America/Los_Angeles";
    hardwareClockInLocalTime = true;
  };

  i18n.defaultLocale = "en_US.utf8";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "-d";
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
    home = {
      stateVersion = "22.11";
    };

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
    entr
    rnix-lsp
    nixos-option

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
    haskellPackages.cabal-install
    haskellPackages.stack
    haskell-language-server

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
