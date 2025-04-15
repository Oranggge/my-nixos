{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/2c8d3f48";


     home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
     };

#      hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      neovim-flake.url = "github:jordanisaacs/neovim-flake";

  };


  outputs = { self, nixpkgs, home-manager, neovim-flake, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};

      modules = [
        ./hosts/default/configuration.nix
        # inputs.home-manager.nixosModules.default
	home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nixi = import ./hosts/default/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
      ];
    };
  };
}
