{ config, pkgs, ... }:
{
	# Set your time zone.
	time.timeZone = "America/Chicago";

	# Add system fonts
	fonts.packages = [
		pkgs.nerdfonts
	];

	# Select internationalisation properties.
	i18n = {
    defaultLocale = "en_US.UTF-8";
	  extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
      };
  };

	# Allow unfree packages and enable Nix Flakes
	nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Tailscale + SSH
  services.openssh.enable = true;
  services.tailscale = {
    enable = true;
    extraSetFlags = [
      "--ssh"
    ];
  };

  # Reuirements for SOPS + age
	environment.systemPackages = with pkgs; [
    sops
    age
  ];
}