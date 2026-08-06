{ ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  
  #programs.steam.extraCompatPackages = with pkgs; [
  #  proton-ge-bin
  #];
}
