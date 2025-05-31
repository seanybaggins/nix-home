final: prev:

{
  #breezy-desktop = final.callPackage ./pkgs/breezy-desktop { };

  #xr-linux-driver = final.callPackage ./pkgs/xr-linux-driver { };

  plaid2qif = final.callPackage ./pkgs/plaid2qif { };

  mintable = final.callPackage ./pkgs/mintable { };
  #flowkey_dl = final.callPackage ./pkgs/flowkey_dl {
  #  buildPythonPackage = prev.python3Packages.buildPythonPackage;
  #  py = prev.python3Packages.py;
  #  setuptools = prev.python3Packages.setuptools;
  #  wheel = prev.python3Packages.wheel;
  #  requests = prev.python3Packages.requests;
  #  imageio = prev.python3Packages.imageio;
  #  importlib-metadata = prev.python3Packages.importlib-metadata;
  #  matplotlib = prev.python3Packages.matplotlib;
  #};

}
