{ pkgs ? import <nixpkgs> {}, ... }:
pkgs.stdenv.mkDerivation {
  pname = "fifth";
  version = "0.1.0";
  src = ./.;
  nativeBuildInputs = [pkgs.gforth];
  dontPatch = true;
  dontConfigure = true;
  makeFlags = ["PREFIX=$(out)"];
}
