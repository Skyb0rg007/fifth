{ pkgs ? import <nixpkgs> {}, ... }:
pkgs.mkShell {
  nativeBuildInputs = [pkgs.gforth];
}
