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
      ./gnome/gnome.nix
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

    nixpkgs.config = {
      allowUnfree = true;
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

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        yzhang.markdown-all-in-one
        dhall.dhall-lang
        dhall.vscode-dhall-lsp-server
        haskell.haskell
        justusadam.language-haskell
        ms-vscode-remote.remote-ssh
        ms-vscode.hexeditor
        ms-vscode.cpptools
        twxs.cmake
        ms-vscode.cmake-tools
        ms-python.python
        ms-python.vscode-pylance
        yzhang.markdown-all-in-one
        shd101wyy.markdown-preview-enhanced
        eamodio.gitlens
        github.vscode-pull-request-github
        donjayamanne.githistory
        mhutchie.git-graph
        jnoortheen.nix-ide
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "theme-monokai-pro-vscode";
          publisher = "monokai";
          version = "1.2.0";
          sha256 = "08z5zalc3y9j89sxav254bx5j606ym7g8dlc49yf53i0srj1bnjs";
        }
        {
          name = "intellij-idea-keybindings";
          publisher = "k--kato";
          version = "1.5.4";
          sha256 = "1y759wa4rz2n5a1cjpbj7q0n52932pv30ymhvisq9zva1cwp04yx";
        }
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    neovim
    nixpkgs-fmt
    stress-ng
    curl
    sshpass
    cabal2nix
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
    duf
    du-dust
    broot

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
    # ghc
    # haskellPackages.cabal-install
    # haskellPackages.stack
    # haskell-language-server

    # dhall
    dhall
    dhall-lsp-server

    # virtualization
    qemu_full
    virt-manager

    # GUI apps
    gparted
    flameshot
    qtcreator
    kicad
    cura
    kdenlive
    wireshark
    konsole
    firefox-wayland

    # latex
    texlive.combined.scheme-full
  ];

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  programs.ssh = {
    startAgent = true;
  };
  environment.variables.SSH_ASKPASS_REQUIRE = "prefer";
  environment.etc = {
    "xdg/autostart/ssh-add.desktop".text = ''
      [Desktop Entry]
      Exec=ssh-add -q
      Name=ssh-add
      Type=Application
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
