{
  description = "A very basic flake";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, unstable }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import unstable { inherit system; };
      lib = unstable.lib;
    in {
      nixosConfigurations = {
        marknixos = lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [ ./configuration.nix ];
        };
      };
    };
}
