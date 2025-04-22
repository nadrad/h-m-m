{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems, ... }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
    version = let
      rev = self.shortRev or self.dirtyShortRev or self.lastModified or null;
    in if isNull rev then null else "r${toString rev}";
  in {
    packages = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      h-m-m = pkgs.callPackage ./. { inherit version; };
      default = self.packages.${system}.h-m-m;
    });
    overlays.h-m-m = self: super: {
      h-m-m = self.callPackage ./. { inherit version; };
    };
    overlays.default = self.overlays.h-m-m;
  };
}
