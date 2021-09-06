{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  name = "hqplayerd-docker";

  nativeBuildInputs = [
    gnumake
    docker
    dive
  ];
}
