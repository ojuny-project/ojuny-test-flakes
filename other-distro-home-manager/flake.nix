{
  description = "Ojuny standalone Home Manager test for other Linux distributions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ojuny-desktop = {
      url = "github:ojuny-project/ojuny-desktop";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.stylix.follows = "stylix";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      homeConfig = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home.nix
          inputs.stylix.homeModules.stylix
          inputs.ojuny-desktop.homeManagerModules.default
        ];
      };
    in
    {
      homeConfigurations.user = homeConfig;

      checks.${system}.default = homeConfig.activationPackage;

      formatter.${system} = pkgs.nixfmt;
    };
}
