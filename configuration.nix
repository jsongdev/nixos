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
  services.udisks2.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General = {
      Experimental = true;
      FastConnectable = true;
    };
    settings.Policy.AutoEnable = true;
  };
  
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
    dms-shell.enable = true;
    dms-shell.systemd.enable = true;
    firefox.enable = true;
    fish.enable = true;
    git = {
      enable = true;
      config = [
        { user.email = "song.johan.2007@gmail.com"; }
        { user.name = "jsdev"; }
      ];
    };
    niri.enable = true;
    nh = {
      enable = true;
      flake = "/home/jsong/nixos";
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    btop
    calibre
    cava
    cmatrix
    fastfetch
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
      pkgs.buildFHSEnv (
        base
        // {
          name = "fhs";
          targetPkgs =
            pkgs:
            (base.targetPkgs pkgs)
            ++ (with pkgs; [
              pkg-config
            ]);
          profile = "export FHS=1";
          runScript = "fish";
          extraOutputsToInstall = [ "dev" ];
        }
      )
    )
    gcc
    gparted
    heroic
    hyfetch
    kdePackages.dolphin
    kdePackages.qt6ct
    kitty
    lumafly
    neovim
    olympus
    pipes
    playerctl
    prismlauncher
    rustup
    spotify-player
    udiskie
    unzip
    vesktop
    vscode-fhs
    wget
    xwayland-satellite
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05"; #Don't Touch
}
