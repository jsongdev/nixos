{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    dotnet-sdk
    gcc
    love
    neovim
    nodejs
    python314
    rustup
    vscode-fhs

  ];
}