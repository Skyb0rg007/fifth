{
  description = "Fifth - a FORTH implementation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    hostSystems = [flake-utils.lib.system.x86_64-linux];
    crossSystem = nixpkgs.lib.systems.examples.riscv32-embedded;
  in
    flake-utils.lib.eachSystem hostSystems (
      system: let
        pkgs = import nixpkgs {inherit system crossSystem;};
      in {
        packages.fifth = pkgs.callPackage ./fifth.nix {};
        packages.default = self.packages.${system}.fifth;
        devShells.default = pkgs.callPackage ./shell.nix {};
        formatter = pkgs.buildPackages.alejandra;
      }
    );
}
