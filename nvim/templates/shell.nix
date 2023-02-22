{ pkgs ? import <nixpkgs> {} }:
#{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/TODO.tar.gz") {}}:

pkgs.mkShell {
  buildInputs = with pkgs; [

  ];

  shellHook = ''
    echo hello
  '';

  MY_ENVIRONMENT_VARIABLE = "world";
}
