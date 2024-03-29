# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
  next_version = import ./semver.nix;
in
{
  imports =
    [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./semimak/semimak.nix
      ./fish/fish.nix
      ./maintenance/storage.nix
      ./maintenance/upgrade.nix
      #./hardware/fingerprint.nix
    ];
  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_6_1;
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking and Tailscale
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    xkbOptions = "grp:alt_space_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable and configure tablet drivers
  hardware.opentabletdriver.enable = true;

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

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
  users.users.johnww = {
    isNormalUser = true;
    description = "John Wallace White";
    extraGroups = [ "networkmanager" "wheel" "dialout" "uinput" "input" ];
    packages = with pkgs; [
      cider
      osu-lazer
      opentabletdriver
      neovim
      stack
      logseq
      steam
      wireguard-go
      librewolf
      discord
      gimp
      zoom-us
      vscode
      electron
      libreoffice
      android-studio
      (lutris.override {
        extraLibraries =  pkgs: [
          # List library dependencies here
        ];
      })
    ];
  };


  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    dotnet-sdk
    git
    tailscale
    direnv

    apfs-fuse # APFS for Apple-style drives
    ventoy    # USB Boot Creator
    ddrescue  # Drive Data Recovery
  ];

  # Give steam permissions to play games
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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
  services.openssh.enable = true;

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

