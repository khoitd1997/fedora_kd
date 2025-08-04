{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , ...
    }@attrs: {
      nixosConfigurations.nixos-kd = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./configuration.nix
          ({ ... }: {
            nixpkgs.overlays = [
              (
                _: _: {
                  unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                }
              )
            ];
          })
        ];
      };
    };
}
