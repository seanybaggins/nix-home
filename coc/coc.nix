pkgs:
''
{
    "rust-analyzer.checkOnSave.allTargets": false,
    "rust-analyzer.runnables.cargoExtraArgs": [
        "--target",
        "thumbv7em-none-eabihf"
    ],
    "rust-analyzer.procMacro.enable": true,
    "rust-analyzer.cargo.loadOutDirsFromCheck": true,
    "rust-analyzer.server.path": "${pkgs.rust-analyzer}/bin/rust-analyzer",

    "languageserver": {
    "nix": {
      "command": "nil",
      "filetypes": ["nix"],
      "rootPatterns":  ["flake.nix"],
       "settings": {
         "nil": {
           "formatting": { "command": ["nixpkgs-fmt"] }
         }
       }
    }
  }
}
''
