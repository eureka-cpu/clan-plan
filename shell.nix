{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  packages = with pkgs.elmPackages; [
    elm
    nodejs
  ];
}
