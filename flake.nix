{
  description = "Tmuxinator configuration for home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      ...
    }:
    {
      homeManagerModules.default = ./lib/tmuxinator.nix;

      lib.constants.layouts = {
        mainVertical = "main-vertical";
        mainHorizontal = "main-horizontal";
        tiled = "tiled";
        evenHorizontal = "even-horizontal";
        evenVertical = "even-vertical";
        wideRightMainVertical = "3f2d,188x53,0,0{46x53,0,0,5,141x53,47,0,9}";
      };
    };
}
