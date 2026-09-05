{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    appimage-run
    dotnet-sdk
    gcc
    love
    mono
    neovim
    nodejs
    python314
    rustup
    vscode-fhs
  ];
}