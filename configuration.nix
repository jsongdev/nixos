{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./steam.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "jsbox";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users."jsong" = {
    isNormalUser = true;
    description = "Joanne Song";
    extraGroups = [ "networkmanager" "wheel" "sudo" ];
    shell = pkgs.fish;
  };

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024;
  }];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-mono
  ];

  programs = {
    nh = {
      enable = true;
      flake = "/home/jsong/nixos";
    };
    firefox.enable = true;
    fish.enable = true;
    niri.enable = true;
    dms-shell.enable = true;
    dms-shell.systemd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    fastfetch
    git
    hyfetch
    kitty
    lumafly
    neovim
    olympus
    pipes
    prismlauncher
    vesktop
    vscode-fhs
    wget
    xwayland-satellite
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05"; # Don't Touch

}
