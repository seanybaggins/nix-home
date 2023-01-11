{ pkgs ? import <nixpkgs> {} }:
#{ pkgs ? import (fetchTarball "TODO") {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    #TODO
  ];
  nativeBuildInputs = with pkgs; [
    #TODO
  ];
}

