{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    ilya-fedin.url = "github:ilya-fedin/nur-repository";
    ilya-fedin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... } @inputs: {
    nixosConfigurations.jsbox = nixpkgs.lib.nixosSystem {
      system = "x64_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
