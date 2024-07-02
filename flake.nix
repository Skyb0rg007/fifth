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
        fifth = pkgs.callPackage ({gforth, ...}:
          pkgs.stdenv.mkDerivation {
            pname = "fifth";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [gforth];
            dontPatch = true;
            dontConfigure = true;
            makeFlags = ["PREFIX=$(out)"];
          }) {};
      in {
        packages.fifth = fifth;
        packages.default = fifth;
        devShells.default = pkgs.mkShell {
          inputsFrom = [fifth];
        };
        formatter = pkgs.buildPackages.alejandra;
      }
    );
}
