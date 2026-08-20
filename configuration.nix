{ config, pkgs, inputs, ... }:

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
services.displayManager.dms-greeter = {
  enable = true;
  compositor = {
    name = "niri";
    customConfig = ''
    '';
  };
  configHome = "/home/jsong";
  configFiles = [
    "/home/jsong/.config/DankMaterialShell/settings.json"
  ];
  logs = {
    save = true; 
    path = "/tmp/dms-greeter.log";
  };
  quickshell.package = pkgs.quickshell;
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
    obs-studio.enable = true;
  };

  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  environment.systemPackages = with pkgs; [
    brightnessctl
    btop
    cava
    cmatrix
    fastfetch
    feh
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
    greetd
    heroic
    hyfetch
    jdk
    kdePackages.dolphin
    kdePackages.kolourpaint
    (kdePackages.qt6ct.overrideAttrs (oldAttrs: {
      buildInputs = (oldAttrs.buildInputs or [ ]) ++ (with kdePackages; [
        kcolorscheme
        kconfig
        kiconthemes
        qtdeclarative
      ]);
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
        kdePackages.extra-cmake-modules
      ];
    }))
    kitty
    krita
    lumafly
    neovim
    olympus
    onlyoffice-desktopeditors
    pipes
    playerctl
    prismlauncher
    qalculate-qt
    rustup
    spotify-player
    udiskie
    unzip
    vesktop
    vscode-fhs
    wezterm
    wget
    xwayland-satellite
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05"; #Don't Touch
}
