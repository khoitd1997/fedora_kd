# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

args@{ config, pkgs, home-manager, ... }:
let
  primary_user = "kd";
  stateVersion = "22.11";
in
{
  imports =
    [
      home-manager.nixosModules.default
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./gnome/gnome.nix
      # ./kde/kde.nix
      # ./xmonad/xmonad.nix
    ];

  home-manager.users.${primary_user} = import ./home-manager.nix (
    args // { inherit primary_user stateVersion; }
  );
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
    };
  };
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos-${primary_user}";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  time = {
    timeZone = "America/Los_Angeles";
    hardwareClockInLocalTime = true;
  };

  i18n.defaultLocale = "en_US.utf8";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        to = {
          owner = "NixOS";
          repo = "nixpkgs/nixos-22.11";
          type = "github";
        };
      };
      home-manager = {
        from = {
          id = "home-manager";
          type = "indirect";
        };
        to = {
          owner = "nix-community";
          repo = "home-manager";
          type = "github";
        };
      };
    };
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb = {
      variant = "";
      layout = "us";
    };
  };
  programs.zsh.enable = true;

  # nvidia driver stuffs
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

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
  users.users.${primary_user} = {
    isNormalUser = true;
    description = "Khoi Trinh";
    extraGroups = [ "networkmanager" "wheel" "dialout" "libvirtd" "docker" ];
    shell = pkgs.zsh;
  };
  # fix /etc/shells not having zsh problem
  environment.shells = with pkgs; [ zsh ];

  # Allow unfree packages
  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-25.9.0" # for obsidian
    ];
    allowUnfree = true;
  };

  virtualisation.vmware.host.enable = true;

  environment.systemPackages = with pkgs; [
    # some nix commands like flake need git
    git
    git-lfs

    # Java
    jdk

    gnome.gnome-terminal
    kitty
    firefox-wayland
    orca-slicer
    openscad
    betaflight-configurator
    xorg.xkill
  ];
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  programs.ssh = {
    startAgent = true;
  };
  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
    # https://github.com/tauri-apps/tauri/issues/9304
    # TODO:remove once, the fix the above for orca-slicer is no longer required
    WEBKIT_DISABLE_DMABUF_RENDERER= "1";
  };
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
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = stateVersion; # Did you read the comment?
}
